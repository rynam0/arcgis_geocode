defmodule ArcgisGeocode do
  use Application

  @moduledoc """
  Provides the ability to Geocode an Address using the
  [ArcGIS World Geocoding Service REST API](https://developers.arcgis.com/rest/geocode/api-reference/geocoding-find.htm)
  "find" operation.
  """



  @doc """
  Starts the application and the `ArcgisGeocode.TokenCache` GenServer.

  Note: Developers typically won't be calling this function directly.
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(SupPoc.Worker, [arg1, arg2, arg3]),
      worker(ArcgisGeocode.TokenCache, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ArcgisGeocode.Supervisor]
    Supervisor.start_link(children, opts)
  end




  @doc ~S"""
    Geocodes an Address and returns an `ArcgisGeocode.GeocodeResult` struct.

  ## Examples
        iex>ArcgisGeocode.geocode("463 Mountain View Dr Colchester VT 05446")
        {:ok,
         %ArcgisGeocode.GeocodeResult{city: "Colchester",
          formatted: "463 Mountain View Dr, Colchester, Vermont, 05446",
          lat: 44.510113990171874, lon: -73.1855000244386,
          state_abbr: "VT", state_name: "Vermont", street_name: "Mountain View",
          street_number: "463", street_type: "Dr", zip_code: "05446"}}
  """
  @spec geocode(String.t) :: {:ok, struct | nil} | {:error, binary}
  def geocode(address), do: ArcgisGeocode.Geocoder.geocode(address)

end
