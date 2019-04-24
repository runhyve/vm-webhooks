#!/usr/local/bin/bash
set -x

if [ -z "$image" ]; then
  echo "Variable \$image is required."
  exit 2
fi

. /opt/runhyve/vm-webhooks/commons.sh

vm img "$image"

report_success
