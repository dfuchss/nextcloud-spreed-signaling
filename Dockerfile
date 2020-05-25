FROM ubuntu:18.04

LABEL maintainer="develop@fuchss.org"
LABEL version="dev"
LABEL description="simple configuration of a docker container with nextcloud-spreed-signaling and internal NATS server"

# Install Build-Tools
RUN apt update && apt install build-essential curl wget git golang python3 -y

# Install NATS
WORKDIR /src
RUN wget https://github.com/nats-io/nats-server/releases/download/v2.1.7/nats-server-v2.1.7-amd64.deb
RUN dpkg -i nats-server-v2.1.7-amd64.deb

# Build nextcloud-spreed-signaling
WORKDIR /src/nextcloud-hpb
COPY . .
RUN make build
EXPOSE 8080

# Use config volume to modify / persist the configuration of the signaling server. Set TURN, Listening etc.
VOLUME /config

RUN chmod +x /src/nextcloud-hpb/entrypoint.sh
ENTRYPOINT ["/src/nextcloud-hpb/entrypoint.sh"]
