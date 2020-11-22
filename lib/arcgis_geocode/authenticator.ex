defmodule ArcgisGeocode.Authenticator do

  alias ArcgisGeocode.TokenCache

  @moduledoc """
  Provides the ability to request an access token from the
  [ArcGIS World Geocoding Service APIs](https://developers.arcgis.com/rest/geocode/api-reference/geocoding-authenticate-a-request.htm).
  """

  @auth_url "https://www.arcgis.com/sharing/rest/oauth2/token"
  @grant_type "client_credentials"

  @doc """
  Gets an authentication token for use in ArcGIS World Geocoding Service API operations and stores it for use in
  subsequent API requests by means of `ArcgisGeocode.TokenCache`.

  This function will first check the `ArcgisGeocode.TokenCache` for a cached authentication token and will return this token
  if it has not expired.  If the token has expired or no token has been cached, a new token is requested via an
  authentication request to the ArcGIS World Geocoding Service APIs and this new token is stored.
  """
  @spec get_token :: {atom, String.t}
  def get_token, do: TokenCache.lookup |> handle_token_lookup

  defp handle_token_lookup({:ok, nil}), do: authenticate()
  defp handle_token_lookup({:ok, {token, expiration}}) do
    case expired?(expiration) do
      true -> authenticate()
      false -> {:ok, token}
    end
  end

  defp expired?(nil), do: true
  defp expired?(expiration), do: :calendar.datetime_to_gregorian_seconds(:calendar.universal_time()) >= expiration

  defp authenticate do
    body = {:form, [{:client_id, Application.get_env(:arcgis_geocode, :client_id)},
                    {:client_secret, Application.get_env(:arcgis_geocode, :client_secret)},
                    {:grant_type, @grant_type}]}
    HTTPoison.post(@auth_url, body)
    |> handle_post()
  end

  defp handle_post({:ok, response}), do: Poison.Parser.parse!(response.body, %{}) |> handle_post_response
  defp handle_post({:error, response}), do: {:error, response.reason}

  defp handle_post_response(%{"error" => error}), do: {:error, error["message"]}
  defp handle_post_response(%{"access_token" => access_token, "expires_in" => expires_in}) do
    TokenCache.put(access_token, process_expiration(expires_in))
  end

  defp process_expiration(expires_in_seconds) do
    :calendar.datetime_to_gregorian_seconds(:calendar.universal_time()) + (expires_in_seconds - 300)
  end

end
