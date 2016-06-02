defmodule ArcgisGeocode.Cache do

  def start_link, do: Agent.start_link(fn -> Map.new end, name: __MODULE__)

  def put(token, expiration) do
    Agent.update(__MODULE__, fn(map) ->
      map |> Map.put("access_token", token) |> Map.put("expiration", expiration)
    end)
  end

  def get(), do: Agent.get(__MODULE__, &(&1))

  def clear() do
    Agent.update(__MODULE__, fn(map) ->
      Map.drop(map, ["access_token", "expiration"])
    end)
  end

end
