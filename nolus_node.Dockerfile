FROM alpine:3.14
ARG ARTIFACT_BIN="nolus.tar.gz"
ARG CUSTOM_MONIKER=docker_generated_node
ARG NETWORK
ARG VERSION

RUN wget -O $ARTIFACT_BIN "https://github.com/Nolus-Protocol/nolus-core/releases/download/$VERSION/nolus.tar.gz" \
&& tar -xvf $ARTIFACT_BIN --directory /usr/bin/

RUN apk add --no-cache bash
RUN echo $NETWORK
RUN wget -O genesis.json "https://raw.githubusercontent.com/Nolus-Protocol/nolus-networks/main/$NETWORK/genesis.json"
RUN wget -O persistent_peers.txt "https://raw.githubusercontent.com/Nolus-Protocol/nolus-networks/main/$NETWORK/persistent_peers.txt"

COPY docker-node.sh docker-node.sh
RUN chmod +x docker-node.sh

# tendermint p2p
EXPOSE 26656

ENTRYPOINT /docker-node.sh ; nolusd start