#!/usr/local/bin/bash
set -x

if [ -z "$image" ]; then
  echo "Variable \$image is required."
  exit 2
fi

. /opt/runhyve/vm-webhooks/commons.sh

pushd /opt/runhyve/vm-bhyve
./vm img "$image"

popd
report_success
