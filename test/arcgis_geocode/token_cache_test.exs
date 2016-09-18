defmodule ArcgisGeocode.TokenCacheTest do
  use ExUnit.Case
  doctest ArcgisGeocode.TokenCache

  alias ArcgisGeocode.TokenCache


  test "can put, get and update a token" do
    expiration = :calendar.datetime_to_gregorian_seconds(:calendar.universal_time()) + 200
    token1 = "myawesometoken"

    assert TokenCache.put(token1, expiration) == {:ok, token1}
    assert TokenCache.lookup == {:ok, {token1, expiration}}
  end

  test "can terminate and start" do
    {:test, :testing} = TokenCache.terminate(:test, :testing)
    {:ok, _pid} = TokenCache.start_link
  end

end
