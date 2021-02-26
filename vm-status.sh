#!/usr/local/bin/bash
. commons.sh

trap error ERR

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 FreeBSD-VM" > /dev/stderr
  exit 2
fi

name="$1"

if ! check_vm "$name"; then
  report_error "Virtual machine ${name} doesn't exist"
fi

status="$(get_vm_status "$name")"
if [ $? -ne 0 ]; then
  report_error "Error getting status of vm ${name}."
else
  report_success "$(jo state="$status")"
fi
