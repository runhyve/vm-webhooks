#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ] || [ -v $2 ]; then
  echo "Usage: $0 <machine> <network>" > /dev/stderr
  echo "Example: $0 my-vm internal" > /dev/stderr > /dev/stderr
  exit 2
fi

machine="$1"
network="$2"

export machine network

if ! check_vm "$machine"; then
  report_error "Virtual machine ${machine} doesn't exist"
fi

if ! check_network "$network"; then
  report_error "Network ${network} doesn't exist"
fi

vm add -d network -s "$network" "$machine"

report_success "$machine attached to $network successfuly"
