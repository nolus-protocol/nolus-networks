#!/bin/bash
NETWORK="testnet/nolus-rila"

__print_usage() {
    printf \
    "Usage:
    [--network <network_name>]"
}


while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in

  -h | --help)
    __print_usage "$0"
    exit 0
    ;;

  -c | --network)
    NETWORK="$2"
    shift
    shift
    ;;

  *)
    echo "unknown option '$key'"
    exit 1
    ;;

  esac
done

VERSION=$(cat version.md)
IMAGE_NAME="nolus-image-$VERSION"

docker build \
  --build-arg NETWORK="$NETWORK" \
  --build-arg VERSION="$VERSION" \
  -f nolus_node.Dockerfile \
  -t "$IMAGE_NAME" .

docker run -d -it \
  --name "nolus-node-$VERSION" \
  -v nolusDataVol:/.nolus/data \
  "$IMAGE_NAME"