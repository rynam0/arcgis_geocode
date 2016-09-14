defmodule ArcgisGeocode.Cache do

  @moduledoc """
  An Agent implementation for storage of a previously requested access token and its expiration date.
  """


  @doc """
  Called by the `ArcgisGeocode` Application on start.
  """
  def start_link, do: Agent.start_link(fn -> Map.new end, name: __MODULE__)

  @doc """
  Stores the given access token and expiration Date for later use.
  """
  @spec put(String.t, Timex.DateTime.t) :: atom
  def put(token, expiration) do
    Agent.update(__MODULE__, fn(map) ->
      map |> Map.put("access_token", token) |> Map.put("expiration", expiration)
    end)
  end

  @doc """
  Retrieves the previously stored access token.
  """
  @spec get() :: map
  def get(), do: Agent.get(__MODULE__, &(&1))

  @doc """
  Clears the access token and expiration entries.
  """
  @spec clear() :: atom
  def clear() do
    Agent.update(__MODULE__, fn(map) ->
      Map.drop(map, ["access_token", "expiration"])
    end)
    |> IO.inspect
  end

end
