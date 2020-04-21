defmodule UsersService.Query.UserDeletedHandler do
  def handle(_event) do
    IO.inspect("Processing user-deleted event...")
  end
end
