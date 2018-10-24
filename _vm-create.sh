#!/usr/local/bin/bash

. commons.sh

pushd /opt/runhyve/vm-bhyve > /dev/null
./vm create -t "$system-$plan" -i "$image" "$name" > /dev/null 2>&1

if [ "$network" != "public" ]; then
  sysrc -f "/zroot/vm/${name}/${name}.conf" network0_switch="$network"
fi

popd > /dev/null
