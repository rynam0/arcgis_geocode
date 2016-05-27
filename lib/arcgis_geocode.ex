defmodule ArcgisGeocode do

  @auth_url "https://www.arcgis.com/sharing/rest/oauth2/token"
  @client_id Application.get_env(:arcgis_geocode, :client_id)
  @client_secret Application.get_env(:arcgis_geocode, :client_secret)
  @grant_type "client_credentials"

  @doc """
  Geocodes the given address and returns a map.
  """
  def geocode(address) when is_binary(address) do
    get_url(address)
    |> HTTPoison.get
    |> parse_geocode_response
    |> extract_geocoded_address
  end

  defp parse_geocode_response({:ok, %{body: body}}), do: Poison.Parser.parse!(body)

  defp extract_geocoded_address(%{"locations" => [h|_]}) do
    feature = h["feature"]
    attributes = feature["attributes"]
    %{lat: feature["geometry"]["x"],
      lon: feature["geometry"]["y"],
      street_number: attributes["AddNum"],
      street: "#{attributes["StName"]} #{attributes["StType"]}",
      city: attributes["City"],
      state: attributes["Region"],
      zip_code: attributes["Postal"],
      formatted: h["name"]}
  end

  @doc """
  Authenticates with the ArcGIS Geocoding API and returns an auth token when successful.
  """
  def authenticate do
    body = {:form, [{:client_id, @client_id}, {:client_secret, @client_secret}, {:grant_type, @grant_type}]}
    HTTPoison.post(@auth_url, body)
    |> extract_access_token
  end

  defp extract_access_token({:ok, %{body: body}}), do: Poison.Parser.parse!(body)["access_token"]

  def get_url(address) do
    address = URI.encode(address)
    token = authenticate()
    "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find?outFields=AddNum,StName,StType,City,Region,Postal&forStorage=%s&f=json&text=#{address}&token=#{token}"
  end

end
