#!/usr/local/bin/bash
set -x
. /opt/runhyve/vm-webhooks/commons.sh

pushd /opt/runhyve/vm-bhyve
./vm create -t "$_template" -i "$image" "$name"

if [ "$network" != "public" ]; then
  sysrc -f "/zroot/vm/${name}/${name}.conf" network0_switch="$network"
fi
popd
return_success
