error(){
  echo "{\"status\": \"error\"}"
  exit 2
}

trap error ERR;
