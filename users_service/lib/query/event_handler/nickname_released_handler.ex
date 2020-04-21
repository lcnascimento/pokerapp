defmodule UsersService.Query.NicknameReleasedHandler do
  def handle(_event) do
    IO.inspect("Processing nickname-released event...")
  end
end
