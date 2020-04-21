defmodule UsersService.Query.Service do
  alias UsersService.Query.Entity.User

  use GenServer

  # Client side
  def start_link(args \\ %{}) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  # @spec list() :: {:ok, [User.t()]}
  def list() do
    GenServer.call(__MODULE__, :list)
  end

  @spec find(cpf :: String.t()) :: {:ok, User.t()}
  def find(cpf) do
    GenServer.call(__MODULE__, {:find, cpf})
  end

  # Server side

  @impl GenServer
  def init(state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:list, _from, state) do
    {:reply, [%{bla: "ble"}], state}
  end

  @impl GenServer
  def handle_call({:find, _cpf}, _from, state) do
    {:reply, [%{bla: "blo"}], state}
  end
end
