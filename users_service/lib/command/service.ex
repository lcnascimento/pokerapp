defmodule UsersService.Command.Service do
  alias UsersService.Infra.Eventstore
  alias UsersService.Infra.EventStream

  alias UsersService.Command.User
  alias UsersService.Command.Nickname

  alias UsersService.Command.NicknameRepository
  alias UsersService.Command.UserRepository

  use GenServer

  # Client side

  def start_link(args \\ %{}) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec create(user :: User.t()) :: {:ok, created_user :: User.t()}
  def create(user) do
    GenServer.call(__MODULE__, {:create, user})
  end

  @spec update(user :: User.t()) :: {:ok, updated_user :: User.t()}
  def update(user) do
    GenServer.call(__MODULE__, {:update, user})
  end

  @spec remove(user_id :: String.t()) :: :ok
  def remove(user_id) do
    GenServer.call(__MODULE__, {:remove, user_id})
  end

  # Server side

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call({:create, %{nickname: nickname, cpf: cpf} = user}, _from, state) do
    events = [Nickname.pick(user, nickname), User.create(user)]

    response =
      {:ok, user}
      |> check_nickname_availability(nickname)
      |> check_user_inexistence(cpf)
      |> persist_events_into_eventstore(events)
      |> persist_events_into_event_stream(events)

    {:reply, response, state}
  end

  @impl GenServer
  def handle_call({:update, user}, _from, state) do
    {:reply, {:ok, user}, state}
  end

  @impl GenServer
  def handle_call({:remove, _user_id}, _from, state) do
    {:reply, :ok, state}
  end

  defp persist_events_into_eventstore({:ok, _} = response, events) do
    :ok = GenServer.call(Eventstore, {:bulk_insert, events})
    response
  end

  defp persist_events_into_eventstore({:error, _, _} = response, _events) do
    response
  end

  defp persist_events_into_event_stream({:ok, _} = response, events) do
    :ok = GenServer.call(EventStream, {:bulk_insert, events})
    response
  end

  defp persist_events_into_event_stream({:error, _, _} = response, _events) do
    response
  end

  defp check_nickname_availability(response, nickname) do
    {:ok, nick} = NicknameRepository.get(nickname)

    case nick do
      nil -> response
      _ -> {:error, :bad_request, "nickname unavailable"}
    end
  end

  defp check_user_inexistence({:ok, _} = response, cpf) do
    {:ok, user} = UserRepository.get(cpf)

    case user do
      nil -> response
      _ -> {:error, :bad_request, "given user already exists"}
    end
  end

  defp check_user_inexistence({:error, reason, message}, _) do
    {:error, reason, message}
  end
end
