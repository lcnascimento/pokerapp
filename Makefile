containers:
	@ echo
	@ echo "Starting downloading dependencies..."
	@ echo
	@ docker-compose up -d

seed:
	@ echo
	@ echo "Starting downloading dependencies..."
	@ echo
	@ docker-compose exec cassandra1 "cqlsh < /seed/users_service.sql"

%:
	@:
