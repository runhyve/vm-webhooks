#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ] || [ -v $2 ] || [ -v $3 ] || [ -v $4 ]; then
  echo "Usage: $0 <system> <plan> <name> <image> [network]" > /dev/stderr
  echo "Example: $0 freebsd 1C-1GB-50HDD FreeBSD-VM FreeBSD-11.2-RELEASE-amd64.raw" > /dev/stderr
  exit 2
fi

system="$1"
plan="$2"
name="$3"
image="$4"
network="${5:-public}"

if [ ! -r "/zroot/vm/.templates/${system}-${plan}.conf" ]; then
  echo "Error: Coulnd't find template for plan ${system}-${plan}"
  exit 2
fi

if [ ! -r "/zroot/vm/.img/${image}" ]; then
  echo "Error: Couldn't find imge ${image}"
  exit 2
fi

pushd /opt/runhyve/vm-bhyve > /dev/null

if [ ! -z "$(./vm list | awk "\$1 = /$name/ { print }")" ]; then
  echo "Error: Virtual machine $name already exist"
  exit
fi

if ! ./vm switch list | cut -f1 | grep "$network"; then
  echo "Error: Network ${network} doesn't exist"
  exit 2
fi

./vm create -t "$system-$plan" -i "$image" "$name" > /dev/null 2>&1 &

if [ "$network" != "public" ]; then
  sysrc -f "/zroot/vm/${name}/${name}.conf" network0_switch="$network"
fi

popd > /dev/null

echo "{\"status\": \"creating\"}"
