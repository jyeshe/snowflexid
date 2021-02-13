defmodule SnowflakeId.MixProject do
  use Mix.Project

  @version "0.1.0"

  @description """
  Generator of Snowflake ID which is smaller and faster than Ecto UUIDv4 (but not random).
  """

  def project do
    [
      app: :snowflex,
      version: @version,
      description: @description,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/jyeshe/snowflex",
      docs: [
        main: "Snowflex"
      ]
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE*"],
      maintainers: ["Rogerio Pontual"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/jyeshe/snowflex"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, ">0.0.0", only: :dev},
      {:ecto_sql, ">0.0.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
