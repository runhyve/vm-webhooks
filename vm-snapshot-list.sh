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

snapshots="$(zfs list -t snapshot | grep "zroot/vm/${name}/disk0" |
  while read -r snap; do
    snap_name="$(echo "$snap" | awk '{print $1}')"
    date_created="$(zfs get -H -o value creation "$snap_name")"
    size="$(zfs get -H -o value used "$snap_name")"
    jo name="$snap_name" timestamp="$date_created" size="$size"
  done | jo -a)"

report_success "$snapshots"
