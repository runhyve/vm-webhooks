#!/usr/local/bin/bash
set -x
. commons.sh

if [ -v $1 ]; then
  echo "Usage: $0 <image url>" > /dev/stderr
  echo "Example: $0 ftp://ftp.icm.edu.pl/pub/FreeBSD/releases/VM-IMAGES/11.2-RELEASE/amd64/Latest/FreeBSD-11.2-RELEASE-amd64.raw.xz" > /dev/stderr
  exit 2
fi

image="$1"
filename="$(basename "$image" | sed -e "s#.tar.gz##" -e "s#.gz##" -e "s#.xz##")"

export image

if check_img "$filename"; then
  report_error "Image ${filename} already exist."
fi

TID="$(ts "$(pwd)/_img-add.sh")"

if [ -z "$TID" ]; then
  report_error "Something went wrong. Couldn't get task id from Taks Spooler"
else
  report_success "$(jo taskid="$TID")"
fi
