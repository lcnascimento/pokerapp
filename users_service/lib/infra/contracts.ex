defmodule UsersService.Infra do
  defmodule Event do
    defstruct [:row_id, :aggregate_id, :type, :payload, :timestamp]

    @type t :: %Event{
            row_id: String.t(),
            aggregate_id: String.t(),
            type: String.t(),
            payload: map(),
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
