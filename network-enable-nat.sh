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
_CONFDIR="/zroot/vm/.config/"
_PFNATDIR="$_CONFDIR/pf-nat/"

mkdir -p "$_PFNATDIR"

echo "nat on igb0 from ${_CIDR} to any -> (igb0)" > "$_PFNATDIR/${_INTERFACE}_pf-nat.conf"

for natfile in $_PFNATDIR/*_pf-nat.conf; do
	cat "$natfile"
done > "$_CONFDIR/pf-nat.conf"

pfctl -f /etc/pf.conf

popd > /dev/null

echo "{\"status\": \"creating\"}"
