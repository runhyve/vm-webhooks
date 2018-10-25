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
_CONFDIR="${VMROOT}/.config/"
_DNSMASQDIR="${_CONFDIR}/dnsmasq/"

if ! check_network "$name"; then
  report_error "Network ${name} doesn't exist"
fi

rm  "${_DNSMASQDIR}/${name}.conf"
service dnsmasq restart

popd > /dev/null

report_success
