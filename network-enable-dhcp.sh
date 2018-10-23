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
_CIDR="$(./vm switch list | awk "\$1 == \"$name\" { print \$4 }")"
_INTERFACE="$(./vm switch list | awk "\$1 == \"$name\" { print \$3 }")"
export $($ipcalc --minaddr "$_CIDR")
export $($ipcalc --maxaddr "$_CIDR")
_NETRANGE="${MINADDR},${MAXADDR},24h"
_CONFDIR="/zroot/vm/.config/"
_DNSMASQDIR="${_CONFDIR}/dnsmasq/"
_LEASEFILE="${_DNSMASQDIR}/dnsmasq.${_INTERFACE}.leases"

mkdir -p "$_DNSMASQDIR"

cat <<EOF > "${_DNSMASQDIR}/${name}.conf"
interface=${_INTERFACE}
except-interface=lo0
bind-interfaces
domain-needed
dhcp-range=${_NETRANGE}
dhcp-leasefile=${_LEASEFILE}
dhcp-option=6,${MINADDR}
EOF

service dnsmasq restart

popd > /dev/null

echo "{\"status\": \"creating\"}"
