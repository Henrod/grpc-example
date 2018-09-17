RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)
PROJECTNAME := $(shell basename "$(PWD)")

help: Makefile
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@echo ""
	@cat Makefile | sed -n 's/^##//p' | column -t -s ':' |  sed -e 's/^/ /'

# runs grpc client
client:
	GRPC_SERVER_ADDRESS=$(GRPC_SERVER_ADDRESS) go run client/main.go

# runs grpc server
server:
	GRPC_SERVER_ADDRESS=$(GRPC_SERVER_ADDRESS) go run client/main.go
