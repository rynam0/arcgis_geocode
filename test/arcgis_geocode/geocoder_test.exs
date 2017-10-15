defmodule ArcgisGeocode.GeocoderTest do
  use ExUnit.Case, async: true
  doctest ArcgisGeocode.Geocoder

  alias ArcgisGeocode.Geocoder


  test "geocodes a good address" do
    geocoded = Geocoder.geocode("463 Mountain View Dr Colchester VT 05446")
    assert geocoded == {:ok, %ArcgisGeocode.GeocodeResult{city: "Colchester",
                              formatted: "463 Mountain View Dr, Colchester, Vermont, 05446",
                              lat: 44.5129518506838, lon: -73.1836996439205, state_abbr: "VT",
                              state_name: "Vermont", street_name: "Mountain View", street_number: "463",
                              street_type: "Dr", zip_code: "05446"}}
  end

  test "does not geocode an empty address" do
    {:ok, nil} = Geocoder.geocode("")
  end


  test "authentication fails" do
    # store the good config
    client_id = Application.get_env(:arcgis_geocode, :client_id)

    # configure with bad client_id
    Mix.Config.persist(arcgis_geocode: [client_id: "badid"])

    # put an expired token to force authentication
    now = :calendar.datetime_to_gregorian_seconds(:calendar.universal_time())
    {:ok, "secret"} = ArcgisGeocode.TokenCache.put("secret", now)

    {:error, "Invalid client_id"} = Geocoder.geocode("463 Mountain View Dr Colchester VT 05446")

    # restore our config
    Mix.Config.persist(arcgis_geocode: [client_id: client_id])
  end
end
