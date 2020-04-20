defmodule UsersService.Command.User do
  alias UsersService.Command.User

  alias UsersService.Infra.Event
  alias UsersService.Infra.Eventstore
  alias UsersService.Infra.MapHelper

  defstruct [:cpf, :name, :nickname, :email, :birthday]

  @type t :: %User{
          cpf: String.t(),
          name: String.t(),
          nickname: String.t(),
          email: String.t(),
          birthday: Date.t()
        }

  @spec get(es_pid :: pid(), cpf :: String.t()) :: {:ok, User.t()}
  def get(es_pid, cpf) do
    result =
      Eventstore.stream(es_pid, "UserAggregate", cpf)
      |> Enum.reduce([], &Enum.concat(&1, Enum.to_list(&2)))
      |> Enum.map(&Map.put(&1, "payload", Poison.decode!(&1["payload"])))
      |> Enum.map(&MapHelper.atomize_keys/1)
      |> Enum.reduce(nil, &User.apply(&2, &1))

    {:ok, result}
  end

  @spec get(es_pid :: pid(), user :: User.t()) :: {:ok, User.t()}
  def create(es_pid, user) do
    event = %Event{
      row_id: "UserAggregate",
      aggregate_id: user.cpf,
      action: "user-created",
      payload: Poison.encode!(user),
      timestamp: DateTime.utc_now()
    }

    Eventstore.insert(es_pid, event)

    {:ok, user}
  end

  @spec update(es_pid :: pid(), old :: User.t(), new :: User.t()) :: {:ok, User.t()}
  def update(es_pid, old, new) do
    diff =
      Map.keys(old)
      |> Enum.filter(fn key -> Map.get(old, key) != Map.get(new, key) and key != :cpf end)
      |> Enum.map(fn key -> {key, Map.get(new, key)} end)
      |> Enum.into(%{})

    event = %Event{
      row_id: "UserAggregate",
      aggregate_id: old.cpf,
      action: "user-updated",
      payload: Poison.encode!(diff),
      timestamp: DateTime.utc_now()
    }

    Eventstore.insert(es_pid, event)

    {:ok, new}
  end

  @spec get(es_pid :: pid(), user :: User.t()) :: {:ok, User.t()}
  def remove(es_pid, user) do
    event = %Event{
      row_id: "UserAggregate",
      aggregate_id: user.cpf,
      action: "user-deleted",
      payload: Poison.encode!(%{}),
      timestamp: DateTime.utc_now()
    }

    Eventstore.insert(es_pid, event)

    {:ok, user}
  end

  @spec apply(state :: User.t(), event :: Event.t()) :: User.t()
  def apply(state, event)

  def apply(nil, %{action: "user-created", payload: payload}) do
    payload
  end

  def apply(state, %{action: "user-updated", payload: payload}) do
    Map.merge(state, payload)
  end

  def apply(_state, %{action: "user-deleted"}) do
    nil
  end
end
