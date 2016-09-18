defmodule ArcgisGeocode.UsStatesTest do
  use ExUnit.Case, async: true
  doctest ArcgisGeocode.UsStates

  alias ArcgisGeocode.UsStates

  test "can get abbr" do
    assert UsStates.get_abbr("Vermont") == "VT"
  end

  test "unknown state returns nil" do
    assert UsStates.get_abbr("Vtz") == nil
  end

  test "can get name" do
    assert UsStates.get_name("VT") == "Vermont"
  end

  test "unknown abbr returns nil" do
    assert UsStates.get_name("VTZ") == nil
  end

end
