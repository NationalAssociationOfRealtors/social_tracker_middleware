# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :logger, level: :info

config :social_tracker, http_port: System.get_env("HTTP_PORT") || "8080"
config :social_tracker, tcp_port: System.get_env("TCP_PORT") || "8307"
config :social_tracker, num_acceptors: System.get_env("NUM_ACCEPTORS") || "5"
# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
