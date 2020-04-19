defmodule UsersService.Command.Nickname do
  alias UsersService.Infra.Event
  alias UsersService.Infra.Eventstore
  alias UsersService.Infra.Support

  alias UsersService.Command.User
  alias UsersService.Command.Nickname

  defstruct [:value, :owner]

  @type t :: %Nickname{
          value: String.t(),
          owner: User.t()
        }

  @spec get(es_pid :: pid(), nickname :: String.t()) :: {:ok, Nickname.t()}
  def get(es_pid, nickname) do
    result =
      Eventstore.stream(es_pid, "#{nickname}:NicknameAggregate")
      |> Enum.reduce([], fn acc, page -> Enum.concat(acc, Enum.to_list(page)) end)
      |> Enum.map(&Map.put(&1, "payload", Poison.decode!(&1["payload"])))
      |> Enum.map(&Support.atomize_keys/1)
      |> Enum.reduce(%Nickname{}, fn event, acc -> Nickname.apply(acc, event) end)

    {:ok, result}
  end

  @spec pick(es_pid :: pid(), requester :: User.t(), nickname_value :: Nickname.t()) ::
          {:ok, Nickname.t()}
  def pick(es_pid, requester, nickname_value) do
    nickname = %Nickname{
      value: nickname_value,
      owner: requester
    }

    event = %Event{
      row_id: "#{nickname_value}:NicknameAggregate",
      aggregate_id: requester.cpf,
      action: "nickname-picked",
      payload: Poison.encode!(nickname),
      timestamp: DateTime.utc_now()
    }

    Eventstore.insert(es_pid, event)

    {:ok, nickname}
  end

  @spec apply(state :: Nickname.t(), event :: Event.t()) :: Nickname.t()
  def apply(state, event)

  def apply(state, %{action: "nickname-picked", payload: payload}) do
    Map.merge(state, %{value: payload.value, owner: payload.owner})
  end

  def apply(state, %{action: "nickname-released"}) do
    Map.delete(state, :owner)
  end
end