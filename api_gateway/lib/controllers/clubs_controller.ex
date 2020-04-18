defmodule ApiGateway.ClubsController do
  use ApiGateway, :controller

  def index(conn, _params) do
    {status, payload} =
      case clubs_service().list() do
        {:ok, clubs} -> {200, clubs}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def show(conn, params) do
    {status, payload} =
      case clubs_service().get(params["id"]) do
        {:ok, club} -> {200, club}
        {:noreply, _} -> {404, %{reason: "entity not found"}}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def create(conn, params) do
    {status, payload} =
      case clubs_service().create(params) do
        {:ok, club} -> {201, club}
        {:invalid, reason} -> {400, reason}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def update(conn, params) do
    {status, payload} =
      case clubs_service().update(params["id"], Map.delete(params, "id")) do
        {:ok, club} -> {200, club}
        {:noreply, _} -> {404, %{reason: "entity not found"}}
        {:invalid, reason} -> {400, reason}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  def delete(conn, params) do
    {status, payload} =
      case clubs_service().delete(params["id"]) do
        {:ok, club} -> {200, club}
        {:noreply, _} -> {404, %{reason: "entity not found"}}
        {:error, reason} -> {500, reason}
      end

    conn |> put_status(status) |> json(payload)
  end

  defp clubs_service do
    Application.fetch_env!(:api_gateway, :clubs_service)
  end

  defmodule Members do
    use ApiGateway, :controller

    def index(conn, params) do
      {status, payload} =
        case members_service().list(params["clubs_id"]) do
          {:ok, members} -> {200, members}
          {:noreply, _} -> {404, %{reason: "entity not found"}}
          {:error, reason} -> {500, reason}
        end

      conn |> put_status(status) |> json(payload)
    end

    def create(conn, params) do
      {status, payload} =
        case members_service().create(params["clubs_id"], Map.delete(params, "clubs_id")) do
          {:ok, member} -> {201, member}
          {:noreply, _} -> {404, %{reason: "entity not found"}}
          {:invalid, reason} -> {400, reason}
          {:error, reason} -> {500, reason}
        end

      conn |> put_status(status) |> json(payload)
    end

    def delete(conn, params) do
      {status, payload} =
        case members_service().delete(params["clubs_id"], params["id"]) do
          {:ok, member} -> {200, member}
          {:noreply, _} -> {404, %{reason: "entity not found"}}
          {:error, reason} -> {500, reason}
        end

      conn |> put_status(status) |> json(payload)
    end

    defp members_service do
      Application.fetch_env!(:api_gateway, :club_members_service)
    end
  end

  defmodule Staff do
    use ApiGateway, :controller

    def index(conn, params) do
      {status, payload} =
        case staff_service().list(params["clubs_id"]) do
          {:ok, staff} -> {200, staff}
          {:noreply, _} -> {404, %{reason: "entity not found"}}
          {:error, reason} -> {500, reason}
        end

      conn |> put_status(status) |> json(payload)
    end

    def create(conn, params) do
      {status, payload} =
        case staff_service().create(params["clubs_id"], Map.delete(params, "clubs_id")) do
          {:ok, employee} -> {201, employee}
          {:noreply, _} -> {404, %{reason: "entity not found"}}
          {:invalid, reason} -> {400, reason}
          {:error, reason} -> {500, reason}
        end

      conn |> put_status(status) |> json(payload)
    end

    def delete(conn, params) do
      {status, payload} =
        case staff_service().delete(params["clubs_id"], params["id"]) do
          {:ok, employee} -> {200, employee}
          {:noreply, _} -> {404, %{reason: "entity not found"}}
          {:error, reason} -> {500, reason}
        end

      conn |> put_status(status) |> json(payload)
    end

    defp staff_service do
      Application.fetch_env!(:api_gateway, :club_staff_service)
    end
  end
end
