RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(RUN_ARGS):;@:)
PROJECTNAME := $(shell basename "$(PWD)")
MY_IP ?= $$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n 1)

.PHONY: client server

help: Makefile
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@echo ""
	@cat Makefile | sed -n 's/^##//p' | column -t -s ':' |  sed -e 's/^/ /'

## server: runs grpc server
server:
	GRPC_SERVER_ADDRESS=$(GRPC_SERVER_ADDRESS) go run client/main.go

## client: runs grpc client
client:
	GRPC_SERVER_ADDRESS=$(GRPC_SERVER_ADDRESS) go run client/main.go

## server-image: builds server docker image
server-image:
	@TYPE=server make linux-bin
	@TYPE=server make image

## client-image: builds client docker image
client-image:
	@TYPE=client make linux-bin
	@TYPE=client make image

## run-server-docker: runs server on docker
run-server-docker:
	@docker run --env GRPC_SERVER_ADDRESS=0.0.0.0:55001 -p 55001:55001 --rm local/grpc-server

## run-client-docker: runs client on docker
run-client-docker:
	@docker run --env GRPC_SERVER_ADDRESS=${MY_IP}:55001 --rm local/grpc-client

linux-bin:
	@echo "making $(TYPE) bin"
	@env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o $(TYPE)/main $(TYPE)/main.go
	@chmod a+x $(TYPE)/main
	@echo "done making bin"

image:
	@echo "making $(TYPE) docker image"
	@docker build -t local/grpc-$(TYPE) --build-arg TYPE=$(TYPE) .
	@echo "done making image"
