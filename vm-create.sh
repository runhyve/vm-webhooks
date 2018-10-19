#!/usr/local/bin/bash
error(){
  echo "{\"status\": \"error\"}"
}

trap error ERR;


if [ -v $1 ] || [ -v $2 ] || [ -v $3 ] || [ -v $4 ]; then
  echo "Usage: $0 <system> <plan> <name> <image>" > /dev/stderr
  echo "Example: $0 freebsd 1C-1GB-50HDD FreeBSD-VM FreeBSD-11.2-RELEASE-amd64.raw" > /dev/stderr
  exit 2
fi

system="$1"
plan="$2"
name="$3"
image="$4"

pushd /opt/runhyve/vm-bhyve > /dev/null
./vm create -t "$system-$plan" -i "$image" "$name" > /dev/null 2>&1 &
popd > /dev/null

echo "{\"status\": \"creating\"}"