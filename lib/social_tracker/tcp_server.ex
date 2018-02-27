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
    :inet.setopts(acc, active: :once)
    {:noreply, state}
  end

  def handle_info({:tcp, s, data}, state) do
    Task.Supervisor.start_child(SocialTracker.TCPRequests, fn -> data |> dispatch() end)
    Process.send_after(self(), :accept, 0)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _listener}, state) do
    {:noreply, state}
  end

  def dispatch(data) do
    Registry.dispatch(SocialTracker.Registry, SocialTracker.Data, fn entries ->
      Logger.info "Got Data: #{inspect data}"
      for {pid, _} <- entries, do: send(pid, {:broadcast, data})
    end)
  end
end
