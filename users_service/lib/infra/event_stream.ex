defmodule UsersService.Infra.EventStream do
  alias UsersService.Infra.Event

  use GenServer

  # Client side

  def start_link(args \\ %{}) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec insert(event :: Event.t()) :: :ok
  def insert(event) do
    GenServer.call(__MODULE__, {:put, event})
  end

  @spec bulk_insert(events :: [Event.t()]) :: :ok
  def bulk_insert(events) do
    GenServer.call(__MODULE__, {:put, events})
  end

  @spec subscribe(event_actions :: [String.t()]) :: {:ok, any()}
  def subscribe(event_actions) do
    GenServer.call(__MODULE__, {:subscribe, event_actions})
  end

  # Server side

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call({:insert, event}, _from, state) do
    IO.puts("inserting event into stream: #{event}")
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:bulk_insert, events}, _from, state) do
    IO.puts("inserting events into stream: #{events}")
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:subscribe, _event_actions}, _from, state) do
    IO.puts("subscribing to stream...")
    {:reply, {:ok, %{}}, state}
  end
end
