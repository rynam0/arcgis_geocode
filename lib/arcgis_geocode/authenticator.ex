defmodule ArcgisGeocode.Authenticator do

  @auth_url "https://www.arcgis.com/sharing/rest/oauth2/token"
  @client_id Application.get_env(:arcgis_geocode, :client_id)
  @client_secret Application.get_env(:arcgis_geocode, :client_secret)
  @grant_type "client_credentials"


  def authenticate do
    body = {:form, [{:client_id, @client_id}, {:client_secret, @client_secret}, {:grant_type, @grant_type}]}
    case HTTPoison.post(@auth_url, body) do
      {:error, response} -> {:error, %{"error" => %{"reason" => response.reason}}}
      {:ok, response} ->
        Poison.Parser.parse!(response.body)
        |> process_authentication_response
    end
  end

  defp process_authentication_response(%{"error" => _} = error), do: {:error, error}
  defp process_authentication_response(%{"access_token" => access_token, "expires_in" => expires_in}) do
    {:ok, %{"access_token" => access_token, "expires_in" => expires_in}}
  end

end
