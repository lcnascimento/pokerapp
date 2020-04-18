defmodule ApiGateway.UsersController do
  use ApiGateway, :controller

  def index(conn, _params) do
    {status, payload} =
      case users_service().list() do
        {:ok, users} -> {200, users}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def show(conn, params) do
    {status, payload} =
      case users_service().get(params["id"]) do
        {:ok, user} -> {200, user}
        {:noreply, _} -> {404, %{reason: "entity not found"}}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def create(conn, params) do
    {status, payload} =
      case users_service().create(params) do
        {:ok, user} -> {201, user}
        {:invalid, reason} -> {400, reason}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def update(conn, params) do
    {status, payload} =
      case users_service().update(params["id"], Map.delete(params, "id")) do
        {:ok, user} -> {200, user}
        {:invalid, reason} -> {400, reason}
        {:noreply, _} -> {404, %{reason: "entity not found"}}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def delete(conn, params) do
    {status, payload} =
      case users_service().delete(params["id"]) do
        {:ok, user} -> {200, user}
        {:noreply, _} -> {404, %{reason: "entity not found"}}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  defp users_service do
    Application.fetch_env!(:api_gateway, :users_service)
  end
end
