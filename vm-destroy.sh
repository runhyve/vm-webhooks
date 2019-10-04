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

TID="$(ts vm destroy -f "$name")"

if [ -z "$TID" ]; then
  report_error "Something went wrong. Couldn't get task id from Task Spooler"
else
  report_success "$(jo taskid="$TID")"
fi
