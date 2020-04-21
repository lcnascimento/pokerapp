defmodule UsersService.MixProject do
  use Mix.Project

  def project do
    [
      app: :users_service,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {UsersService, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:xandra, "~> 0.11"},
      {:poison, "~> 3.1"}
    ]
  end
end
