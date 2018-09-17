FROM alpine:3.8

ENV GRPC_SERVER_ADDRESS=""
ARG TYPE=client
ENV TYPE=$TYPE

COPY $TYPE/main /bin/$TYPE

CMD echo "/bin/$TYPE" && /bin/$TYPE
