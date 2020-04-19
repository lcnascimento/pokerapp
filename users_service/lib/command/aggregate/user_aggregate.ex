defmodule UsersService.Command.User do
  alias UsersService.Command.User

  defstruct [:cpf, :name, :nickname, :email, :birthday]

  @type t :: %User{
          cpf: String.t(),
          name: String.t(),
          nickname: String.t(),
          email: String.t(),
          birthday: Date.t()
        }
end
