defmodule ApiGateway.Router do
  use ApiGateway, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/ping", ApiGateway do
    pipe_through(:api)

    get "/", PingController, :index
  end

  scope "/api", ApiGateway do
    pipe_through(:api)

    resources("/users", UsersController, only: [:index, :show, :create, :update, :delete])

    resources("/clubs", ClubsController, only: [:index, :show, :create, :update, :delete]) do
      resources("/members", ClubsController.Members, only: [:index, :create, :delete])
      resources("/staff", ClubsController.Staff, only: [:index, :create, :delete])
    end

    resources("/tournaments", TournamentsController,
      only: [:index, :show, :create, :update, :delete]
    )
  end
end
