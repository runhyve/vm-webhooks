#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 mynetwork" > /dev/stderr
  exit 2
fi

name="$1"

./network-disable-dhcp.sh "$name"
./network-disable-nat.sh "$name"
pushd /opt/runhyve/vm-bhyve > /dev/null
./vm switch destroy "$name"
popd > /dev/null

echo "{\"status\": \"delete\"}"
