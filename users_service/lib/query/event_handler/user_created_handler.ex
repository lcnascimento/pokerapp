defmodule UsersService.Query.UserCreatedHandler do
  def handle(_event) do
    IO.inspect("Processing user-created event...")
  end
end
