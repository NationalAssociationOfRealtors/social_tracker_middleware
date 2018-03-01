defmodule SocialTracker.TCPServer do
  use GenServer
  require Logger

  @port Application.get_env(:social_tracker, :tcp_port, "8307") |> String.to_integer()
  @num_acceptors Application.get_env(:social_tracker, :num_acceptors, "5") |> String.to_integer()

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, active: :once, reuseaddr: true, recbuf: 1000000])
    start_servers(@num_acceptors, socket)
    {:ok, %{}}
  end

  def start_servers(0, _), do: :ok
  def start_servers(num, socket) do
    Task.Supervisor.start_child(SocialTracker.TCPPool, SocialTracker.TCPServer, :accept, [socket, self()])
    start_servers(num - 1, socket)
  end

  def accept(socket, pid) do
    Logger.info "Accepting for PID: #{inspect pid}"
    {:ok, acc} = :gen_tcp.accept(socket)
    :gen_tcp.controlling_process(acc, pid)
    accept(socket, pid)
  end

  def handle_info({:tcp, s, data}, state) do
    Logger.info "Received Data: #{inspect data}"
    Task.Supervisor.start_child(SocialTracker.TCPRequests, fn -> data |> dispatch() end)
    :inet.setopts(s, active: :once)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, client}, state) do
    Logger.debug "Client Closed connection"
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
