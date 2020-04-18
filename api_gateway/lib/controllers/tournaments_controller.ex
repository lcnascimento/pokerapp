defmodule ApiGateway.TournamentsController do
  use ApiGateway, :controller

  def index(conn, _params) do
    {status, payload} =
      case tournaments_service().list() do
        {:ok, tournaments} -> {200, tournaments}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def show(conn, params) do
    {status, payload} =
      case tournaments_service().get(params["id"]) do
        {:ok, tournament} -> {200, tournament}
        {:noreply, _} -> {404, %{reason: "entity not found"}}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def create(conn, params) do
    {status, payload} =
      case tournaments_service().create(params) do
        {:ok, tournament} -> {201, tournament}
        {:invalid, reason} -> {400, reason}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def update(conn, params) do
    {status, payload} =
      case tournaments_service().update(params["id"], Map.delete(params, "id")) do
        {:ok, tournament} -> {200, tournament}
        {:noreply, _} -> {404, %{reason: "entity not found"}}
        {:invalid, reason} -> {400, reason}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def delete(conn, params) do
    {status, payload} =
      case tournaments_service().delete(params["id"]) do
        {:ok, tournament} -> {200, tournament}
        {:noreply, _} -> {404, %{reason: "entity not found"}}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  defp tournaments_service do
    Application.fetch_env!(:api_gateway, :tournaments_service)
  end
end
