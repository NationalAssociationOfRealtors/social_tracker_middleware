defmodule SocialTracker.Client do
  use GenServer
  require Logger

  @port Application.get_env(:social_tracker, :tcp_port, "8307") |> String.to_integer()

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
    :gen_tcp.send(state.socket, "{\"type\":\"test\", \"data\":{\"text\": \"Lorem ipsum dolor sit amet, consectetur adipiscing elit. In dictum ex nec felis aliquam iaculis. Nulla convallis elit eget ipsum elementum, at porta erat mollis. Fusce vel tincidunt neque. Aenean semper ante sit amet sodales euismod. Cras augue diam, egestas id orci sit amet, sodales sodales dolor. Fusce quis semper ligula. Maecenas eget vehicula nulla. Aliquam erat volutpat. Quisque ac mattis mi. Nam posuere vehicula gravida. Nulla vulputate nibh vitae erat condimentum pellentesque.In hac habitasse platea dictumst. Fusce vel ante iaculis, imperdiet nunc sit amet, eleifend erat. Donec suscipit mauris quis purus imperdiet eleifend. Aenean convallis facilisis blandit. Cras at ante sapien. Suspendisse condimentum vulputate massa vitae finibus. Ut metus diam, iaculis id ullamcorper non, rutrum maximus tellus. In varius finibus enim eget vulputate. Donec sit amet cursus felis. Fusce a condimentum sapien, malesuada suscipit turpis. Nulla faucibus orci vel auctor tristique. Donec hendrerit lobortis congue. Aliquam quis lacinia metus, ac sagittis ante. Mauris ipsum libero, efficitur et leo eu, viverra luctus est. Suspendisse at orci id felis vehicula accumsan et eu ante. Ut tempus mi eu tellus faucibus, et cursus mi ultricies. Vivamus a turpis vitae purus maximus ornare eu viverra metus. Mauris placerat dui ligula, nec placerat eros placerat at. Integer viverra finibus orci a aliquam. Donec tristique sem in erat aliquet, eget venenatis metus viverra. Integer varius magna nisl, nec tempus quam porttitor eget. Integer et pellentesque leo. Pellentesque pellentesque vel nisi sed ornare. Maecenas vulputate sodales lorem, in maximus elit aliquet nec. Cras sit amet erat lectus. Etiam arcu enim, viverra vitae tristique quis, consectetur non justo. Pellentesque vestibulum turpis arcu, sit amet sodales ipsum tempor id. Nulla facilisi. Integer interdum arcu eget posuere tincidunt. Vivamus quis nisi fringilla, mattis turpis eu, volutpat nisl. Praesent aliquet fringilla ante, et consectetur felis sagittis ac. Praesent eu suscipit tortor. Suspendisse egestas nunc at sollicitudin hendrerit. Phasellus rutrum ornare risus, at venenatis metus scelerisque sit amet. Quisque tincidunt ex a blandit lacinia. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam in mollis sapien. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam eget nunc in urna pellentesque molestie.\"}}")
    Process.send_after(self(), :send, 100)
    {:noreply, state}
  end

end
