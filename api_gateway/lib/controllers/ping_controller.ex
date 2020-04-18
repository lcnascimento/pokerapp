defmodule ApiGateway.PingController do
  use ApiGateway, :controller

  def index(conn, _params) do
    conn |> put_status(200) |> json(%{message: "pong"})
  end
end
