defmodule ApiGateway.UsersControllerTest do
  use ApiGateway.ConnCase

  import Mox

  describe "when listing users" do
    test "index/2 should return users with status 200", %{conn: conn} do
      ApiGateway.UsersServiceMock
      |> expect(:list, fn ->
        {:ok, [%{name: "mock1"}, %{name: "mock2"}]}
      end)

      response =
        conn
        |> get(Routes.users_path(conn, :index))
        |> json_response(200)

      assert response == [%{"name" => "mock1"}, %{"name" => "mock2"}]
    end

    test "index/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.UsersServiceMock
      |> expect(:list, fn ->
        {:error, %{reason: "error mock"}}
      end)

      response =
        conn
        |> get(Routes.users_path(conn, :index))
        |> json_response(500)

      assert response == %{"reason" => "error mock"}
    end
  end

  describe "when getting an user" do
    test "show/2 should return user with status 200", %{conn: conn} do
      ApiGateway.UsersServiceMock
      |> expect(:get, fn id ->
        assert id == "mock_id"
        {:ok, %{name: "mock"}}
      end)

      response =
        conn
        |> get(Routes.users_path(conn, :show, "mock_id"))
        |> json_response(200)

      assert response == %{"name" => "mock"}
    end

    test "show/2 should fail with status 404 when no user is found", %{conn: conn} do
      ApiGateway.UsersServiceMock
      |> expect(:get, fn id ->
        assert id == "mock_id"
        {:noreply, nil}
      end)

      response =
        conn
        |> get(Routes.users_path(conn, :show, "mock_id"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "show/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.UsersServiceMock
      |> expect(:get, fn id ->
        assert id == "mock_id"
        {:error, %{reason: "error mock"}}
      end)

      response =
        conn
        |> get(Routes.users_path(conn, :show, "mock_id"))
        |> json_response(500)

      assert response == %{"reason" => "error mock"}
    end
  end

  describe "when creating an user" do
    test "create/2 should return created user with status 201", %{conn: conn} do
      user_mock = %{"name" => "mock"}

      ApiGateway.UsersServiceMock
      |> expect(:create, fn user ->
        assert user == user_mock
        {:ok, Map.put(user, :id, "mock_id")}
      end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, user_mock))
        |> json_response(201)

      assert response == %{"id" => "mock_id", "name" => "mock"}
    end

    test "create/2 should fail with status 400 when invalid payload is given", %{conn: conn} do
      user_mock = %{"invalid_name" => "mock"}

      ApiGateway.UsersServiceMock
      |> expect(:create, fn user ->
        assert user == user_mock
        {:invalid, %{reason: "invalid payload mock"}}
      end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, user_mock))
        |> json_response(400)

      assert response == %{"reason" => "invalid payload mock"}
    end

    test "create/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      user_mock = %{"name" => "mock"}

      ApiGateway.UsersServiceMock
      |> expect(:create, fn user ->
        assert user == user_mock
        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, user_mock))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when updating an user" do
    test "update/2 should return updated user with status 200", %{conn: conn} do
      user_mock = %{"id" => "invalid_mock_id", "name" => "mock"}

      ApiGateway.UsersServiceMock
      |> expect(:update, fn id, user ->
        assert id == "mock_id"
        assert user == Map.delete(user_mock, "id")

        {:ok, Map.put(user, "id", id)}
      end)

      response =
        conn
        |> put(Routes.users_path(conn, :update, "mock_id", user_mock))
        |> json_response(200)

      assert response == %{"id" => "mock_id", "name" => "mock"}
    end

    test "update/2 should fail with status 400 when invalid payload is given", %{conn: conn} do
      user_mock = %{"id" => "invalid_mock_id", "invalid_name" => "mock"}

      ApiGateway.UsersServiceMock
      |> expect(:update, fn id, user ->
        assert id == "mock_id"
        assert user == Map.delete(user_mock, "id")

        {:invalid, %{reason: "wrong property 'invalida_name' mock"}}
      end)

      response =
        conn
        |> put(Routes.users_path(conn, :update, "mock_id", user_mock))
        |> json_response(400)

      assert response == %{"reason" => "wrong property 'invalida_name' mock"}
    end

    test "update/2 should fail with status 404 when no user is found", %{conn: conn} do
      user_mock = %{"id" => "invalid_mock_id", "name" => "mock"}

      ApiGateway.UsersServiceMock
      |> expect(:update, fn id, user ->
        assert id == "mock_id"
        assert user == Map.delete(user_mock, "id")

        {:noreply, nil}
      end)

      response =
        conn
        |> put(Routes.users_path(conn, :update, "mock_id", user_mock))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "update/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      user_mock = %{"id" => "invalid_mock_id", "name" => "mock"}

      ApiGateway.UsersServiceMock
      |> expect(:update, fn id, user ->
        assert id == "mock_id"
        assert user == Map.delete(user_mock, "id")

        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> put(Routes.users_path(conn, :update, "mock_id", user_mock))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when deleting an user" do
    test "delete/2 should return deleted user with status 200", %{conn: conn} do
      ApiGateway.UsersServiceMock
      |> expect(:delete, fn id ->
        assert id == "mock_id"
        {:ok, %{id: id, name: "mock"}}
      end)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, "mock_id"))
        |> json_response(200)

      assert response == %{"id" => "mock_id", "name" => "mock"}
    end

    test "delete/2 should fail with status 404 when no user is found", %{conn: conn} do
      ApiGateway.UsersServiceMock
      |> expect(:delete, fn id ->
        assert id == "mock_id"
        {:noreply, nil}
      end)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, "mock_id"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "delete/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.UsersServiceMock
      |> expect(:delete, fn id ->
        assert id == "mock_id"
        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, "mock_id"))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end
end
