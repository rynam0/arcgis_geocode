defmodule GeocoderTest do
  use ExUnit.Case, async: true
  doctest ArcgisGeocode.Geocoder

  alias ArcgisGeocode.{Geocoder, GeocodeResult}

  setup do
    ArcgisGeocode.Cache.clear
    :ok
  end

  test "geocodes a good address" do
    geocoded = Geocoder.geocode("463 Mountain View Dr Colchester VT 05446")
    assert geocoded == {:ok, %GeocodeResult{
                              city: "Colchester", formatted: "463 Mountain View Dr, Colchester, Vermont, 05446",
                              lat: 44.51295979206185, lon: -73.18369670074134, state_name: "Vermont", state_abbr: "VT",
                              street_name: "Mountain View", street_type: "Dr", street_number: "463", zip_code: "05446"}}

  end

  test "does not geocode an empty address" do
    {:error, %GeocodeResult{error: "An address is required"}} = Geocoder.geocode("")
  end

  test "does not geocode a nil address" do
    {:error, %GeocodeResult{error: "An address is required"}} = Geocoder.geocode(nil)
  end


  test "authentication fails" do
    # store the good config
    client_id = Application.get_env(:arcgis_geocode, :client_id)

    # configure with bad client_id
    Mix.Config.persist(arcgis_geocode: [client_id: "badid"])

    # authenticate
    {:error, "Invalid client_id"} = Geocoder.geocode("463 Mountain View Dr Colchester VT 05446")

    # restore our config
    Mix.Config.persist(arcgis_geocode: [client_id: client_id])
  end
end
