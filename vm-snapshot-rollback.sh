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

state="$(get_vm_status "$name")"
if [ "$state" != "Stopped" ]; then
  report_error "Please shutdown ${name} before rollback. This machine is currently in state ${state}."
fi

latest_snapshot="$(zfs list -t snapshot | awk "/zroot\/vm\/${name}\/disk0/ { print \$1 }" | tail -1)"

# TODO:  This always returns false - need to fix
message="$(vm rollback "${name}@${latest_snapshot}" 2>&1)"

if [ $? -ne 0 ]; then
  report_error "$message"
else
  report_success "Virtual machine ${name} rolled back to ${latest_snapshot}."
fi
