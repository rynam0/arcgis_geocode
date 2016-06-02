defmodule ArcgisGeocode do
  use Application

  def start(_type, _args), do: ArcgisGeocode.Cache.start_link

  def geocode(address), do: ArcgisGeocode.Geocoder.geocode(address)

end
