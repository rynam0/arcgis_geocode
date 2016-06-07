defmodule ArcgisGeocode.UsStates do

  @moduledoc """
  Provides the ability to look up a US State name by its abbreviation and vice-versa.
  """

  @map %{"Alabama" => "AL", "Alaska" => "AK", "American Samoa" => "AS", "Arizona" => "AZ", "Arkansas" => "AR",
         "California" => "CA", "Colorado" => "CO", "Connecticut" => "CT", "Delaware" => "DE",
         "District of Columbia" => "DC", "Florida" => "FL", "Georgia" => "GA", "Guam" => "GU", "Hawaii" => "HI",
         "Idaho" => "ID", "Illinois" => "IL", "Indiana" => "IN", "Iowa" => "IA", "Kansas" => "KS", "Kentucky" => "KY",
         "Louisiana" => "LA", "Maine" => "ME", "Maryland" => "MD", "Massachusetts" => "MA", "Michigan" => "MI",
         "Minnesota" => "MN", "Mississippi" => "MS", "Missouri" => "MO", "Montana" => "MT", "Nebraska" => "NE",
         "Nevada" => "NV", "New Hampshire" => "NH", "New Jersey" => "NJ", "New Mexico" => "NM", "New York" => "NY",
         "North Carolina" => "NC", "North Dakota" => "ND", "Northern Mariana Islands" => "MP", "Ohio" => "OH",
         "Oklahoma" => "OK", "Oregon" => "OR", "Pennsylvania" => "PA", "Puerto Rico" => "PR", "Rhode Island" => "RI",
         "South Carolina" => "SC", "South Dakota" => "SD", "Tennessee" => "TN", "Texas" => "TX", "Utah" => "UT",
         "Vermont" => "VT", "Virgin Islands" => "VI", "Virginia" => "VA", "Washington" => "WA", "West Virginia" => "WV",
         "Wisconsin" => "WI", "Wyoming" => "WY"}

  @doc """
  Gets the US State abbreviation of the given US State name.

  ## Example

      iex>ArcgisGeocode.UsStates.get_abbr("Vermont")
      "VT"
  """
  @spec get_abbr(String.t) :: String.t
  def get_abbr(name), do: Map.get(@map, name)

  @doc """
  Gets the US State name of the given US State abbreviation.

  ## Example

      iex>ArcgisGeocode.UsStates.get_name("VT")
      "Vermont"
  """
  @spec get_name(String.t) :: String.t
  def get_name(abbr) do
    case Enum.find(@map, fn({_, item}) -> item == abbr end) do
      nil -> nil
      {name, _} -> name
    end
  end

end
