#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ] || [ -v $2 ] || [ -v $3 ] || [ -v $4 ]; then
  echo "Usage: $0 <system> <plan> <name> <image> [network]" > /dev/stderr
  echo "Example: $0 freebsd 1C-1GB-50HDD FreeBSD-VM FreeBSD-11.2-RELEASE-amd64.raw" > /dev/stderr
  exit 2
fi

system="$1"
plan="$2"
name="$3"
image="$4"
network="${5:-default}"

pushd /opt/runhyve/vm-bhyve > /dev/null
./vm create -t "$system-$plan" -i "$image" "$name" > /dev/null 2>&1 &
if [ "$network" != "default" ]; then
  sysrc -f "/zroot/vm/${name}/${name}.conf" network0_switch="$network"
fi
popd > /dev/null

echo "{\"status\": \"creating\"}"
