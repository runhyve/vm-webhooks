#!/usr/bin/env bash
error(){
  echo "{\"status\": \"error\"}"
}

trap error ERR;

if [ -v $1 ] ; then
  echo "Usage: $0 <name>" > /dev/stderr
  echo "Example: $0 FreeBSD-VM" > /dev/stderr
  exit 2
fi

name="$1"

pushd /home/kwiat/vm-bhyve > /dev/null
status="$(./vm list | awk "\$1 == \"$name\" { print \$8 }")"
popd > /dev/null

echo "{\"status\": \"$status\"}"
