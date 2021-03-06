#!/usr/local/bin/bash
. commons.sh

if [ -z "$1" ]; then
  echo "Usage: $0 <vmname>"
  exit 2
fi

name="$1"

if ! check_vm "$name"; then
  report_error "Virtual machine ${name} doesn't exist"
fi

if [ "$(get_vm_status "$name")" != "Running" ] && [ "$(get_vm_status "$name")" != "Bootloader" ]; then
  report_error "Virtual machine is not running"
fi

port=$((40000 + RANDOM % 1000)) # todo: check if port is free
user="$(pwgen -ns 12 1)"
password="$(pwgen -ns 32 1)"

ttyd -t disableLeaveAlert=true --once -p "$port" --max-clients 1 -c "$user:$password" --check-origin vm console "$name" > /dev/null 2>&1 &

report_success "{\"port\": \"$port\",  \"user\": \"$user\", \"password\": \"$password\"}"
