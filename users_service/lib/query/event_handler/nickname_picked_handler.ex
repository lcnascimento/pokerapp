defmodule UsersService.Query.NicknamePickedHandler do
  def handle(_event) do
    IO.inspect("Processing nickname-picked event...")
  end
end
