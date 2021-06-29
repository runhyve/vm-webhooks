#!/usr/local/bin/bash
. commons.sh

if [ -x $(which ohai) ]; then
  report_success "$(/usr/bin/env ohai -l fatal | sed 's/%"/"/g')"
else
  report_error "Ohai is not available"
fi
