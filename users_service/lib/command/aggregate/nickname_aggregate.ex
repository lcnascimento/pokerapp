defmodule UsersService.Command.Nickname do
  alias UsersService.Infra.Event

  alias UsersService.Command.Nickname

  defstruct [:value, :owner_cpf]

  @type t :: %Nickname{
          value: String.t(),
          owner_cpf: String.t()
        }

  @spec pick(cpf :: String.t(), nickname :: Nickname.t()) :: Event.t()
  def pick(cpf, nickname) do
    %Event{
      row_id: "#{nickname}:NicknameAggregate",
      aggregate_id: cpf,
      action: "nickname-picked",
      payload: Poison.encode!(%{value: nickname, owner_cpf: cpf}),
      timestamp: DateTime.utc_now()
    }
  end

  @spec release(cpf :: String.t(), nickname :: Nickname.t()) :: Event.t()
  def release(cpf, nickname) do
    %Event{
      row_id: "#{nickname}:NicknameAggregate",
      aggregate_id: cpf,
      action: "nickname-released",
      payload: Poison.encode!(%{value: nickname, old_owner_cpf: cpf}),
      timestamp: DateTime.utc_now()
    }
  end

  @spec apply(state :: Nickname.t(), event :: Event.t()) :: Nickname.t()
  def apply(state, event)

  def apply(nil, %{action: "nickname-picked", payload: payload}) do
    payload
  end

  def apply(_state, %{action: "nickname-released"}) do
    nil
  end
end
