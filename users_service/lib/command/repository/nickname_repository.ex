defmodule UsersService.Command.NicknameRepository do
  alias UsersService.Infra.Eventstore
  alias UsersService.Infra.MapHelper

  alias UsersService.Command.Nickname

  @spec get(es_pid :: pid(), nickname :: String.t()) :: {:ok, Nickname.t()}
  def get(es_pid, nickname) do
    result =
      Eventstore.stream(es_pid, "#{nickname}:NicknameAggregate")
      |> Enum.reduce([], &Enum.concat(&1, Enum.to_list(&2)))
      |> Enum.map(&Map.put(&1, "payload", Poison.decode!(&1["payload"])))
      |> Enum.map(&MapHelper.atomize_keys/1)
      |> Enum.reduce(nil, &Nickname.apply(&2, &1))

    {:ok, result}
  end
end
