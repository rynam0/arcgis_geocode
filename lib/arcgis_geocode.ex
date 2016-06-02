defmodule ArcgisGeocode do
  use Application

  @doc """
  Starts the application and the token Cache Agent.
  """
  def start(_type, _args), do: ArcgisGeocode.Cache.start_link

  @doc """
  Geocodes the given address
  """
  def geocode(address), do: ArcgisGeocode.Geocoder.geocode(address)

end
