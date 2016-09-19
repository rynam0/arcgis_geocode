defmodule ArcgisGeocode.Mixfile do
  use Mix.Project

  def project do
    [app: :arcgis_geocode,
     version: "0.2.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       "coveralls": :test,
       "coveralls.detail": :test,
       "coveralls.post": :test,
       "coveralls.html": :test,
       "coveralls.semaphore": :test],
     deps: deps(),
     dialyzer: [plt_add_apps: [:httpoison, :poison]],
     source_url: "https://github.com/rynam0/arcgis_geocode",
     docs: [extras: ["README.md"]],
     package: package(),
     description: description()]
  end

  def package do
    [maintainers: ["Ryan Connolly"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/rynam0/arcgis_geocode"}]
  end

  def description do
    "An Elixir client library for interacting with the ArcGIS geocoding APIs"
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison],
     mod: {ArcgisGeocode, []}]
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
    [{:httpoison, "~> 0.9"},
     {:poison, "~> 2.2"},
     {:excoveralls, "~> 0.5", only: :test},
     {:ex_doc, "~> 0.13", only: :dev},
     {:earmark, "~> 1.0", only: :dev},
     {:dialyxir, "~> 0.3", only: :dev}]
  end
end
