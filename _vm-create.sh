#!/usr/local/bin/bash
set -x
. /opt/runhyve/vm-webhooks/commons.sh

sshpk="/tmp/.sshpk.$$"

OPTS=" -t $template -c $cpu -m $memory -i $image -s $disk -C "

if [ ! -z "$ssh_public_key" ]; then
  echo "$ssh_public_key" > "$sshpk"
  OPTS+=" -k $sshpk "
fi

vm create $OPTS "$name"
rm -f "$sshpk"

if [ "$?" -ne 0 ]; then
  report_error
fi

if [ "$network" != "public" ]; then
  sysrc -f "/zroot/vm/${name}/${name}.conf" network0_switch="$network"
fi
report_success
