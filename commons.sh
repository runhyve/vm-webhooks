set -e
PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

report_error(){
  jo status="error" message="${1:-error}"
  exit 2
}

report_success(){
  jo status="success" message="${1:-done}"
  exit 0
}

trap report_error ERR;
