Mox.defmock(
  ApiGateway.ClubsServiceMock,
  for: ApiGateway.Contracts.ClubsService
)

Mox.defmock(
  ApiGateway.ClubsService.MembersMock,
  for: ApiGateway.Contracts.ClubsService.Members
)

Mox.defmock(
  ApiGateway.ClubsService.StaffMock,
  for: ApiGateway.Contracts.ClubsService.Staff
)

Mox.defmock(
  ApiGateway.TournamentsServiceMock,
  for: ApiGateway.Contracts.TournamentsService
)

Mox.defmock(
  ApiGateway.UsersServiceMock,
  for: ApiGateway.Contracts.UsersService
)
