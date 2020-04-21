defmodule UsersService do
  alias UsersService.Command
  alias UsersService.Infra
  alias UsersService.Query

  use Application

  def start(_type, _args) do
    children = [
      {Command.Supervisor, []},
      {Infra.Supervisor, []},
      {Query.Supervisor, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
