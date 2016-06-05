defmodule CacheTest do
  use ExUnit.Case
  doctest ArcgisGeocode.Cache

  alias ArcgisGeocode.Cache

  setup do
    ArcgisGeocode.Cache.clear
    :ok
  end

  test "can put, get and update a token" do
    expiration = Timex.DateTime.shift(Timex.DateTime.now, seconds: 200)
    token1 = "myawesometoken"

    assert Cache.get == %{}
    assert Cache.put(token1, expiration) == :ok
    assert Cache.get == %{"access_token" => token1, "expiration" => expiration}
  end

end
