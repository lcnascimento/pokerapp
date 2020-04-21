import Config

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :kafka_ex,
  consumer_group: "users_service",
  client_id: "users_service",
  kafka_version: "5.4.0",
  disable_default_worker: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
