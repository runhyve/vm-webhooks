#!/usr/local/bin/bash
. commons.sh

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ]; then
  echo "Usage: $0 <template> <name> <image> <cpu> <memory> <disk> [network] [ipv4-conf] [ssh public key]" > /dev/stderr
  echo "Example: $0 freebsd FreeBSD-VM FreeBSD-11.2-RELEASE-amd64.raw" > /dev/stderr
  exit 2
fi

template="$1"
name="$2"
image="$3"
cpu="$4"
memory="$5"
disk="$6"
network="${7:-public}"
ipv4="${8:-}"
ssh_public_key="${9:-}"

export template name image cpu memory network disk ipv4 ssh_public_key _template

if ! check_template "$template"; then
  report_error "Coulnd't find template ${template}"
fi

if ! check_img "$image"; then
  report_error "Couldn't find image ${image}"
fi

if check_vm "$name"; then
  report_error "Virtual machine ${name} already exist"
fi

if ! check_network "$network"; then
  report_error "Network ${network} doesn't exist"
fi

TID="$(ts "$(pwd)/_vm-create.sh")"

if [ -z "$TID" ]; then
  report_error "Something went wrong. Couldn't get task id from Task Spooler"
else
  report_success "$(jo taskid="$TID")"
fi
