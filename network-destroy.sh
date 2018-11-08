#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ]; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 mynetwork" > /dev/stderr
  exit 2
fi

name="$1"

if ! check_network "$name"; then
  report_error "Network $name doesn't exist"
fi

./network-disable-dhcp.sh "$name" > /dev/null || true
./network-disable-nat.sh "$name" > /dev/null || true
pushd /opt/runhyve/vm-bhyve > /dev/null
_CONFDIR="${VMROOT}/.config/"
_PFDIR="$_CONFDIR/pf-security/"
_INTERFACE="$(./vm switch list | awk "\$1 == \"$name\" { print \$3 }")"
rm -f "$_PFDIR/${_INTERFACE}_pf-security.conf"

for pffile in $_PFDIR/*_pf-security.conf; do
  if [ -r "$pffile" ]; then
    cat "$pffile"
  fi
done > "$_CONFDIR/pf-security.conf"

pfctl -f /etc/pf.conf

./vm switch destroy "$name" || true # vm incorrectly returns 1
popd > /dev/null

if ! check_network "$name"; then
  report_success "Network ${name} deleted"
else
  report_error "Netowkr ${name} not deleted"
fi
