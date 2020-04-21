defmodule UsersService.Command.Service do
  alias UsersService.Command.User

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
  def handle_call({:create, user}, _from, state) do
    {:reply, {:ok, user}, state}
  end

  @impl GenServer
  def handle_call({:update, user}, _from, state) do
    {:reply, {:ok, user}, state}
  end

  @impl GenServer
  def handle_call({:remove, _user_id}, _from, state) do
    {:reply, :ok, state}
  end
end
