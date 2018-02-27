defmodule SocialTracker.TCPServer do
  use GenServer
  require Logger

  @port Application.get_env(:social_tracker, :tcp_port, 8307)

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, tcp} = :gen_tcp.listen(@port, [:binary, active: :once, reuseaddr: true])
    Process.send_after(self(), :accept, 0)
    {:ok, %{server: tcp}}
  end

  def handle_info(:accept, state) do
    {:ok, acc} = :gen_tcp.accept(state.server)
    {:noreply, state}
  end

  def handle_info({:tcp, s, data}, state) do
    Logger.info "Data: #{inspect data}"
    Task.Supervisor.start_child(SocialTracker.TCPRequests, fn -> data |> dispatch() end)
    :inet.setopts(s, active: :once)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, client}, state) do
    Logger.debug "Client Closed connection"
    Process.send_after(self(), :accept, 0)
    :gen_tcp.close(client)
    {:noreply, state}
  end

  def dispatch(data) do
    data = Poison.decode!(data)
    type = Map.get(data, "type")
    Registry.dispatch(SocialTracker.Registry, type, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:broadcast, data})
    end)
  end
end
