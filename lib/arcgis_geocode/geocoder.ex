defmodule ArcgisGeocode.Geocoder do

  @moduledoc """
  Geocodes a given Address and returns an `ArcgisGeocode.GeocodeResult`.
  """

  alias ArcgisGeocode.{Authenticator, GeocodeResult, UsStates}

  @find_url "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find?outFields=AddNum,StName,StType,City,Region,Postal&forStorage=false&f=json&text="

  @doc """
  Returns an error response stating that there is no address to geocode.
  """
  def geocode(""), do: {:error, %GeocodeResult{error: "An address is required"}}
  @doc """
  Returns an error response stating that there is no address to geocode.
  """
  def geocode(nil), do: {:error, %GeocodeResult{error: "An address is required"}}
  @doc """
  Geocodes the given address and returns an `ArcgisGeocode.GeocodeResult` struct.
  """
  @spec geocode(String.t) :: {atom, ArcgisGeocode.GeocodeResult.t}
  def geocode(address) when is_binary(address) do
    case Authenticator.get_token do
      {:ok, access_token} ->
        get_url(address, access_token)
        |> HTTPoison.get
        |> parse_geocode_response
        |> extract_geocoded_address
      {_, _} = auth_error -> auth_error
    end
  end


  defp parse_geocode_response({:ok, %{body: body}}), do: Poison.Parser.parse!(body)

  defp parse_geocode_response({:error, %{reason: reason}}), do: {:error, reason}


  defp extract_geocoded_address({:error, reason}), do: {:error, %{"error" => "API #{reason}"}}

  defp extract_geocoded_address(%{"locations" => []}), do: {:ok, %{}}

  defp extract_geocoded_address(%{"locations" => [result|_]}) do
    feature = result["feature"]
    attributes = feature["attributes"]
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
        formatted: result["name"]}}
  end


  defp get_url(address, token) when is_binary(address) and is_binary(token) do
    address = URI.encode(address)
    "#{@find_url}#{address}&token=#{token}"
  end

end
