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

if [ "$(get_vm_status "$name")" = "Locked" ]; then
  locked_on="$(get_locked_hv "$name")"
  if [ $locked_on != "$(hostname)" ]; then
    report_error "Virtual machine $name appears to be running on other hypervisor: $locked_on"
  fi
fi

message="$(vm start "$name" 2>&1)"

if [ $? -ne 0 ]; then
  report_error "$message"
else
  report_success "$message"
fi
