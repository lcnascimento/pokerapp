defmodule UsersService.Query.Supervisor do
  alias UsersService.Query.Service
  alias UsersService.Query.EventsProcessor

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    children = [
      {Service, %{}},
      {EventsProcessor, %{}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
