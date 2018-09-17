RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)
PROJECTNAME := $(shell basename "$(PWD)")

help: Makefile
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@echo ""
	@cat Makefile | sed -n 's/^##//p' | column -t -s ':' |  sed -e 's/^/ /'

## client: runs grpc client
client:
	GRPC_SERVER_ADDRESS=$(GRPC_SERVER_ADDRESS) go run client/main.go

## server: runs grpc server
server:
	GRPC_SERVER_ADDRESS=$(GRPC_SERVER_ADDRESS) go run client/main.go

## client-image: builds client docker image
client-image:
	@TYPE=client make linux-bin
	@TYPE=client make image

## server-image: builds server docker image
server-image:
	@TYPE=server make linux-bin
	@TYPE=server make image

linux-bin:
	@echo "making $(TYPE) bin"
	@env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o $(TYPE)/main $(TYPE)/main.go
	@chmod a+x $(TYPE)/main
	@echo "done making bin"

image:
	@echo "making $(TYPE) docker image"
	@docker build -t local/grpc-$(TYPE) --build-arg TYPE=$(TYPE) .
	@echo "done making image"
