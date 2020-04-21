defmodule UsersService.Query.EventsProcessor do
  alias UsersService.Infra.EventStream

  use GenServer

  # Client side

  def start_link(args \\ %{}) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec run() :: :ok
  def run() do
    GenServer.cast(__MODULE__, :run)
  end

  # Server side

  @impl GenServer
  def init(%{actions: _actions} = state) do
    {:ok, state}
  end

  @impl GenServer
  def init(state) do
    actions = [
      "user-created",
      "user-deleted",
      "nickname-picked",
      "nickname-released"
    ]

    {:ok, Map.put(state, :actions, actions)}
  end

  @impl GenServer
  def handle_cast(:run, %{actions: actions} = state) do
    {:ok, stream} = EventStream.subscribe(actions)

    stream
    |> Enum.each(fn %{action: action} = event ->
      module_name =
        action
        |> String.split("-")
        |> Enum.map(&String.capitalize/1)
        |> (&Enum.concat(["Elixir.UsersService.Query."], &1)).()
        |> Enum.concat(["Handler"])
        |> Enum.join()

      apply(String.to_existing_atom(module_name), :handle, [event])
    end)

    {:noreply, state}
  end
end
