defmodule ApiGateway.TournamentsControllerTest do
  use ApiGateway.ConnCase

  import Mox

  describe "when listing tournaments" do
    test "index/2 should return tournaments with status 200", %{conn: conn} do
      ApiGateway.TournamentsServiceMock
      |> expect(:list, fn ->
        {:ok, [%{name: "mock1"}, %{name: "mock2"}]}
      end)

      response =
        conn
        |> get(Routes.tournaments_path(conn, :index))
        |> json_response(200)

      assert response == [%{"name" => "mock1"}, %{"name" => "mock2"}]
    end

    test "index/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.TournamentsServiceMock
      |> expect(:list, fn ->
        {:error, %{reason: "error mock"}}
      end)

      response =
        conn
        |> get(Routes.tournaments_path(conn, :index))
        |> json_response(500)

      assert response == %{"reason" => "error mock"}
    end
  end

  describe "when getting an tournament" do
    test "show/2 should return tournament with status 200", %{conn: conn} do
      ApiGateway.TournamentsServiceMock
      |> expect(:get, fn id ->
        assert id == "mock_id"
        {:ok, %{name: "mock"}}
      end)

      response =
        conn
        |> get(Routes.tournaments_path(conn, :show, "mock_id"))
        |> json_response(200)

      assert response == %{"name" => "mock"}
    end

    test "show/2 should fail with status 404 when no tournament is found", %{conn: conn} do
      ApiGateway.TournamentsServiceMock
      |> expect(:get, fn id ->
        assert id == "mock_id"
        {:noreply, nil}
      end)

      response =
        conn
        |> get(Routes.tournaments_path(conn, :show, "mock_id"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "show/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.TournamentsServiceMock
      |> expect(:get, fn id ->
        assert id == "mock_id"
        {:error, %{reason: "error mock"}}
      end)

      response =
        conn
        |> get(Routes.tournaments_path(conn, :show, "mock_id"))
        |> json_response(500)

      assert response == %{"reason" => "error mock"}
    end
  end

  describe "when creating an tournament" do
    test "create/2 should return created tournament with status 201", %{conn: conn} do
      tournament_mock = %{"name" => "mock"}

      ApiGateway.TournamentsServiceMock
      |> expect(:create, fn tournament ->
        assert tournament == tournament_mock
        {:ok, Map.put(tournament, :id, "mock_id")}
      end)

      response =
        conn
        |> post(Routes.tournaments_path(conn, :create, tournament_mock))
        |> json_response(201)

      assert response == %{"id" => "mock_id", "name" => "mock"}
    end

    test "create/2 should fail with status 400 when invalid payload is given", %{conn: conn} do
      tournament_mock = %{"invalid_name" => "mock"}

      ApiGateway.TournamentsServiceMock
      |> expect(:create, fn tournament ->
        assert tournament == tournament_mock
        {:invalid, %{reason: "invalid payload mock"}}
      end)

      response =
        conn
        |> post(Routes.tournaments_path(conn, :create, tournament_mock))
        |> json_response(400)

      assert response == %{"reason" => "invalid payload mock"}
    end

    test "create/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      tournament_mock = %{"name" => "mock"}

      ApiGateway.TournamentsServiceMock
      |> expect(:create, fn tournament ->
        assert tournament == tournament_mock
        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> post(Routes.tournaments_path(conn, :create, tournament_mock))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when updating an tournament" do
    test "update/2 should return updated tournament with status 200", %{conn: conn} do
      tournament_mock = %{"id" => "invalid_mock_id", "name" => "mock"}

      ApiGateway.TournamentsServiceMock
      |> expect(:update, fn id, tournament ->
        assert id == "mock_id"
        assert tournament == Map.delete(tournament_mock, "id")

        {:ok, Map.put(tournament, "id", id)}
      end)

      response =
        conn
        |> put(Routes.tournaments_path(conn, :update, "mock_id", tournament_mock))
        |> json_response(200)

      assert response == %{"id" => "mock_id", "name" => "mock"}
    end

    test "update/2 should fail with status 400 when invalid payload is given", %{conn: conn} do
      tournament_mock = %{"id" => "invalid_mock_id", "invalid_name" => "mock"}

      ApiGateway.TournamentsServiceMock
      |> expect(:update, fn id, tournament ->
        assert id == "mock_id"
        assert tournament == Map.delete(tournament_mock, "id")

        {:invalid, %{reason: "wrong property 'invalida_name' mock"}}
      end)

      response =
        conn
        |> put(Routes.tournaments_path(conn, :update, "mock_id", tournament_mock))
        |> json_response(400)

      assert response == %{"reason" => "wrong property 'invalida_name' mock"}
    end

    test "update/2 should fail with status 404 when no tournament is found", %{conn: conn} do
      tournament_mock = %{"id" => "invalid_mock_id", "name" => "mock"}

      ApiGateway.TournamentsServiceMock
      |> expect(:update, fn id, tournament ->
        assert id == "mock_id"
        assert tournament == Map.delete(tournament_mock, "id")

        {:noreply, nil}
      end)

      response =
        conn
        |> put(Routes.tournaments_path(conn, :update, "mock_id", tournament_mock))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "update/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      tournament_mock = %{"id" => "invalid_mock_id", "name" => "mock"}

      ApiGateway.TournamentsServiceMock
      |> expect(:update, fn id, tournament ->
        assert id == "mock_id"
        assert tournament == Map.delete(tournament_mock, "id")

        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> put(Routes.tournaments_path(conn, :update, "mock_id", tournament_mock))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when deleting an tournament" do
    test "delete/2 should return deleted tournament with status 200", %{conn: conn} do
      ApiGateway.TournamentsServiceMock
      |> expect(:delete, fn id ->
        assert id == "mock_id"
        {:ok, %{id: id, name: "mock"}}
      end)

      response =
        conn
        |> delete(Routes.tournaments_path(conn, :delete, "mock_id"))
        |> json_response(200)

      assert response == %{"id" => "mock_id", "name" => "mock"}
    end

    test "delete/2 should fail with status 404 when no tournament is found", %{conn: conn} do
      ApiGateway.TournamentsServiceMock
      |> expect(:delete, fn id ->
        assert id == "mock_id"
        {:noreply, nil}
      end)

      response =
        conn
        |> delete(Routes.tournaments_path(conn, :delete, "mock_id"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "delete/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.TournamentsServiceMock
      |> expect(:delete, fn id ->
        assert id == "mock_id"
        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> delete(Routes.tournaments_path(conn, :delete, "mock_id"))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end
end
