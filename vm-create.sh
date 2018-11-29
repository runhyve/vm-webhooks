#!/usr/local/bin/bash
. commons.sh

if [ -v $1 ] || [ -v $2 ] || [ -v $3 ] || [ -v $4 ] || [ -v $5 ] || [ -v $6 ] || [ -v $7 ]; then
  echo "Usage: $0 <system> <template> <name> <image> <cpu> <memory> <disk> [network]" > /dev/stderr
  echo "Example: $0 freebsd 1C-1GB-50HDD FreeBSD-VM FreeBSD-11.2-RELEASE-amd64.raw" > /dev/stderr
  exit 2
fi

system="$1"
template="$2"
name="$3"
image="$4"
cpu="$5"
memory="$6"
disk="$7"
network="${8:-public}"

export system template name image cpu memory network disk _template

if ! check_template "$template"; then
  report_error "Coulnd't find template ${template}"
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

TID="$(ts "$(pwd)/_vm-create.sh")"

if [ -z "$TID" ]; then
  report_error "Something went wrong. Couldn't get task id from Taks Spooler"
else
  report_success "$(jo taskid="$TID")"
fi
