#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 mynetwork" > /dev/stderr
  exit 2
fi

pushd /opt/runhyve/vm-bhyve > /dev/null

name="$1"
_CONFDIR="/zroot/vm/.config/"
_PFNATDIR="$_CONFDIR/pf-nat/"
_INTERFACE="$(./vm switch list | awk "\$1 == \"$name\" { print \$3 }")"

if ! check_network "$name"; then
  report_error "Network ${network} doesn't exist"
fi

mkdir -p "$_PFNATDIR"

rm "$_PFNATDIR/${_INTERFACE}_pf-nat.conf"

for natfile in $_PFNATDIR/*_pf-nat.conf; do
  cat "$natfile" || true
done > "$_CONFDIR/pf-nat.conf"

pfctl -f /etc/pf.conf

popd > /dev/null

report_success
