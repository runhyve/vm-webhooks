#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ] || [ -v $2 ]; then
  echo "Usage: $0 <name> <cidr>" > /dev/stderr
  echo "Example: $0 mynetwork 192.168.121.0/24" > /dev/stderr
  exit 2
fi

name="$1"
cidr="$2"

if check_network "$network"; then
  report_error "Network ${network} doesn't exist"
fi

export "$(ipcalc --minaddr "$cidr")"
export "$(ipcalc --prefix "$cidr")"

pushd /opt/runhyve/vm-bhyve > /dev/null
./vm switch create -a "${MINADDR}/${PREFIX}" "$name"
popd > /dev/null

report_success
