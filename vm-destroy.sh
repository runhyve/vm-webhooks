#!/usr/local/bin/bash
set -x
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

if get_vm_status "$name" == "Running"; then
  report_error "${name} is in state running. Can't destroy."
fi

pushd /opt/runhyve/vm-bhyve > /dev/null
./vm destroy -f "$name" || true # wrkaround for vm returning always false
popd > /dev/null

if ! check_vm "$name"; then
  report_success "Virtual machine deleted"
else
  report_error "Virtual machine not deleted"
fi
