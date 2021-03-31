#!/usr/local/bin/bash
. commons.sh

if [ -z "$1" ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 FreeBSD-VM" > /dev/stderr
  exit 2
fi

name="$1"

if ! check_vm "$name"; then
  report_error "Virtual machine ${name} doesn't exist"
fi

if [ "$(get_vm_status "$name")" != "Running" ] && [ "$(get_vm_status "$name")" != "Bootloader" ]; then
  report_error "Virtual machine ${name} is not running"
fi

message="$(vm restart "$name" 2>&1)"

if [ $? -ne 0 ]; then
  report_error "$message"
else
  report_success "$message"
fi
