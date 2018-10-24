#!/usr/local/bin/bash
. commons.sh

trap error ERR;

if [ -v $1 ] ; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 FreeBSD-VM" > /dev/stderr
  exit 2
fi

name="$1"

if ! check_vm "$name"; then
  report_error "Virtual machine ${name} doesn't exist"
fi

pushd /opt/runhyve/vm-bhyve > /dev/null
status="$(./vm list | awk "\$1 == \"$name\" { print \$8 }")"

if [ $? -ne 0 ]; then
  report_error "$status"
else
  report_success "$(jo state="$status")"
fi

popd > /dev/null
