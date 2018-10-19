#!/usr/local/bin/bash
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

pushd /opt/runhyve/vm-bhyve > /dev/null
./vm start "$name" > /dev/null 2>&1 &
popd > /dev/null

echo "{\"status\": \"starting\"}"
