defmodule UsersService.Infra.Eventstore do
  alias UsersService.Infra.Event

  use GenServer

  # Client side

  def start_link(default \\ %{}) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @spec insert(event :: Event.t()) :: :ok
  def insert(event) do
    GenServer.call(__MODULE__, {:insert, event})
  end

  @spec bulk_insert(events :: [Event.t()]) :: :ok
  def bulk_insert(events) do
    GenServer.call(__MODULE__, {:bulk_insert, events})
  end

  @spec stream(row_id :: String.t(), agg_id :: String.t()) :: any()
  def stream(row_id \\ nil, agg_id \\ nil) do
    GenServer.call(__MODULE__, {:stream, row_id, agg_id})
  end

  # Server side

  @impl GenServer
  def init(state) do
    {:ok, conn} = Xandra.start_link(nodes: cassandra_nodes())

    {:ok, Map.put(state, :conn, conn)}
  end

  @impl GenServer
  def handle_call({:stream, row_id, agg_id}, _from, %{conn: conn} = state)
      when row_id == nil and agg_id == nil do
    query = "SELECT * FROM users_service.users"
    statement = Xandra.prepare!(conn, query)

    stream = Xandra.stream_pages!(conn, statement, [], page_size: 1_000)

    {:reply, stream, state}
  end

  @impl GenServer
  def handle_call({:stream, row_id, agg_id}, _from, %{conn: conn} = state)
      when row_id != nil and agg_id == nil do
    query = "SELECT * FROM users_service.users WHERE row_id = ?"
    statement = Xandra.prepare!(conn, query)

    stream = Xandra.stream_pages!(conn, statement, [row_id], page_size: 1_000)

    {:reply, stream, state}
  end

  @impl GenServer
  def handle_call({:stream, row_id, agg_id}, _from, %{conn: conn} = state)
      when row_id != nil and agg_id != nil do
    query = "SELECT * FROM users_service.users WHERE row_id = ? AND aggregate_id = ?"
    statement = Xandra.prepare!(conn, query)

    stream = Xandra.stream_pages!(conn, statement, [row_id, agg_id], page_size: 1_000)

    {:reply, stream, state}
  end

  @impl GenServer
  def handle_call({:insert, event}, _from, %{conn: conn} = state) do
    statement = prepare_insert_statement(conn)
    Xandra.execute!(conn, statement, insert_event_params(event))

    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:bulk_insert, []}, _from, state) do
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:bulk_insert, events}, _from, %{conn: conn} = state) do
    statement = prepare_insert_statement(conn)

    batch =
      events
      |> Stream.with_index(1)
      |> Enum.map(fn {event, idx} ->
        Map.put(event, :timestamp, DateTime.add(event.timestamp, idx, :millisecond))
      end)
      |> Enum.reduce(
        Xandra.Batch.new(),
        &Xandra.Batch.add(&2, statement, insert_event_params(&1))
      )

    Xandra.execute!(conn, batch)

    {:reply, :ok, state}
  end

  defp prepare_insert_statement(conn) do
    statement =
      "INSERT INTO users_service.users(row_id, aggregate_id, timestamp, action, payload) VALUES (?, ?, ?, ?, ?)"

    Xandra.prepare!(conn, statement)
  end

  defp insert_event_params(event) do
    [
      event.row_id,
      event.aggregate_id,
      event.timestamp,
      event.action,
      event.payload
    ]
  end

  defp cassandra_nodes do
    ["127.0.0.1:9043"]
  end
end
