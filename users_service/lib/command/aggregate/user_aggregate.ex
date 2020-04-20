defmodule UsersService.Command.User do
  alias UsersService.Command.User
  alias UsersService.Infra.Event

  defstruct [:cpf, :name, :nickname, :email, :birthday]

  @type t :: %User{
          cpf: String.t(),
          name: String.t(),
          nickname: String.t(),
          email: String.t(),
          birthday: Date.t()
        }

  @spec create(user :: User.t()) :: Event.t()
  def create(user) do
    %Event{
      row_id: "UserAggregate",
      aggregate_id: user.cpf,
      action: "user-created",
      payload: Poison.encode!(user),
      timestamp: DateTime.utc_now()
    }
  end

  @spec update(old :: User.t(), new :: User.t()) :: Event.t()
  def update(old, new) do
    diff =
      Map.keys(old)
      |> Enum.filter(fn key -> Map.get(old, key) != Map.get(new, key) and key != :cpf end)
      |> Enum.map(fn key -> {key, Map.get(new, key)} end)
      |> Enum.into(%{})

    %Event{
      row_id: "UserAggregate",
      aggregate_id: old.cpf,
      action: "user-updated",
      payload: Poison.encode!(diff),
      timestamp: DateTime.utc_now()
    }
  end

  @spec remove(user :: User.t()) :: Event.t()
  def remove(user) do
    %Event{
      row_id: "UserAggregate",
      aggregate_id: user.cpf,
      action: "user-deleted",
      payload: Poison.encode!(%{}),
      timestamp: DateTime.utc_now()
    }
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
