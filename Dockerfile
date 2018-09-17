FROM alpine:3.8

ENV GRPC_SERVER_ADDRESS=""
ARG TYPE=client

COPY $TYPE/main /bin/$TYPE

CMD /bin/$TYPE
