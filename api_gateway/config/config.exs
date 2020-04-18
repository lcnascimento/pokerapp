# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :api_gateway, ApiGateway.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Z2Q6etXObFREC2yKWOvcf11/rQdoldIG2Xd1qI4bhVuZOn7INL1TwWvMMYhhrFd4",
  pubsub: [name: ApiGateway.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "OVt6oBz4"]

config :api_gateway,
  clubs_service: ApiGateway.ClubsService,
  club_members_service: ApiGateway.ClubsService.Members,
  club_staff_service: ApiGateway.ClubsService.Staff,
  tournaments_service: ApiGateway.TournamentsService,
  users_service: ApiGateway.UsersService

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"