# ArcgisGeocode

[![Build Status](https://semaphoreci.com/api/v1/rynam0/arcgis_geocode/branches/master/badge.svg)](https://semaphoreci.com/rynam0/arcgis_geocode)
[![Coverage Status](https://coveralls.io/repos/github/rynam0/arcgis_geocode/badge.svg?branch=master)](https://coveralls.io/github/rynam0/arcgis_geocode?branch=master)

**Provides basic geocoding capabilities via the ArcGIS World Geocoding Service REST APIs**

## Installation

The package can be installed from Hex as:

  1. Add arcgis_geocode to your list of dependencies in `mix.exs`:

         def deps do
           [{:arcgis_geocode, "~> 0.2.0"}]
         end

  2. Ensure arcgis_geocode is started before your application:

         def application do
           [applications: [:arcgis_geocode]]
         end

  3. Configure the arcgis_geocode application to use your ArcGIS credentials:

         config :arcgis_geocode,
           client_id: "YOUR_CLIENT_ID",
           client_secret: "YOUR_CLIENT_SECRET"
