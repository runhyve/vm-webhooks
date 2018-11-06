#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 FreeBSD-VM" > /dev/stderr
  exit 2
fi

name="$1"

if ! check_vm "$name"; then
  report_error "Virtual machine ${name} doesn't exist"
fi

state="$(get_vm_status "$name")"
if [ "$state" != "Stopped" ]; then
  report_error "Virtual machine ${name} is in state ${state}. Can't destroy unless it's stopped."
fi

pushd /opt/runhyve/vm-bhyve > /dev/null
./vm destroy -f "$name"
popd > /dev/null

if ! check_vm "$name"; then
  report_success "Virtual machine deleted"
else
  report_error "Virtual machine not deleted"
fi
