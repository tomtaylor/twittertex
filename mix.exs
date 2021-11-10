defmodule Twittertex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :twittertex,
      version: "0.3.0",
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:phoenix_html, "~> 2.5 or ~> 3.0"},
      {:jason, "~> 1.2", only: :test},
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
end
