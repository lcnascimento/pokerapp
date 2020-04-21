defmodule UsersService.MixProject do
  use Mix.Project

  def project do
    [
      app: :users_service,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {UsersService, []},
      extra_applications: [:logger, :kafka_ex, :snappy]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:xandra, "~> 0.11"},
      {:poison, "~> 3.1"},
      {:kafka_ex, "~> 0.9.0"},
      {:snappy, git: "https://github.com/fdmanana/snappy-erlang-nif"}
    ]
  end
end
