defmodule ArcgisGeocode.Geocoder do

  alias ArcgisGeocode.{Authenticator, GeocodeResult, UsStates}

  @moduledoc """
  Provides the ability to Geocode an Address using the
  [ArcGIS World Geocoding Service REST API](https://developers.arcgis.com/rest/geocode/api-reference/geocoding-find.htm)
  "find" operation.
  """

  @find_url "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find?outFields=AddNum,StName,StType,City,Region,Postal&forStorage=false&f=json"


  @doc ~S"""
  Geocodes an address and returns a `ArcgisGeocode.GeocodeResult` struct.

  ## Examples
        iex>ArcgisGeocode.Geocoder.geocode("463 Mountain View Dr Colchester VT 05446")
        {:ok,
         %ArcgisGeocode.GeocodeResult{city: "Colchester",
          formatted: "463 Mountain View Dr, Colchester, Vermont, 05446",
          lat: 44.50988024037724, lon: -73.18490967421624,
          state_abbr: "VT", state_name: "Vermont", street_name: "Mountain View",
          street_number: "463", street_type: "Dr", zip_code: "05446"}}
  """
  @spec geocode(String.t) :: {:ok, struct | nil} | {:error, binary}
  def geocode(address) when is_binary(address), do: Authenticator.get_token |> handle_token_result(address)

  defp handle_token_result({:error, _} = error, _), do: error
  defp handle_token_result({:ok, token}, address) do
    get_url(address, token)
    |> HTTPoison.get
    |> handle_get
  end


  defp get_url(address, token), do: "#{@find_url}&text=#{URI.encode(address)}&token=#{token}"

  defp handle_get({:ok, response}), do: Poison.Parser.parse!(response.body, %{}) |> handle_get_response
  defp handle_get({:error, response}), do: {:error, response.reason}

  defp handle_get_response(%{"error" => error}), do: {:error, error["message"]}
  defp handle_get_response(%{"locations" => []}), do: {:ok, nil}
  defp handle_get_response(%{"locations" => [location|_]}), do: create_result(location)

  defp create_result(%{"feature" => %{"attributes" => attributes} = feature} = location) do
    {:ok,
      %GeocodeResult{
        lat: feature["geometry"]["y"],
        lon: feature["geometry"]["x"],
        street_number: attributes["AddNum"],
        street_name: attributes["StName"],
        street_type: attributes["StType"],
        city: attributes["City"],
        state_name: attributes["Region"],
        state_abbr: UsStates.get_abbr(attributes["Region"]),
        zip_code: attributes["Postal"],
        formatted: location["name"]}}
  end

end
