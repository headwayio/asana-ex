defmodule AsanaEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :asana_ex,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AsanaEx.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~>0.8.1"},
      {:jason, "~>1.2"},
      {:bypass, "~>2.1.0", only: :test}
    ]
  end
end
