#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 mynetwork" > /dev/stderr
  exit 2
fi

pushd /opt/runhyve/vm-bhyve > /dev/null

name="$1"

if ! check_network "$name"; then
  report_error "Network ${name} doesn't exist"
fi

_CIDR="$(./vm switch list | awk "\$1 == \"$name\" { print \$4 }")"
_INTERFACE="$(./vm switch list | awk "\$1 == \"$name\" { print \$3 }")"
_CONFDIR="${VMROOT}/.config/"
_PFNATDIR="$_CONFDIR/pf-nat/"

mkdir -p "$_PFNATDIR"

echo "nat on igb0 from ${_CIDR} to any -> (igb0)" > "$_PFNATDIR/${_INTERFACE}_pf-nat.conf"

for natfile in $_PFNATDIR/*_pf-nat.conf; do
	cat "$natfile"
done > "$_CONFDIR/pf-nat.conf"

pfctl -f /etc/pf.conf

popd > /dev/null

report_success
