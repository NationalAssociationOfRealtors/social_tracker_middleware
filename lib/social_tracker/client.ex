defmodule SocialTracker.Client do
  use GenServer
  require Logger

  @port Application.get_env(:social_tracker, :tcp_port, 8307)

  def start_link() do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:ok, socket} = :gen_tcp.connect({127, 0, 0, 1}, @port, [])
    Process.send_after(self(), :send, 100)
    {:ok, %{socket: socket}}
  end

  def handle_info(:send, state) do
    Logger.info "Sending Data"
    :gen_tcp.send(state.socket, "{\"type\":\"test\", \"data\":{\"text\": \"This is a test tweet from the test client\"}}")
    Process.send_after(self(), :send, 100)
    {:noreply, state}
  end

end
