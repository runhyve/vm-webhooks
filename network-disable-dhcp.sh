#!/usr/local/bin/bash
. commons.sh

ipcalc="/usr/local/bin/ipcalc"

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 mynetwork" > /dev/stderr
  exit 2
fi

name="$1"
_CONFDIR="${VMROOT}/.config/"
_DNSMASQDIR="${_CONFDIR}/dnsmasq/"

if ! check_network "$name"; then
  report_error "Network ${name} doesn't exist"
fi

if [ -r "${_DNSMASQDIR}/${name}.conf" ]; then
  rm  "${_DNSMASQDIR}/${name}.conf"
  service dnsmasq restart > /dev/null
  report_success
else
  report_success "DHCP is not enabled for this network"
fi

