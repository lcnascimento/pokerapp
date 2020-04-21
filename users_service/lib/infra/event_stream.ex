defmodule UsersService.Infra.EventStream do
  alias UsersService.Infra.Event
  alias UsersService.Infra.MapHelper

  alias KafkaEx.Protocol.Produce.Request
  alias KafkaEx.Protocol.Produce.Message

  use GenServer

  # Client side

  def start_link(args \\ %{}) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec insert(event :: Event.t()) :: :ok
  def insert(event) do
    GenServer.call(__MODULE__, {:insert, event})
  end

  @spec bulk_insert(events :: [Event.t()]) :: :ok
  def bulk_insert(events) do
    GenServer.call(__MODULE__, {:bulk_insert, events})
  end

  @spec subscribe(event_actions :: [String.t()]) :: {:ok, any()}
  def subscribe(event_actions) do
    GenServer.call(__MODULE__, {:subscribe, event_actions})
  end

  # Server side

  @impl GenServer
  def init(state) do
    {:ok, pid} =
      KafkaEx.create_worker(:users_service_kafka,
        uris: kafka_brokers(),
        consumer_group: "users_service",
        consumer_group_update_interval: 100
      )

    {:ok, Map.put(state, :worker_pid, pid)}
  end

  @impl GenServer
  def handle_call({:insert, event}, _from, state) do
    IO.puts("inserting event into stream: #{Poison.encode!(event)}")

    {:ok, _} =
      KafkaEx.produce(
        %Request{
          topic: "users_service",
          required_acks: 1,
          partition: 0,
          compression: :snappy,
          messages: [build_event_message(event)]
        },
        worker_name: :users_service_kafka
      )

    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:bulk_insert, []}, _from, state) do
    IO.puts("inserting 0 events into stream")
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:bulk_insert, events}, _from, state) do
    IO.puts("inserting events into stream: #{Poison.encode!(events)}")

    {:ok, _} =
      KafkaEx.produce(
        %Request{
          topic: "users_service",
          required_acks: 1,
          partition: 0,
          compression: :snappy,
          messages: events |> Enum.map(&build_event_message/1)
        },
        worker_name: :users_service_kafka
      )

    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_call({:subscribe, event_actions}, _from, state) do
    IO.puts("subscribing to stream...")

    stream =
      KafkaEx.stream("users_service", 0, worker_name: :users_service_kafka)
      |> Stream.map(&Poison.decode!(&1.value))
      |> Stream.map(&MapHelper.atomize_keys/1)
      |> Stream.filter(&Enum.member?(event_actions, &1.action))

    {:reply, {:ok, stream}, state}
  end

  defp build_event_message(%{row_id: key} = event) do
    %Message{key: key, value: Poison.encode!(event)}
  end

  defp kafka_brokers do
    [{"localhost", 9092}, {"localhost", 9093}]
  end
end
