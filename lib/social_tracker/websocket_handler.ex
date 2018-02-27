defmodule SocialTracker.WebSocketHandler do
  require Logger
  @behaviour :cowboy_websocket_handler
  @timeout 60000

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    {val, req2} = :cowboy_req.qs_val("filters", req)
    Logger.info "#{inspect val}"
    filters = val |> String.split(",") |> Enum.map(&String.trim(&1))
    Registry.register(SocialTracker.Registry, SocialTracker.Data, [])
    {:ok, req2, %{filters: filters}, @timeout}
  end

  def websocket_handle({:text, message}, req, state) do
    {:reply, {:text, message}, req, state}
  end

  def websocket_info(:shutdown, req, state) do
    {:shutdown, req, state}
  end

  def websocket_info({:broadcast, %{"type" => type} = data}, req, %{filters: filters} = state) do
    case type in filters do
      true -> {:reply, {:text, Poison.encode!(data)}, req, state}
      false -> {:ok, req, state}
    end

  end

  def websocket_info(message, req, state) do
    {:ok, req, state}
  end

  def websocket_terminate(_reason, _req, _state), do: :ok
end
