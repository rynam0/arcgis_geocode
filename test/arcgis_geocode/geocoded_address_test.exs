defmodule GeocodedAddressTest do
  use ExUnit.Case, async: true

  alias ArcgisGeocode.{GeocodedAddress, UsStates}

  test "can create with US State info" do
    address = %GeocodedAddress{state_name: "Vermont", state_abbr: UsStates.get_abbr("Vermont")}
    assert address.state_name == "Vermont"
    assert address.state_abbr == "VT"
  end

end
