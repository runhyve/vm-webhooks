#!/usr/local/bin/bash
set -x
. /opt/runhyve/vm-webhooks/commons.sh

pushd /opt/runhyve/vm-bhyve
./vm create -t "$template" -c "$cpu" -m "$memory" -i "$image" -s "$disk" "$name"

if [ "$?" -ne 0 ]; then
  report_error
fi

if [ "$network" != "public" ]; then
  sysrc -f "/zroot/vm/${name}/${name}.conf" network0_switch="$network"
fi
popd
report_success
