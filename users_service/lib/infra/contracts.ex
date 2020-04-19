defmodule UsersService.Infra do
  defmodule Event do
    defstruct [:row_id, :aggregate_id, :action, :payload, :timestamp]

    @type t :: %Event{
            row_id: String.t(),
            aggregate_id: String.t(),
            action: String.t(),
            payload: binary(),
            timestamp: Time.t()
          }
  end

  defmodule Error do
    defstruct [:message]

    @type t :: %Error{
            message: String.t()
          }
  end

  defmodule Contracts do
  end
end
