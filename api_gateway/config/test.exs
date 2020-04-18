import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api_gateway, ApiGateway.Endpoint,
  http: [port: 4002],
  server: false

config :api_gateway,
  clubs_service: ApiGateway.ClubsServiceMock,
  club_members_service: ApiGateway.ClubsService.MembersMock,
  club_staff_service: ApiGateway.ClubsService.StaffMock,
  tournaments_service: ApiGateway.TournamentsServiceMock,
  users_service: ApiGateway.UsersServiceMock

# Print only warnings and errors during test
config :logger, level: :warn
