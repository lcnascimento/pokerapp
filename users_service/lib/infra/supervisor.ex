defmodule UsersService.Infra.Supervisor do
  alias UsersService.Infra.Eventstore
  alias UsersService.Infra.EventStream

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    children = [
      {Eventstore, %{}},
      {EventStream, %{}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
