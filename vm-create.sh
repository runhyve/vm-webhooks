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

_template="${system}-${plan}"

export system plan name image network _template

if ! check_template "$_template"; then
  report_error "Coulnd't find template for plan ${_template}"
fi

if ! check_img "$image"; then
  report_error "Couldn't find imge ${image}"
fi

if check_vm "$name"; then
  report_error "Virtual machine ${name} already exist"
fi

if ! check_network "$network"; then
  report_error "Network ${network} doesn't exist"
fi

echo "$(pwd)/_vm-create.sh" | at now > /dev/null 2>&1

report_success
