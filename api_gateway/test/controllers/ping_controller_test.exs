defmodule ApiGateway.PingControllerTest do
  use ApiGateway.ConnCase

  test "index/2 should respond with 'pong' message", %{conn: conn} do
    response =
      conn
      |> get(Routes.ping_path(conn, :index))
      |> json_response(200)

    assert response == %{"message" => "pong"}
  end
end
