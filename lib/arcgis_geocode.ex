defmodule ArcgisGeocode do
  use Application

  @doc """
  Starts the application and the token Cache Agent.
  """
  def start(_type, _args), do: ArcgisGeocode.Cache.start_link

  @doc ~S"""
    Geocodes an Address.

    ## Examples
        iex>ArcgisGeocode.geocode("463 Mountain View Dr Colchester VT 05446")
        {:ok,
         %ArcgisGeocode.GeocodedAddress{city: "Colchester",
         formatted: "463 Mountain View Dr, Colchester, Vermont, 05446",
         lat: -73.18369670074134, lon: 44.51295979206185, state_abbr: "VT",
         state_name: "Vermont", street_name: "Mountain View", street_number: "463",
         street_type: "Dr", zip_code: "05446"}}
  """
  def geocode(address), do: ArcgisGeocode.Geocoder.geocode(address)

end
