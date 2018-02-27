defmodule SocialTracker.Application do
  use Application
  require Logger

  @http_port Application.get_env(:social_tracker, :http_port, 8080)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      supervisor(Registry, [:duplicate, SocialTracker.Registry, []]),
      supervisor(Task.Supervisor, [[name: SocialTracker.TCPRequests]]),
      worker(SocialTracker.TCPServer, []),
      Plug.Adapters.Cowboy.child_spec(:http, SocialTracker.HTTPRouter, [], [port: @http_port, dispatch: dispatch()]),
    ]

    opts = [strategy: :one_for_one, name: SocialTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_, [
        {"/ws", SocialTracker.WebSocketHandler, []},
        {:_, Plug.Adapters.Cowboy.Handler, {SocialTracker.HTTPRouter, []}}
      ]}
    ]
  end
end
