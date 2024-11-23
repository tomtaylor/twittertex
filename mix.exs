defmodule Twittertex.Mixfile do
  use Mix.Project

  @version "0.5.0"

  def project do
    [
      app: :twittertex,
      version: @version,
      elixir: "~> 1.16",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      dialyzer: dialyzer()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:phoenix_html, "~> 2.5 or ~> 3.0 or ~> 4.0"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:jason, "~> 1.2", only: :test},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    Formats a tweet as HTML, using the entities from its JSON structure.
    """
  end

  defp package do
    [
      files: ["lib", "test", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Tom Taylor <tom@tomtaylor.co.uk>"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/tomtaylor/twittertex"}
    ]
  end

  defp dialyzer do
    [
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end
end
