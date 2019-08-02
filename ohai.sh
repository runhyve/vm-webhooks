#!/usr/local/bin/bash
. commons.sh

if [ -x /usr/bin/ohai ]; then
  report_success "$(/usr/bin/ohai -l fatal | sed 's/%"/"/g')"
else
  report_error "Ohai is not available"
fi
