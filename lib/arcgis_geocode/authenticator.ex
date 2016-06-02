defmodule ArcgisGeocode.Authenticator do

  @auth_url "https://www.arcgis.com/sharing/rest/oauth2/token"
  @client_id Application.get_env(:arcgis_geocode, :client_id)
  @client_secret Application.get_env(:arcgis_geocode, :client_secret)
  @grant_type "client_credentials"


  def get_token do
    case ArcgisGeocode.Cache.get do
      %{"access_token" => access_token, "expiration" => expiration} ->
        case expired?(expiration) do
          false -> {:ok, access_token}
          true -> authenticate
        end
      %{} -> authenticate
    end
  end


  def authenticate do
    body = {:form, [{:client_id, @client_id}, {:client_secret, @client_secret}, {:grant_type, @grant_type}]}
    case HTTPoison.post(@auth_url, body) do
      {:error, response} -> {:error, %{"error" => %{"reason" => response.reason}}}
      {:ok, response} -> Poison.Parser.parse!(response.body) |> process_authentication_response
    end
  end


  defp process_authentication_response(%{"error" => _} = error), do: {:error, error}
  defp process_authentication_response(%{"access_token" => access_token, "expires_in" => expires_in}) do
    ArcgisGeocode.Cache.put(access_token, process_expiration(expires_in))
    {:ok, access_token}
  end


  def process_expiration(seconds) when is_number(seconds) do
    Timex.DateTime.now |> Timex.DateTime.shift(seconds: seconds - 300)
  end

  def expired?(nil), do: false
  def expired?(expiration) do
    if Timex.DateTime.diff(Timex.DateTime.now, expiration) <= 0 do
      true
    else
      false
    end
  end

end