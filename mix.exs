defmodule PageWatcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :page_watcher,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpotion],
      mod: {PageWatcher.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mox, "~> 0.3", only: :test},
      {:httpotion, "~> 3.1.0"},
      {:json, "~> 0.3.0"}
    ]
  end
end
