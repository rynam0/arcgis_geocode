# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :arcgis_geocode,
  client_id: System.get_env("ARCGIS_CLIENT_ID"),
  client_secret: System.get_env("ARCGIS_CLIENT_SECRET")
