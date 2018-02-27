defmodule SocialTracker.WebSocketHandler do
  require Logger
  @behaviour :cowboy_websocket_handler
  @timeout 60000

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    Registry.register(SocialTracker.Registry, SocialTracker.Data, [])
    {:ok, req, %{}, @timeout}
  end

  def websocket_handle({:text, message}, req, state) do
    {:reply, {:text, message}, req, state}
  end

  def websocket_info(:shutdown, req, state) do
    {:shutdown, req, state}
  end

  def websocket_info({:broadcast, data}, req, state) do
    {:reply, {:text, data}, req, state}
  end

  def websocket_info(message, req, state) do
    {:reply, {:text, message}, req, state}
  end

  def websocket_terminate(_reason, _req, _state), do: :ok
end
