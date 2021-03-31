#!/usr/local/bin/bash
. commons.sh

if [ -z "$1" ]; then
  echo "Usage: $0 <name> <snapshot>" > /dev/stderr
  echo "Example: $0 FreeBSD-VM 2018-11-18-11:08:57" > /dev/stderr
  exit 2
fi

name="$1"
snapname="$2"

if ! check_vm "$name"; then
  report_error "Virtual machine ${name} doesn't exist"
fi

snapshot="$(zfs list -t snapshot | awk "/zroot\/vm\/${name}@${snapname}/ { print \$1 }" | tail -1)"

if [ -z "$snapshot" ]; then
  report_error "Snapshot ${snapshot} not found"
fi

message="$(vm destroy "${name}@${snapname}" 2>&1)"

if [ $? -ne 0 ]; then
  report_error "$message"
else
  report_success "$message"
fi
