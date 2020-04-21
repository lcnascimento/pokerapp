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
      row_id: "#{user.cpf}:UserAggregate",
      aggregate_id: user.cpf,
      action: "user-created",
      payload: Poison.encode!(user),
      timestamp: DateTime.utc_now()
    }
  end

  @spec update(cpf :: String.t(), new :: map()) :: Event.t()
  def update(cpf, diff) do
    %Event{
      row_id: "#{cpf}:UserAggregate",
      aggregate_id: cpf,
      action: "user-updated",
      payload: Poison.encode!(diff),
      timestamp: DateTime.utc_now()
    }
  end

  @spec remove(cpf :: User.t()) :: Event.t()
  def remove(cpf) do
    %Event{
      row_id: "#{cpf}:UserAggregate",
      aggregate_id: cpf,
      action: "user-deleted",
      payload: Poison.encode!(%{cpf: cpf}),
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
