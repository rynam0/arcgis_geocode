defmodule ArcgisGeocode.Geocoder do

  alias ArcgisGeocode.Authenticator

  @doc """
  Returns an error response stating that there is no address to geocode.
  """
  def geocode(""), do: {:error, %{"error" => "An address is required"}}
  @doc """
  Returns an error response stating that there is no address to geocode.
  """
  def geocode(nil), do: {:error, %{"error" => "An address is required"}}
  @doc """
  Geocodes the given address and returns a map.
  """
  def geocode(address) when is_binary(address) do
    {:ok, access_token} = Authenticator.get_token

    get_url(address, access_token)
    |> HTTPoison.get
    |> parse_geocode_response
    |> extract_geocoded_address
  end


  defp parse_geocode_response({:ok, %{body: body}}), do: Poison.Parser.parse!(body)

  defp parse_geocode_response({:error, %{reason: reason}}), do: {:error, reason}

  defp parse_geocode_response(%{"error" => _} = error), do: {:error, error}


  defp extract_geocoded_address({:error, reason}), do: {:error, %{"error" => "API #{reason}"}}

  defp extract_geocoded_address(%{"locations" => []}), do: {:ok, %{}}

  defp extract_geocoded_address(%{"locations" => [result|_]}) do
    feature = result["feature"]
    attributes = feature["attributes"]
    {:ok,
      %{lat: feature["geometry"]["x"],
        lon: feature["geometry"]["y"],
        street_number: attributes["AddNum"],
        street: "#{attributes["StName"]} #{attributes["StType"]}",
        city: attributes["City"],
        state: attributes["Region"],
        zip_code: attributes["Postal"],
        formatted: result["name"]}}
  end


  def get_url(address, token) when is_binary(address) and is_binary(token) do
    address = URI.encode(address)
    "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find?outFields=AddNum,StName,StType,City,Region,Postal&forStorage=false&f=json&text=#{address}&token=#{token}"
  end

end
