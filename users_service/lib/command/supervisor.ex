defmodule UsersService.Command.Supervisor do
  alias UsersService.Command.Service

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    children = [
      {Service, %{}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
