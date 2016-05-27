defmodule AuthenticatorTest do
  use ExUnit.Case
  doctest ArcgisGeocode.Authenticator

  alias ArcgisGeocode.Authenticator

  test "authenticate returns an access token" do
    assert {:ok, _} = Authenticator.authenticate
  end

end
