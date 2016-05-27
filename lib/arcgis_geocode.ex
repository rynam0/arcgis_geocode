defmodule ArcgisGeocode do

  @auth_url "https://www.arcgis.com/sharing/rest/oauth2/token"
  @client_id Application.get_env(:arcgis_geocode, :client_id)
  @client_secret Application.get_env(:arcgis_geocode, :client_secret)
  @grant_type "client_credentials"

  @doc """
  Geocodes the given address and returns a map.
  """
  def geocode(address) when is_binary(address) do
    case authenticate do
      {:error, response} -> response
      {:ok, response} ->
        get_url(address, response["access_token"])
        |> HTTPoison.get
        |> parse_geocode_response
        |> extract_geocoded_address
    end
  end


  defp parse_geocode_response({:ok, %{body: body}}), do: parse_response(body)
  defp parse_geocode_response({:error, %{reason: reason}}), do: {:error, reason}
  defp parse_geocode_response(%{"error" => _} = error), do: {:error, error}


  defp extract_geocoded_address({:error, reason}), do: {:error, %{"error" => "API #{reason}"}}

  defp extract_geocoded_address(%{"locations" => [h|_]}) do
    feature = h["feature"]
    attributes = feature["attributes"]
    {:ok,
      %{lat: feature["geometry"]["x"],
        lon: feature["geometry"]["y"],
        street_number: attributes["AddNum"],
        street: "#{attributes["StName"]} #{attributes["StType"]}",
        city: attributes["City"],
        state: attributes["Region"],
        zip_code: attributes["Postal"],
        formatted: h["name"]}}
  end

  @doc """
  Authenticates with the ArcGIS Geocoding API and returns an auth token when successful.
  """
  def authenticate do
    body = {:form, [{:client_id, @client_id}, {:client_secret, @client_secret}, {:grant_type, @grant_type}]}
    case HTTPoison.post(@auth_url, body) do
      {:error, response} -> {:error, %{"error" => %{"reason" => response.reason}}}
      {:ok, response} ->
        parse_response(response.body)
        |> process_authentication_response
    end
  end

  defp process_authentication_response(%{"error" => _} = error), do: {:error, error}
  defp process_authentication_response(%{"access_token" => access_token, "expires_in" => expires_in}) do
    {:ok, %{"access_token" => access_token, "expires_in" => expires_in}}
  end


  defp parse_response(body) when is_binary(body) do
    Poison.Parser.parse!(body)
  end


  def get_url(address, token) when is_binary(address) and is_binary(token) do
    address = URI.encode(address)
    "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find?outFields=AddNum,StName,StType,City,Region,Postal&forStorage=%s&f=json&text=#{address}&token=#{token}"
  end

end
