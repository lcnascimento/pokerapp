defmodule ApiGateway.TournamentsService do
  alias ApiGateway.Contracts
  alias ApiGateway.Contracts.TournamentsService

  @behaviour TournamentsService

  @spec list() ::
          {:ok, [map()]}
          | {:error, Contracts.error()}
  def list() do
    {:error, %{reason: "NotImplemented"}}
  end

  @spec get(id :: String.t()) ::
          {:ok, map()}
          | {:noreply, nil}
          | {:error, Contracts.error()}
  def get(_id) do
    {:error, %{reason: "NotImplemented"}}
  end

  @spec create(user :: map()) ::
          {:ok, map()}
          | {:invalid, Contracts.error()}
          | {:error, Contracts.error()}
  def create(_tournament) do
    {:error, %{reason: "NotImplemented"}}
  end

  @spec update(id :: String.t(), club :: map()) ::
          {:ok, map()}
          | {:noreply, nil}
          | {:invalid, Contracts.error()}
          | {:error, Contracts.error()}
  def update(_id, _club) do
    {:error, %{reason: "NotImplemented"}}
  end

  @spec delete(id :: String.t()) ::
          {:ok, map()}
          | {:noreply, nil}
          | {:error, Contracts.error()}
  def delete(_id) do
    {:error, %{reason: "NotImplemented"}}
  end
end
