defmodule UsersService.Command.Nickname do
  alias UsersService.Infra.Event

  alias UsersService.Command.User
  alias UsersService.Command.Nickname

  defstruct [:value, :owner]

  @type t :: %Nickname{
          value: String.t(),
          owner: User.t()
        }

  @spec pick(requester :: User.t(), nickname_value :: Nickname.t()) :: Event.t()
  def pick(requester, nickname_value) do
    nickname = %Nickname{
      value: nickname_value,
      owner: requester
    }

    %Event{
      row_id: "#{nickname_value}:NicknameAggregate",
      aggregate_id: requester.cpf,
      action: "nickname-picked",
      payload: Poison.encode!(nickname),
      timestamp: DateTime.utc_now()
    }
  end

  @spec release(requester :: User.t(), value :: Nickname.t()) :: Event.t()
  def release(requester, value) do
    %Event{
      row_id: "#{value}:NicknameAggregate",
      aggregate_id: requester.cpf,
      action: "nickname-released",
      payload: Poison.encode!(%{}),
      timestamp: DateTime.utc_now()
    }
  end

  @spec apply(state :: Nickname.t(), event :: Event.t()) :: Nickname.t()
  def apply(state, event)

  def apply(nil, %{action: "nickname-picked", payload: payload}) do
    payload
  end

  def apply(state, %{action: "nickname-picked", payload: payload}) do
    Map.merge(state, %{value: payload.value, owner: payload.owner})
  end

  def apply(state, %{action: "nickname-released"}) do
    Map.delete(state, :owner)
  end
end
