#!/usr/local/bin/bash
. commons.sh

trap error ERR

jo -a $(ts | grep -v "E-Level" | while read task; do
  t_id="$(echo "$task" | awk '{ print $1 }')"
  t_state="$(echo "$task" | awk '{ print $2 }')"
  t_log="$(echo "$task" | awk '{ print $3 }')"
  if [ "$t_state" == "finished" ]; then
    t_elevel="$(echo "$task" | awk '{ print $4 }')"
    t_times="$(echo "$task" | awk '{ print $5 }')"
    t_command="$(echo "$task" | awk '{ print $6 }')"
    jo id="$t_id" state="$t_state" log="$t_log" elevel="$t_elevel" times="$t_times" command="$t_command"
  else
    jo id="$t_id" state="$t_state" log="$t_log" elevel="" times="" command==""
  fi
done)
