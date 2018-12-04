PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
VMROOT="$(zfs get -H -o value mountpoint $(sysrc vm_dir | awk -F: '{print $3}'))"
export PATH VMROOT

start_taskspooler(){
  pid="$(pgrep ts)"
  if [ $? -ne 0 ]; then
    ts > /dev/null
  fi
}

start_taskspooler

catch_error(){
  jo status="error" message="Unknown error occured"
  exit 2
}

report_error(){
  jo status="error" message="${1:-"Unknown error"}"
  exit 0
}

report_success(){
  jo status="success" message="${1:-"Success"}"
  exit 0
}

trap catch_error ERR;

if [ "$(id -u)" != "0" ]; then
  report_error "Scripts requires root permissions"
fi

check_template(){
  plan="$1"
  if [ -r "${VMROOT}/.templates/$plan.conf" ]; then
    errno=0
  else
    errno=1
  fi
  return $errno
}

check_img(){
  pushd /opt/runhyve/vm-bhyve > /dev/null
  img="$1"
  if [ ! -z "$(./vm img | awk "\$2 == \"$img\" { print }")" ]; then
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

get_vm_status(){
  name="$1"
  if ! check_vm "$name"; then
    report_error "Virtual machine ${name} doesn't exist"
  fi
  pushd /opt/runhyve/vm-bhyve > /dev/null
  status="$(./vm list | awk "\$1 == \"$name\" { print \$8 }")"
  popd > /dev/null
  echo "$status"
}

vni_to_multicast(){
  # vxlan supports up to 16777215 but we had to reduce this number
  # because of FreeBSD limitation to 32749
  max_vni=32749
  if [ $1 -gt $max_vni ]; then
    report_error "VNI too large. Max is ${max_vni}".
  fi

  hex=`printf "%06x" ${1}`
  printf "239"
  for pos in 1-2 3-4 5-6; do
    printf ".%d" "0x`echo "${hex}" | cut -c ${pos}`"
  done
  printf "\n"
}
