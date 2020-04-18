defmodule ApiGateway.Contracts do
  @type error :: %{
          reason: String.t()
        }

  defmodule ClubsService do
    alias ApiGateway.Contracts

    @callback list() ::
                {:ok, [map()]}
                | {:error, Contracts.error()}

    @callback get(id :: String.t()) ::
                {:ok, map()}
                | {:noreply, nil}
                | {:error, Contracts.error()}

    @callback create(club :: map()) ::
                {:ok, map()}
                | {:invalid, Contracts.error()}
                | {:error, Contracts.error()}

    @callback update(id :: String.t(), club :: map()) ::
                {:ok, map()}
                | {:noreply, nil}
                | {:invalid, Contracts.error()}
                | {:error, Contracts.error()}

    @callback delete(id :: String.t()) ::
                {:ok, map()}
                | {:noreply, nil}
                | {:error, Contracts.error()}

    defmodule Members do
      alias ApiGateway.Contracts

      @callback list(club_id :: String.t()) ::
                  {:ok, [map()]}
                  | {:noreply, nil}
                  | {:error, Contracts.error()}

      @callback create(club_id :: String.t(), member :: map()) ::
                  {:ok, map()}
                  | {:noreply, nil}
                  | {:invalid, Contracts.error()}
                  | {:error, Contracts.error()}

      @callback delete(club_id :: String.t(), id :: String.t()) ::
                  {:ok, map()}
                  | {:noreply, nil}
                  | {:error, Contracts.error()}
    end

    defmodule Staff do
      alias ApiGateway.Contracts

      @callback list(club_id :: String.t()) ::
                  {:ok, [map()]}
                  | {:noreply, nil}
                  | {:error, Contracts.error()}

      @callback create(club_id :: String.t(), employee :: map()) ::
                  {:ok, map()}
                  | {:noreply, nil}
                  | {:invalid, Contracts.error()}
                  | {:error, Contracts.error()}

      @callback delete(club_id :: String.t(), id :: String.t()) ::
                  {:ok, map()}
                  | {:noreply, nil}
                  | {:error, Contracts.error()}
    end
  end

  defmodule TournamentsService do
    @callback list() ::
                {:ok, [map()]}
                | {:error, Contracts.error()}

    @callback get(id :: String.t()) ::
                {:ok, map()}
                | {:noreply, nil}
                | {:error, Contracts.error()}

    @callback create(tournament :: map()) ::
                {:ok, map()}
                | {:invalid, Contracts.error()}
                | {:error, Contracts.error()}

    @callback update(id :: String.t(), club :: map()) ::
                {:ok, map()}
                | {:noreply, nil}
                | {:invalid, Contracts.error()}
                | {:error, Contracts.error()}

    @callback delete(id :: String.t()) ::
                {:ok, map()}
                | {:noreply, nil}
                | {:error, Contracts.error()}
  end

  defmodule UsersService do
    @callback list() ::
                {:ok, [map()]}
                | {:error, Contracts.error()}

    @callback get(id :: String.t()) ::
                {:ok, map()}
                | {:noreply, nil}
                | {:error, Contracts.error()}

    @callback create(user :: map()) ::
                {:ok, map()}
                | {:invalid, Contracts.error()}
                | {:error, Contracts.error()}

    @callback update(id :: String.t(), club :: map()) ::
                {:ok, map()}
                | {:noreply, nil}
                | {:invalid, Contracts.error()}
                | {:error, Contracts.error()}

    @callback delete(id :: String.t()) ::
                {:ok, map()}
                | {:noreply, nil}
                | {:error, Contracts.error()}
  end
end
