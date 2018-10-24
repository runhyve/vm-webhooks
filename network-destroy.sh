#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 mynetwork" > /dev/stderr
  exit 2
fi

name="$1"

if ! check_network "$name"; then
  report_error "Network $name doesn't exist"
fi

./network-disable-dhcp.sh "$name" || true
./network-disable-nat.sh "$name" || true
pushd /opt/runhyve/vm-bhyve > /dev/null
./vm switch destroy "$name"
popd > /dev/null

if ! check_network "$name"; then
  report_success "Network ${name} deleted"
else
  report_error "Netowkr ${name} not deleted"
fi
