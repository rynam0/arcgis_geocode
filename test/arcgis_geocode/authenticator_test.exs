defmodule ArcgisGeocode.AuthenticatorTest do
  use ExUnit.Case, async: false
  doctest ArcgisGeocode.Authenticator

  alias ArcgisGeocode.Authenticator

  test "get_token returns a cached token" do
    token = "secret!"
    expiration = :calendar.datetime_to_gregorian_seconds(:calendar.universal_time()) + 200
    {:ok, _token} = Authenticator.get_token
    refute Authenticator.get_token == token

    {:ok, _token} = ArcgisGeocode.TokenCache.put(token, expiration)
    {:ok, new_token} = Authenticator.get_token
    assert new_token == token
  end

  test "get_token authenticates with expired token" do
    now = :calendar.datetime_to_gregorian_seconds(:calendar.universal_time())
    {:ok, "secret"} = ArcgisGeocode.TokenCache.put("secret", now)

    {:ok, token} = Authenticator.get_token
    refute token == "secret"
  end

  test "authentication fails" do
    # store the good config
    client_id = Application.get_env(:arcgis_geocode, :client_id)

    # configure with bad client_id
    Mix.Config.persist(arcgis_geocode: [client_id: "badid"])

    # put an expired token to force authentication
    now = :calendar.datetime_to_gregorian_seconds(:calendar.universal_time())
    {:ok, "secret"} = ArcgisGeocode.TokenCache.put("secret", now)

    # authenticate
    {:error, "Invalid client_id"} = Authenticator.get_token

    # restore our config
    Mix.Config.persist(arcgis_geocode: [client_id: client_id])
  end

  @lookup_count 10000

  test "can get an authentication token" do
    {:ok, token} = Authenticator.get_token
    refute is_nil(token)
  end

  test "can lookup tokens concurrently" do
    # make sure a token is in the cache before doing look ups
    Authenticator.get_token
    # look up our cached token concurrently @lookup_count times
    tokens = 1..@lookup_count
    |> Enum.map(&Task.async(ArcgisGeocode.AuthenticatorTest, :get_token_job, [&1]))
    |> Enum.map(&Task.await(&1))
    assert Enum.count(tokens) == @lookup_count
  end

  def get_token_job(_args), do: {:ok, _} = Authenticator.get_token

end
