#!/usr/local/bin/bash
. commons.sh

ipcalc="/usr/local/bin/ipcalc"

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 mynetwork" > /dev/stderr
  exit 2
fi

pushd /opt/runhyve/vm-bhyve > /dev/null

name="$1"
_CONFDIR="/zroot/vm/.config/"
_DNSMASQDIR="${_CONFDIR}/dnsmasq/"

rm  "${_DNSMASQDIR}/${name}.conf"
service dnsmasq restart

popd > /dev/null

echo "{\"status\": \"deleting\"}"
