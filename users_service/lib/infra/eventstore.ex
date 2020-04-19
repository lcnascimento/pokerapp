defmodule UsersService.Infra.Eventstore do
  alias UsersService.Infra.Event
  alias UsersService.Infra.Error

  def connect do
    {:ok, conn} = Xandra.start_link(nodes: ["127.0.0.1:9043"])
    conn
  end

  @spec insert(event :: Event.t()) :: any()
  def insert(event) do
    conn = connect()

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

    response
  end

  @spec stream(row_id :: String.t(), agg_id :: String.t()) :: any()
  def stream(row_id \\ nil, agg_id \\ nil)

  def stream(row_id, agg_id) when row_id == nil and agg_id == nil do
    conn = connect()

    query = "SELECT * FROM users_service.users"
    statement = Xandra.prepare!(conn, query)

    Xandra.stream_pages!(conn, statement, [], page_size: 1_000)
  end

  def stream(row_id, agg_id) when agg_id == nil do
    conn = connect()

    query = "SELECT * FROM users_service.users WHERE row_id = ?"
    statement = Xandra.prepare!(conn, query)

    Xandra.stream_pages!(conn, statement, [row_id], page_size: 1_000)
  end

  def stream(row_id, agg_id) do
    conn = connect()

    query = "SELECT * FROM users_service.users WHERE row_id = ? AND aggregate_id = ?"
    statement = Xandra.prepare!(conn, query)

    Xandra.stream_pages!(conn, statement, [row_id, agg_id], page_size: 1_000)
  end

  def snapshoot() do
    {:error, %{reason: "NotImplemented"}}
  end

  def last_snapshoot() do
    {:error, %{reason: "NotImplemented"}}
  end
end
