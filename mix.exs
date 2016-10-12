defmodule EspecRequestDescriber.Mixfile do
  use Mix.Project

  def project do
    [app: :espec_request_describer,
     version: "0.0.2",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end
end
