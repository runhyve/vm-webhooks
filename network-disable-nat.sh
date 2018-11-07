#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 mynetwork" > /dev/stderr
  exit 2
fi

pushd /opt/runhyve/vm-bhyve > /dev/null

name="$1"
_CONFDIR="${VMROOT}/.config/"
_PFNATDIR="$_CONFDIR/pf-nat/"
_INTERFACE="$(./vm switch list | awk "\$1 == \"$name\" { print \$3 }")"

if ! check_network "$name"; then
  report_error "Network ${name} doesn't exist"
fi

mkdir -p "$_PFNATDIR"

if [ -r "$_PFNATDIR/${_INTERFACE}_pf-nat.conf" ]; then
  rm -f "$_PFNATDIR/${_INTERFACE}_pf-nat.conf"
else
  report_success "Nat was not enabled for network $name"
fi

for natfile in $_PFNATDIR/*_pf-nat.conf; do
  if [ -r "$natfile" ]; then
    cat "$natfile"
  fi
done > "$_CONFDIR/pf-nat.conf"

pfctl -f /etc/pf.conf

popd > /dev/null

report_success
