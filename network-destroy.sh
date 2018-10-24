#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 mynetwork" > /dev/stderr
  exit 2
fi

name="$1"

if ! check_network "$network"; then
  report_error "Network $network doesn't exist"
fi

./network-disable-dhcp.sh "$name"
./network-disable-nat.sh "$name"
pushd /opt/runhyve/vm-bhyve > /dev/null
./vm switch destroy "$name"
popd > /dev/null

report_success
