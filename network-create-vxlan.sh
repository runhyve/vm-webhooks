#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ] ; then
  echo "Usage: $0 <id>" > /dev/stderr
  echo "Example: $0 101" > /dev/stderr
  exit 2
fi

vxlanid="$1"
switchname="vxlan${vxlanid}"

if check_network "$network"; then
  report_error "Network ${network} already exist"
fi

export mcast="$(vni_to_multicast "$vxlanid")"
vm switch create -t vxlan -n "$vxlanid" -i br0 "$switchname" || true

report_success
