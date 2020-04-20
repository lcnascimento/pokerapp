defmodule UsersService.Command.UserRepository do
  alias UsersService.Infra.Eventstore
  alias UsersService.Infra.MapHelper

  alias UsersService.Command.User

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
end
