defmodule GeocodeResultTest do
  use ExUnit.Case, async: true
  doctest ArcgisGeocode.GeocodeResult

  alias ArcgisGeocode.{GeocodeResult, UsStates}

  test "can create with US State info" do
    address = %GeocodeResult{state_name: "Vermont", state_abbr: UsStates.get_abbr("Vermont")}
    assert address.state_name == "Vermont"
    assert address.state_abbr == "VT"
  end

end
