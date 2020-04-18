defmodule ApiGateway.ClubsControllerTest do
  use ApiGateway.ConnCase

  import Mox

  describe "when listing clubs" do
    test "index/2 should return clubs with status 200", %{conn: conn} do
      ApiGateway.ClubsServiceMock
      |> expect(:list, fn ->
        {:ok, [%{name: "mock1"}, %{name: "mock2"}]}
      end)

      response =
        conn
        |> get(Routes.clubs_path(conn, :index))
        |> json_response(200)

      assert response == [%{"name" => "mock1"}, %{"name" => "mock2"}]
    end

    test "index/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.ClubsServiceMock
      |> expect(:list, fn ->
        {:error, %{reason: "error mock"}}
      end)

      response =
        conn
        |> get(Routes.clubs_path(conn, :index))
        |> json_response(500)

      assert response == %{"reason" => "error mock"}
    end
  end

  describe "when getting an club" do
    test "show/2 should return club with status 200", %{conn: conn} do
      ApiGateway.ClubsServiceMock
      |> expect(:get, fn id ->
        assert id == "mock_id"
        {:ok, %{name: "mock"}}
      end)

      response =
        conn
        |> get(Routes.clubs_path(conn, :show, "mock_id"))
        |> json_response(200)

      assert response == %{"name" => "mock"}
    end

    test "show/2 should fail with status 404 when no club is found", %{conn: conn} do
      ApiGateway.ClubsServiceMock
      |> expect(:get, fn id ->
        assert id == "mock_id"
        {:noreply, nil}
      end)

      response =
        conn
        |> get(Routes.clubs_path(conn, :show, "mock_id"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "show/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.ClubsServiceMock
      |> expect(:get, fn id ->
        assert id == "mock_id"
        {:error, %{reason: "error mock"}}
      end)

      response =
        conn
        |> get(Routes.clubs_path(conn, :show, "mock_id"))
        |> json_response(500)

      assert response == %{"reason" => "error mock"}
    end
  end

  describe "when creating an club" do
    test "create/2 should return created club with status 201", %{conn: conn} do
      club_mock = %{"name" => "mock"}

      ApiGateway.ClubsServiceMock
      |> expect(:create, fn club ->
        assert club == club_mock
        {:ok, Map.put(club, :id, "mock_id")}
      end)

      response =
        conn
        |> post(Routes.clubs_path(conn, :create, club_mock))
        |> json_response(201)

      assert response == %{"id" => "mock_id", "name" => "mock"}
    end

    test "create/2 should fail with status 400 when invalid payload is given", %{conn: conn} do
      club_mock = %{"invalid_name" => "mock"}

      ApiGateway.ClubsServiceMock
      |> expect(:create, fn club ->
        assert club == club_mock
        {:invalid, %{reason: "invalid payload mock"}}
      end)

      response =
        conn
        |> post(Routes.clubs_path(conn, :create, club_mock))
        |> json_response(400)

      assert response == %{"reason" => "invalid payload mock"}
    end

    test "create/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      club_mock = %{"name" => "mock"}

      ApiGateway.ClubsServiceMock
      |> expect(:create, fn club ->
        assert club == club_mock
        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> post(Routes.clubs_path(conn, :create, club_mock))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when updating an club" do
    test "update/2 should return updated club with status 200", %{conn: conn} do
      club_mock = %{"id" => "invalid_mock_id", "name" => "mock"}

      ApiGateway.ClubsServiceMock
      |> expect(:update, fn id, club ->
        assert id == "mock_id"
        assert club == Map.delete(club_mock, "id")

        {:ok, Map.put(club, "id", id)}
      end)

      response =
        conn
        |> put(Routes.clubs_path(conn, :update, "mock_id", club_mock))
        |> json_response(200)

      assert response == %{"id" => "mock_id", "name" => "mock"}
    end

    test "update/2 should fail with status 400 when invalid payload is given", %{conn: conn} do
      club_mock = %{"id" => "invalid_mock_id", "invalid_name" => "mock"}

      ApiGateway.ClubsServiceMock
      |> expect(:update, fn id, club ->
        assert id == "mock_id"
        assert club == Map.delete(club_mock, "id")

        {:invalid, %{reason: "wrong property 'invalida_name' mock"}}
      end)

      response =
        conn
        |> put(Routes.clubs_path(conn, :update, "mock_id", club_mock))
        |> json_response(400)

      assert response == %{"reason" => "wrong property 'invalida_name' mock"}
    end

    test "update/2 should fail with status 404 when no club is found", %{conn: conn} do
      club_mock = %{"id" => "invalid_mock_id", "name" => "mock"}

      ApiGateway.ClubsServiceMock
      |> expect(:update, fn id, club ->
        assert id == "mock_id"
        assert club == Map.delete(club_mock, "id")

        {:noreply, nil}
      end)

      response =
        conn
        |> put(Routes.clubs_path(conn, :update, "mock_id", club_mock))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "update/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      club_mock = %{"id" => "invalid_mock_id", "name" => "mock"}

      ApiGateway.ClubsServiceMock
      |> expect(:update, fn id, club ->
        assert id == "mock_id"
        assert club == Map.delete(club_mock, "id")

        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> put(Routes.clubs_path(conn, :update, "mock_id", club_mock))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when deleting an club" do
    test "delete/2 should return deleted club with status 200", %{conn: conn} do
      ApiGateway.ClubsServiceMock
      |> expect(:delete, fn id ->
        assert id == "mock_id"
        {:ok, %{id: id, name: "mock"}}
      end)

      response =
        conn
        |> delete(Routes.clubs_path(conn, :delete, "mock_id"))
        |> json_response(200)

      assert response == %{"id" => "mock_id", "name" => "mock"}
    end

    test "delete/2 should fail with status 404 when no club is found", %{conn: conn} do
      ApiGateway.ClubsServiceMock
      |> expect(:delete, fn id ->
        assert id == "mock_id"
        {:noreply, nil}
      end)

      response =
        conn
        |> delete(Routes.clubs_path(conn, :delete, "mock_id"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "delete/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.ClubsServiceMock
      |> expect(:delete, fn id ->
        assert id == "mock_id"
        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> delete(Routes.clubs_path(conn, :delete, "mock_id"))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when listing club's members" do
    test "index/2 should return club's members with status 200", %{conn: conn} do
      ApiGateway.ClubsService.MembersMock
      |> expect(:list, fn club_id ->
        assert club_id == "club_id_mock"
        {:ok, [%{name: "mock1"}, %{name: "mock2"}]}
      end)

      response =
        conn
        |> get(Routes.clubs_members_path(conn, :index, "club_id_mock"))
        |> json_response(200)

      assert response == [%{"name" => "mock1"}, %{"name" => "mock2"}]
    end

    test "delete/2 should fail with status 404 when no club is found", %{conn: conn} do
      ApiGateway.ClubsService.MembersMock
      |> expect(:list, fn club_id ->
        assert club_id == "club_id_mock"
        {:noreply, nil}
      end)

      response =
        conn
        |> get(Routes.clubs_members_path(conn, :index, "club_id_mock"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "index/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.ClubsService.MembersMock
      |> expect(:list, fn club_id ->
        assert club_id == "club_id_mock"
        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> get(Routes.clubs_members_path(conn, :index, "club_id_mock"))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when adding new member to club" do
    test "create/2 should return created club's member with status 201", %{conn: conn} do
      member_mock = %{"id" => "mock_id", "name" => "mock"}

      ApiGateway.ClubsService.MembersMock
      |> expect(:create, fn club_id, member ->
        assert club_id == "club_id_mock"
        assert member == member_mock

        {:ok, member_mock}
      end)

      response =
        conn
        |> post(Routes.clubs_members_path(conn, :create, "club_id_mock", member_mock))
        |> json_response(201)

      assert response == member_mock
    end

    test "create/2 should fail with status 400 when invalid payload is given", %{conn: conn} do
      member_mock = %{"id" => "mock_id", "invalid_name" => "mock"}

      ApiGateway.ClubsService.MembersMock
      |> expect(:create, fn club_id, member ->
        assert club_id == "club_id_mock"
        assert member == member_mock

        {:invalid, %{reason: "invalid payload mock"}}
      end)

      response =
        conn
        |> post(Routes.clubs_members_path(conn, :create, "club_id_mock", member_mock))
        |> json_response(400)

      assert response == %{"reason" => "invalid payload mock"}
    end

    test "create/2 should fail with status 404 when no club is found", %{conn: conn} do
      member_mock = %{"id" => "mock_id", "name" => "mock"}

      ApiGateway.ClubsService.MembersMock
      |> expect(:create, fn club_id, member ->
        assert club_id == "club_id_mock"
        assert member == member_mock

        {:noreply, nil}
      end)

      response =
        conn
        |> post(Routes.clubs_members_path(conn, :create, "club_id_mock", member_mock))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "create/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      member_mock = %{"id" => "mock_id", "name" => "mock"}

      ApiGateway.ClubsService.MembersMock
      |> expect(:create, fn club_id, member ->
        assert club_id == "club_id_mock"
        assert member == member_mock

        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> post(Routes.clubs_members_path(conn, :create, "club_id_mock", member_mock))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when removing a member from club" do
    test "delete/2 should return deleted member with status 200", %{conn: conn} do
      member_mock = %{"id" => "mock_id", "name" => "mock"}

      ApiGateway.ClubsService.MembersMock
      |> expect(:delete, fn club_id, member_id ->
        assert club_id == "club_id_mock"
        assert member_id == "member_id_mock"

        {:ok, member_mock}
      end)

      response =
        conn
        |> delete(Routes.clubs_members_path(conn, :delete, "club_id_mock", "member_id_mock"))
        |> json_response(200)

      assert response == member_mock
    end

    test "delete/2 should fail with status 404 when no club is found", %{conn: conn} do
      ApiGateway.ClubsService.MembersMock
      |> expect(:delete, fn club_id, member_id ->
        assert club_id == "club_id_mock"
        assert member_id == "member_id_mock"

        {:noreply, nil}
      end)

      response =
        conn
        |> delete(Routes.clubs_members_path(conn, :delete, "club_id_mock", "member_id_mock"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "delete/2 should fail with status 404 when no member is found in the club", %{conn: conn} do
      ApiGateway.ClubsService.MembersMock
      |> expect(:delete, fn club_id, member_id ->
        assert club_id == "club_id_mock"
        assert member_id == "member_id_mock"

        {:noreply, nil}
      end)

      response =
        conn
        |> delete(Routes.clubs_members_path(conn, :delete, "club_id_mock", "member_id_mock"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "delete/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.ClubsService.MembersMock
      |> expect(:delete, fn club_id, member_id ->
        assert club_id == "club_id_mock"
        assert member_id == "member_id_mock"

        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> delete(Routes.clubs_members_path(conn, :delete, "club_id_mock", "member_id_mock"))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when listing club's employee" do
    test "index/2 should return club's employee with status 200", %{conn: conn} do
      ApiGateway.ClubsService.StaffMock
      |> expect(:list, fn club_id ->
        assert club_id == "club_id_mock"
        {:ok, [%{name: "mock1"}, %{name: "mock2"}]}
      end)

      response =
        conn
        |> get(Routes.clubs_staff_path(conn, :index, "club_id_mock"))
        |> json_response(200)

      assert response == [%{"name" => "mock1"}, %{"name" => "mock2"}]
    end

    test "delete/2 should fail with status 404 when no club is found", %{conn: conn} do
      ApiGateway.ClubsService.StaffMock
      |> expect(:list, fn club_id ->
        assert club_id == "club_id_mock"
        {:noreply, nil}
      end)

      response =
        conn
        |> get(Routes.clubs_staff_path(conn, :index, "club_id_mock"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "index/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.ClubsService.StaffMock
      |> expect(:list, fn club_id ->
        assert club_id == "club_id_mock"
        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> get(Routes.clubs_staff_path(conn, :index, "club_id_mock"))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when adding new employee to club" do
    test "create/2 should return created club's employee with status 201", %{conn: conn} do
      employee_mock = %{"id" => "mock_id", "name" => "mock"}

      ApiGateway.ClubsService.StaffMock
      |> expect(:create, fn club_id, employee ->
        assert club_id == "club_id_mock"
        assert employee == employee_mock

        {:ok, employee_mock}
      end)

      response =
        conn
        |> post(Routes.clubs_staff_path(conn, :create, "club_id_mock", employee_mock))
        |> json_response(201)

      assert response == employee_mock
    end

    test "create/2 should fail with status 400 when invalid payload is given", %{conn: conn} do
      employee_mock = %{"id" => "mock_id", "invalid_name" => "mock"}

      ApiGateway.ClubsService.StaffMock
      |> expect(:create, fn club_id, employee ->
        assert club_id == "club_id_mock"
        assert employee == employee_mock

        {:invalid, %{reason: "invalid payload mock"}}
      end)

      response =
        conn
        |> post(Routes.clubs_staff_path(conn, :create, "club_id_mock", employee_mock))
        |> json_response(400)

      assert response == %{"reason" => "invalid payload mock"}
    end

    test "create/2 should fail with status 404 when no club is found", %{conn: conn} do
      employee_mock = %{"id" => "mock_id", "invalid_name" => "mock"}

      ApiGateway.ClubsService.StaffMock
      |> expect(:create, fn club_id, employee ->
        assert club_id == "club_id_mock"
        assert employee == employee_mock

        {:noreply, nil}
      end)

      response =
        conn
        |> post(Routes.clubs_staff_path(conn, :create, "club_id_mock", employee_mock))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "create/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      employee_mock = %{"id" => "mock_id", "invalid_name" => "mock"}

      ApiGateway.ClubsService.StaffMock
      |> expect(:create, fn club_id, employee ->
        assert club_id == "club_id_mock"
        assert employee == employee_mock

        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> post(Routes.clubs_staff_path(conn, :create, "club_id_mock", employee_mock))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end

  describe "when removing a employee from club" do
    test "delete/2 should return deleted employee with status 200", %{conn: conn} do
      employee_mock = %{"id" => "mock_id", "name" => "mock"}

      ApiGateway.ClubsService.StaffMock
      |> expect(:delete, fn club_id, employee_id ->
        assert club_id == "club_id_mock"
        assert employee_id == "employee_id_mock"

        {:ok, employee_mock}
      end)

      response =
        conn
        |> delete(Routes.clubs_staff_path(conn, :delete, "club_id_mock", "employee_id_mock"))
        |> json_response(200)

      assert response == employee_mock
    end

    test "delete/2 should fail with status 404 when no club is found", %{conn: conn} do
      ApiGateway.ClubsService.StaffMock
      |> expect(:delete, fn club_id, employee_id ->
        assert club_id == "club_id_mock"
        assert employee_id == "employee_id_mock"

        {:noreply, nil}
      end)

      response =
        conn
        |> delete(Routes.clubs_staff_path(conn, :delete, "club_id_mock", "employee_id_mock"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "delete/2 should fail with status 404 when no employee is found in the club", %{
      conn: conn
    } do
      ApiGateway.ClubsService.StaffMock
      |> expect(:delete, fn club_id, employee_id ->
        assert club_id == "club_id_mock"
        assert employee_id == "employee_id_mock"

        {:noreply, nil}
      end)

      response =
        conn
        |> delete(Routes.clubs_staff_path(conn, :delete, "club_id_mock", "employee_id_mock"))
        |> json_response(404)

      assert response == %{"reason" => "entity not found"}
    end

    test "delete/2 should fail with status 500 when an unexpected error occurs", %{conn: conn} do
      ApiGateway.ClubsService.StaffMock
      |> expect(:delete, fn club_id, employee_id ->
        assert club_id == "club_id_mock"
        assert employee_id == "employee_id_mock"

        {:error, %{reason: "unexpected error mock"}}
      end)

      response =
        conn
        |> delete(Routes.clubs_staff_path(conn, :delete, "club_id_mock", "employee_id_mock"))
        |> json_response(500)

      assert response == %{"reason" => "unexpected error mock"}
    end
  end
end
