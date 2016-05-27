defmodule GeocoderTest do
  use ExUnit.Case
  doctest ArcgisGeocode.Geocoder

  alias ArcgisGeocode.Geocoder

  test "geocodes a good address" do
    geocoded = Geocoder.geocode("463 Mountain View Dr Colchester VT 05446")
    assert geocoded == {:ok, %{city: "Colchester", formatted: "463 Mountain View Dr, Colchester, Vermont, 05446",
                         lat: -73.18369670074134, lon: 44.51295979206185, state: "Vermont", street: "Mountain View Dr",
                         street_number: "463", zip_code: "05446"}}
  end

end
