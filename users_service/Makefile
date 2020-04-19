include .env
export $(shell sed 's/=.*//' .env)

dependencies:
	@ echo
	@ echo "Starting downloading dependencies..."
	@ echo
	@ mix deps.get

tests:
	@ echo
	@ echo "Starting running tests..."
	@ echo
	@ mix test --trace --exclude skip:true

%:
	@:
