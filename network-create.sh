#!/usr/local/bin/bash
error(){
  echo "{\"status\": \"error\"}"
}

trap error ERR;


if [ -v $1 ] || [ -v $2 ]; then
  echo "Usage: $0 <name> <cidr>" > /dev/stderr
  echo "Example: $0 mynetwork 192.168.121.0/24" > /dev/stderr
  exit 2
fi

name="$1"
cidr="$2"

pushd /opt/runhyve/vm-bhyve > /dev/null
./vm switch create -a "$cidr" "$name"
popd > /dev/null

echo "{\"status\": \"creating\"}"
