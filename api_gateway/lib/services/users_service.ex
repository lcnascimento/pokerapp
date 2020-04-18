defmodule ApiGateway.UsersService do
  alias ApiGateway.Contracts
  alias ApiGateway.Contracts.UsersService

  @behaviour UsersService

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
  def create(_user) do
    {:error, %{reason: "NotImplemented"}}
  end

  @spec update(id :: String.t(), user :: map()) ::
          {:ok, map()}
          | {:noreply, nil}
          | {:invalid, Contracts.error()}
          | {:error, Contracts.error()}
  def update(_id, _user) do
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
