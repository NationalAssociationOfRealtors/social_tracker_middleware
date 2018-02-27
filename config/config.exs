# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :logger, level: :info

config :social_tracker, http_port: 8080
config :social_tracker, twitter_filter: "#TuesdayThoughts"

config :twittex,
  token: System.get_env("TWITTER_TOKEN"),
  token_secret: System.get_env("TWITTER_SECRET"),
  consumer_key: System.get_env("TWITTER_CONSUMER_TOKEN"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
