defmodule BoothNanoleaf.Mixfile do
  use Mix.Project

  def project do
    [app: :social_tracker,
     version: "0.1.0",
     elixir: "~> 1.5",
     target: @target,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SocialTracker.Application, []},
      extra_applications: [:logger, :twittex, :gen_stage]
    ]
  end

  def deps do
    [
      {:twittex, "~> 0.3.4"},
      {:gen_stage, "~> 0.12.2"},
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.4"}
    ]
  end

end
