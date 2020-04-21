defmodule UsersService.Command.Nickname do
  alias UsersService.Infra.Event

  alias UsersService.Command.User
  alias UsersService.Command.Nickname

  defstruct [:value, :owner_cpf]

  @type t :: %Nickname{
          value: String.t(),
          owner_cpf: String.t()
        }

  @spec pick(cpf :: String.t(), value :: Nickname.t()) :: Event.t()
  def pick(cpf, value) do
    %Event{
      row_id: "#{cpf}:NicknameAggregate",
      aggregate_id: value,
      action: "nickname-picked",
      payload: Poison.encode!(%{value: value, owner_cpf: cpf}),
      timestamp: DateTime.utc_now()
    }
  end

  @spec release(cpf :: String.t(), value :: Nickname.t()) :: Event.t()
  def release(cpf, value) do
    %Event{
      row_id: "#{value}:NicknameAggregate",
      aggregate_id: cpf,
      action: "nickname-released",
      payload: Poison.encode!(%{value: value, old_owner_cpf: cpf}),
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
