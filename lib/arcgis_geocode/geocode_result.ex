defmodule ArcgisGeocode.GeocodeResult do

  @moduledoc """
  Defines a `Struct` that is used for Geocoding responses.


  ### Example

      iex>%ArcgisGeocode.GeocodeResult{}
      %ArcgisGeocode.GeocodeResult{city: nil, formatted: nil, lat: nil, lon: nil,
      state_abbr: nil, state_name: nil, street_name: nil, street_number: nil,
      street_type: nil, zip_code: nil}
  """

  defstruct formatted: nil, lat: nil, lon: nil, street_number: nil, street_name: nil, street_type: nil, city: nil,
            state_name: nil, state_abbr: nil, zip_code: nil

end
