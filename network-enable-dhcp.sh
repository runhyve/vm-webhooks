#!/usr/local/bin/bash
error(){
  echo "{\"status\": \"error\"}"
}

trap error ERR;


if [ -v $1 ] || [ -v $2 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 mynetwork" > /dev/stderr
  exit 2
fi

pushd /opt/runhyve/vm-bhyve > /dev/null

name="$1"
_CIDR="$(./vm switch list | awk "\$1 == \"$name\" { print \$4 }")"
_INTERFACE="$(./vm switch list | awk "\$1 == \"$name\" { print \$3 }")"
hostmin="$(ipcalc -nb "$_CIDR" | awk '$1 == "HostMin" { print $2 }')"
hostmax="$(ipcalc -nb "$_CIDR" | awk '$1 == "HostMax" { print $2 }')"
_NETRANGE="${hostmin},${hostmax},24h"
_CONFDIR="/zroot/vm/.config/"
_DNSMASQDIR="${_CONFDIR}/dnsmasq/"
_LEASEFILE="${_DNSMASQDIR}/dnsmasq.${_INTERFACE}.leases"


cat <<EOF >> "${_DNSMASQDIR}/${name}.conf"
interface=${_INTERFACE}
except-interface=lo0
bind-interfaces
domain-needed
dhcp-range=${_NET_RANGE}
dhcp-leasefile=${_LEASEFILE}
dhcp-option=6,10.0.${TEAMID}.1
EOF 

service dnsmasq restart

popd > /dev/null

echo "{\"status\": \"creating\"}"
