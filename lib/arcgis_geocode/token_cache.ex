defmodule ArcgisGeocode.TokenCache do
  use GenServer

  @moduledoc """
  A `GenServer` implementation for storing an API authentication token (and its expiration date) in an ETS table.
  By caching the token, many geocoding requests can be made with the library handling the token behind the scenes.
  """

  @table :arcgis_geocodetoken_cache
  @key "token"

  @doc """
  Called by the `Arcgis` application on start.
  """
  def start_link, do: GenServer.start_link(__MODULE__, :ok, [])

  def init(_args) do
    ets = :ets.new(@table, [:named_table, :public, read_concurrency: true])
    {:ok, ets}
  end

  def terminate(reason, state) do
    :ets.delete(@table)
    {reason, state}
  end

  @doc """
  Puts an authentication token into an ETS table along with its expiration date.
  """
  @spec put(String.t, any) :: {:ok, String.t}
  def put(token, expiry) do
    :ets.insert(@table, {@key, token, expiry})
    {:ok, token}
  end

  @doc """
  Retrieves a cached authentication token from an ETS table along with its expiration date.
  """
  @spec lookup() :: {:ok, {String.t, any} | nil}
  def lookup() do
    :ets.lookup(@table, @key)
    |> handle_lookup
  end

  defp handle_lookup([{@key, token, expiry}]), do: {:ok, {token, expiry}}
  defp handle_lookup([]), do: {:ok, nil}
end
