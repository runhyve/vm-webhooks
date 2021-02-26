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
  report_error "Please shutdown ${name} before creating a snapshot. This machine is currently in state ${state}."
fi

message="$(vm snapshot "$name" 2>&1)"

if [ $? -ne 0 ]; then
  report_error "$message"
else
  report_success "$message"
fi
