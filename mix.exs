defmodule SocialTracker.Mixfile do
  use Mix.Project

  def project do
    [app: :social_tracker,
     version: "0.1.0",
     elixir: "~> 1.5",
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SocialTracker.Application, []},
      extra_applications: [:logger, :poison]
    ]
  end

  def deps do
    [
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.4"},
      {:poison, "~> 3.1"}
    ]
  end

end
