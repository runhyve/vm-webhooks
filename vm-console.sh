#!/usr/local/bin/bash
. commons.sh

if [ -v "$1" ]; then
  echo "Usage: $0 <vmname>"
  exit 2
fi

vm="$1"

port=$((1000+$RANDOM%100)) # todo: check if port is free
user="$(pwgen -ns 12 1)"
password="$(pwgen -ns 32 1)"

echo "{\"port\": \"$port\",  \"user\": \"$user\", \"password\": \"$password\"}"

gotty --once -w -a 192.168.0.199 -p "$port" --max-connection 1 -c "$user:$password" --timeout 120  vm console "$vm" > /dev/null 2>&1 &
