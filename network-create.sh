#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ] || [ -v $2 ]; then
  echo "Usage: $0 <name> <cidr>" > /dev/stderr
  echo "Example: $0 mynetwork 192.168.121.0/24" > /dev/stderr
  exit 2
fi

name="$1"
cidr="$2"

if check_network "$network"; then
  report_error "Network ${network} doesn't exist"
fi

export "$(ipcalc --minaddr "$cidr")"
export "$(ipcalc --prefix "$cidr")"

pushd /opt/runhyve/vm-bhyve > /dev/null
./vm switch create -a "${MINADDR}/${PREFIX}" "$name"

_CONFDIR="${VMROOT}/.config/"
_PFDIR="$_CONFDIR/pf-security/"
_INTERFACE="$(./vm switch list | awk "\$1 == \"$name\" { print \$3 }")"
popd > /dev/null

mkdir -p "$_PFDIR"

cat <<-EOF > "$_PFDIR/${_INTERFACE}_pf-security.conf"
block in on "$_INTERFACE"
pass out on "$_INTERFACE" inet from $cidr to any keep state
EOF

for pffile in $_PFDIR/*_pf-security.conf; do
  cat "$pffile"
done > "$_CONFDIR/pf-security.conf"

pfctl -f /etc/pf.conf

report_success
