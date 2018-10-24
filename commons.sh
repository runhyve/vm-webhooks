error(){
  echo "{\"status\": \"error\"}"
  exit 2
}

trap error ERR;

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
