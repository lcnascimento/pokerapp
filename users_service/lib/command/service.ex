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

  @spec remove(cpf :: String.t()) :: :ok
  def remove(cpf) do
    GenServer.call(__MODULE__, {:remove, cpf})
  end

  # Server side

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call({:create, user}, _from, state) do
    {response, events, _ctx} =
      {nil, [], %{}}
      |> check_nickname_availability(user)
      |> check_user_inexistence(user)
      |> build_success_response_if_empty()

    :ok = GenServer.call(Eventstore, {:bulk_insert, events})
    :ok = GenServer.call(EventStream, {:bulk_insert, events})

    {:reply, response, state}
  end

  @impl GenServer
  def handle_call({:update, %{cpf: cpf} = user}, _from, state) do
    {response, events, _ctx} =
      {nil, [], %{}}
      |> check_user_existence(cpf)
      |> build_update_user_events(user)
      |> build_success_response_if_empty()

    :ok = GenServer.call(Eventstore, {:bulk_insert, events})
    :ok = GenServer.call(EventStream, {:bulk_insert, events})

    {:reply, response, state}
  end

  @impl GenServer
  def handle_call({:remove, cpf}, _from, state) do
    {response, events, _ctx} =
      {nil, [], %{}}
      |> check_user_existence(cpf)
      |> build_remove_user_events()
      |> build_success_response_if_empty()

    :ok = GenServer.call(Eventstore, {:bulk_insert, events})
    :ok = GenServer.call(EventStream, {:bulk_insert, events})

    {:reply, response, state}
  end

  defp check_nickname_availability({{:error, _reason, _msg}, _events, _ctx} = state, _user) do
    state
  end

  defp check_nickname_availability({res, events, ctx}, %{nickname: nickname, cpf: cpf}) do
    {:ok, nick} = NicknameRepository.get(nickname)

    case nick do
      nil -> {res, Enum.concat(events, [Nickname.pick(cpf, nickname)]), ctx}
      _ -> {{:error, :bad_request, "nickname unavailable"}, [], ctx}
    end
  end

  defp check_user_inexistence({{:error, _reason, _msg}, _events, _ctx} = state, _user) do
    state
  end

  defp check_user_inexistence({res, events, ctx}, %{cpf: cpf} = user) do
    {:ok, u} = UserRepository.get(cpf)

    case u do
      nil -> {res, Enum.concat(events, [User.create(user)]), ctx}
      _ -> {{:error, :bad_request, "given user already exists"}, [], ctx}
    end
  end

  defp check_user_existence({{:error, _reason, _msg}, _events, _ctx} = state, _cpf) do
    state
  end

  defp check_user_existence({res, events, ctx}, cpf) do
    {:ok, user} = UserRepository.get(cpf)

    case user do
      nil -> {{:error, :bad_request, "user does not exists"}, [], ctx}
      _ -> {res, events, Map.put(ctx, :user, user)}
    end
  end

  defp build_update_user_events({{:error, _reason, _msg}, _events, _ctx} = state, _user) do
    state
  end

  defp build_update_user_events({res, events, %{user: old} = ctx}, %{cpf: cpf} = new) do
    diff =
      Map.keys(old)
      |> Enum.filter(fn key -> Map.get(old, key) != Map.get(new, key) and key != :cpf end)
      |> Enum.map(fn key -> {key, Map.get(new, key)} end)
      |> Enum.into(%{})

    diff_events =
      case diff do
        %{nickname: _nickname} ->
          [
            Nickname.release(cpf, old.nickname),
            Nickname.pick(cpf, new.nickname),
            User.update(cpf, diff)
          ]

        d when d == %{} ->
          []

        _ ->
          [User.update(cpf, diff)]
      end

    {res, Enum.concat(events, diff_events), ctx}
  end

  defp build_remove_user_events({{:error, _reason, _msg}, _events, _ctx} = state) do
    state
  end

  defp build_remove_user_events({res, events, %{user: %{cpf: cpf, nickname: nickname}} = ctx}) do
    remove_events = [Nickname.release(cpf, nickname), User.remove(cpf)]
    {res, Enum.concat(events, remove_events), ctx}
  end

  defp build_success_response_if_empty({nil, events, ctx}) do
    {:ok, events, ctx}
  end

  defp build_success_response_if_empty(state) do
    state
  end
end
