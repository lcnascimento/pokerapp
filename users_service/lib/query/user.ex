defmodule UsersService.Query.Entity do
  defmodule User do
    defstruct [:cpf, :name, :nickname, :email, :birthday, :created_at, :updated_at]

    @type t :: %User{
            cpf: String.t(),
            name: String.t(),
            nickname: String.t(),
            email: String.t(),
            birthday: Date.t(),
            created_at: DateTime.t(),
            updated_at: DateTime.t()
          }
  end
end
