defmodule ArcgisGeocodeTest do
  use ExUnit.Case
  doctest ArcgisGeocode

  test "authenticate returns an access token" do
    token = ArcgisGeocode.authenticate
    assert token
  end

  test "geocodes a good address" do
    geocoded = ArcgisGeocode.geocode("463 Mountain View Dr Colchester VT 05446")
    assert geocoded == %{city: "Colchester", formatted: "463 Mountain View Dr, Colchester, Vermont, 05446",
                         lat: -73.18369670074134, lon: 44.51295979206185, state: "Vermont", street: "Mountain View Dr",
                         street_number: "463", zip_code: "05446"}
  end

end
