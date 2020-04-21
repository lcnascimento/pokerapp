defmodule UsersService do
  alias UsersService.Command
  alias UsersService.Infra

  use Application

  def start(_type, _args) do
    children = [
      {Command.Supervisor, []},
      {Infra.Supervisor, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
