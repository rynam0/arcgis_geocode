defmodule ArcgisGeocode.Cache do

  @doc """
  Called by the `ArcgisGeocode` application on start, starts this Agent.
  """
  def start_link, do: Agent.start_link(fn -> Map.new end, name: __MODULE__)

  @doc """
  Stores the given access token and expiration Date as process state.
  """
  def put(token, expiration) do
    Agent.update(__MODULE__, fn(map) ->
      map |> Map.put("access_token", token) |> Map.put("expiration", expiration)
    end)
  end

  @doc """
  Retrieves the previously stored access token.
  """
  def get(), do: Agent.get(__MODULE__, &(&1))

  @doc """
  Clears the access token and expiration entries.
  """
  def clear() do
    Agent.update(__MODULE__, fn(map) ->
      Map.drop(map, ["access_token", "expiration"])
    end)
  end

end
