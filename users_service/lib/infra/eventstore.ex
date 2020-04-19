defmodule UsersService.Infra.Eventstore do
  alias UsersService.Infra.Event

  use GenServer

  # Client side

  def start_link(default \\ %{}) do
    GenServer.start(__MODULE__, default)
  end

  @spec insert(pid :: pid(), event :: Event.t()) :: any()
  def insert(pid, event) do
    GenServer.call(pid, {:insert, event})
  end

  @spec stream(pid :: pid(), row_id :: String.t(), agg_id :: String.t()) :: any()
  def stream(pid, row_id \\ nil, agg_id \\ nil) do
    GenServer.call(pid, {:stream, row_id, agg_id})
  end

  # Server side

  @impl GenServer
  def init(state) do
    {:ok, conn} = Xandra.start_link(nodes: cassandra_nodes())

    {:ok, Map.put(state, :conn, conn)}
  end

  @impl GenServer
  def handle_call({:insert, event}, _from, %{conn: conn} = state) do
    statement =
      "INSERT INTO users_service.users(row_id, aggregate_id, event_time, event_type, payload) VALUES (?, ?, ?, ?, ?)"

    {:ok, response} =
      Xandra.execute(conn, statement, [
        {"text", event.row_id},
        {"text", event.aggregate_id},
        {"timestamp", event.timestamp},
        {"text", event.type},
        {"map<text,text>", event.payload}
      ])

    {:reply, response, state}
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

  defp cassandra_nodes do
    ["127.0.0.1:9043"]
  end
end
