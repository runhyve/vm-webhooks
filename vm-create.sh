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

export system plan name image network

if [ ! -r "/zroot/vm/.templates/${system}-${plan}.conf" ]; then
  report_error "Coulnd't find template for plan ${system}-${plan}"
fi

if [ ! -r "/zroot/vm/.img/${image}" ]; then
  report_error "Couldn't find imge ${image}"
fi

pushd /opt/runhyve/vm-bhyve > /dev/null

if [ ! -z "$(./vm list | awk "\$1 = /$name/ { print }")" ]; then
  report_error "Virtual machine $name already exist"
fi

if [ ! -z "$(./vm switch list | awk "\$1 = /$name/ { print }")" ]; then
  report_error "Network ${network} doesn't exist"
fi

popd > /dev/null

bash ./_vm-create.sh &

report_success
