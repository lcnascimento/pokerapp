defmodule ApiGateway.ClubsService do
  alias ApiGateway.Contracts
  alias ApiGateway.Contracts.ClubsService

  @behaviour ClubsService

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
  def create(_club) do
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

  defmodule Members do
    alias ApiGateway.Contracts

    @spec list(club_id :: String.t()) ::
            {:ok, [map()]}
            | {:noreply, nil}
            | {:error, Contracts.error()}
    def list(_club_id) do
      {:error, %{reason: "NotImplemented"}}
    end

    @spec create(club_id :: String.t(), member :: map()) ::
            {:ok, map()}
            | {:noreply, nil}
            | {:invalid, Contracts.error()}
            | {:error, Contracts.error()}
    def create(_club_id, _member) do
      {:error, %{reason: "NotImplemented"}}
    end

    @spec delete(club_id :: String.t(), id :: String.t()) ::
            {:ok, map()}
            | {:noreply, nil}
            | {:error, Contracts.error()}
    def delete(_club_id, _id) do
      {:error, %{reason: "NotImplemented"}}
    end
  end

  defmodule Staff do
    alias ApiGateway.Contracts

    @spec list(club_id :: String.t()) ::
            {:ok, [map()]}
            | {:noreply, nil}
            | {:error, Contracts.error()}
    def list(_club_id) do
      {:error, %{reason: "NotImplemented"}}
    end

    @spec create(club_id :: String.t(), employee :: map()) ::
            {:ok, map()}
            | {:noreply, nil}
            | {:invalid, Contracts.error()}
            | {:error, Contracts.error()}
    def create(_club_id, _employee) do
      {:error, %{reason: "NotImplemented"}}
    end

    @spec delete(club_id :: String.t(), id :: String.t()) ::
            {:ok, map()}
            | {:noreply, nil}
            | {:error, Contracts.error()}
    def delete(_club_id, _id) do
      {:error, %{reason: "NotImplemented"}}
    end
  end
end
