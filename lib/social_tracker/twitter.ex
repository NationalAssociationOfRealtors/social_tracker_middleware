defmodule SocialTracker.TweetConsumer do
  use GenStage
  require Logger

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:consumer, %{}}
  end

  def handle_events(events, _from, state) do
    events |> Enum.each(fn(tweet) ->
      Logger.info("#{__MODULE__}: #{tweet["text"]}")
      Registry.dispatch(SocialTracker.Tweets, SocialTracker.Tweet, fn entries ->
        for {pid, _} <- entries, do: send(pid, {:broadcast, tweet})
      end)
    end)
    {:noreply, [], state}
  end

end

defmodule SocialTracker.Twitter do
  use GenServer
  require Logger

  @filter Application.get_env(:social_tracker, :twitter_filter)

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.send_after(self(), :start, 0)
    {:ok, %{}}
  end

  def handle_info(:start, state) do
    Logger.info "Streaming: #{inspect @filter}"
    {:ok, stream} = Twittex.stream(@filter, [min_demand: 1, max_demand: 10, stage: true])
    {:ok, tag} = GenStage.sync_subscribe(SocialTracker.TweetConsumer, to: stream)
    {:noreply, state}
  end
end
