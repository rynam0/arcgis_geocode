defmodule AuthenticatorTest do
  use ExUnit.Case, async: false
  doctest ArcgisGeocode.Authenticator

  alias ArcgisGeocode.Authenticator

  setup do
    ArcgisGeocode.Cache.clear
    :ok
  end

  test "authenticate returns an access token" do
    assert {:ok, _} = Authenticator.authenticate
  end

  test "get_token returns a cached token" do
    token = "secret!"
    expiration = Timex.DateTime.shift(Timex.DateTime.now, seconds: 200)

    refute Authenticator.get_token == {:ok, token}
    assert ArcgisGeocode.Cache.put(token, expiration) == :ok
    assert Authenticator.get_token == {:ok, token}
  end

  test "get_token authenticates with expired token" do
    assert ArcgisGeocode.Cache.put("secret", Timex.DateTime.now) == :ok

    {:ok, _token} = Authenticator.get_token
    refute Authenticator.get_token == {:ok, "secret"}
  end

  test "authentication fails" do
    # store the good config
    client_id = Application.get_env(:arcgis_geocode, :client_id)

    # configure with bad client_id
    Mix.Config.persist(arcgis_geocode: [client_id: "badid"])

    # authenticate
    {:error, "Invalid client_id"} = Authenticator.get_token

    # restore our config
    Mix.Config.persist(arcgis_geocode: [client_id: client_id])
  end

end
