PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

report_error(){
  jo status="error" message="${1:-"Unknown error"}"
  exit 2
}

report_success(){
  jo status="success" message="${1:-"Success"}"
  exit 0
}

trap report_error ERR;

check_template(){
  plan="$1"
  if [ -r "/zroot/vm/.templates/$plan.conf" ]; then
    errno=0
  else
    errno=1
  fi
  return $errno
}

check_img(){
  pushd /opt/runhyve/vm-bhyve > /dev/null
  img="$1"
  if [ ! -z "$(./vm img | awk "\$1 == \"$img\" { print }")" ]; then
    errno=0
  else
    errno=1
  fi
  popd > /dev/null
  return $errno
}
check_vm(){
  pushd /opt/runhyve/vm-bhyve > /dev/null
  vm="$1"  
  if [ ! -z "$(./vm list | awk "\$1 == \"$vm\" { print }")" ]; then
    errno=0
  else
    errno=1
  fi
  popd > /dev/null
  return $errno
}

check_network(){
  pushd /opt/runhyve/vm-bhyve > /dev/null
  network="$1"  
  if [ ! -z "$(./vm switch list | awk "\$1 == \"$network\" { print }")" ]; then
    errno=0
  else
    errno=1
  fi
  popd > /dev/null
  return $errno
}
