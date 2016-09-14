defmodule ArcgisGeocode.Mixfile do
  use Mix.Project

  def project do
    [app: :arcgis_geocode,
     version: "0.0.1",
     name: "ArcgisGeocode",
     source_url: "https://github.com/rynam0/arcgis_geocode",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       "coveralls": :test,
       "coveralls.detail": :test,
       "coveralls.post": :test,
       "coveralls.html": :test,
       "coveralls.semaphore": :test
     ],
     deps: deps,
     dialyzer: [plt_add_apps: [:httpoison, :poison, :timex]],
     docs: [
       main: "ArcgisGeocode"
     ],
     package: package(),
     description: description()]
  end

  def package do
    [maintainers: ["@rynam0"],
     links: %{"GitHub" => "https://github.com/rynam0/arcgis_geocode"}]
  end

  def description do
    "An Elixir client library for interacting with the ArcGIS geocoding APIs"
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :httpoison, :timex],
      mod: {ArcgisGeocode, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.8.3"},
     {:poison, "~> 2.0.0"},
     {:timex, "~> 2.1.6"},
     {:excoveralls, "~> 0.5", only: :test},
     {:ex_doc, "~> 0.11.5", only: :dev},
     {:earmark, "~> 0.2.1", only: :dev},
     {:dialyxir, "~> 0.3.3", only: :dev}]
  end
end
