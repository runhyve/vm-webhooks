#!/usr/local/bin/bash
. commons.sh

trap error ERR;

jo -a $(vm img | grep -v "DATASTORE" | while read line; do
  datastore="$(echo "$line" | awk '{ print $1 }')"
  img="$(echo "$line" | awk '{ print $2 }')"
  jo datastore="$datastore" img="$img"
done)