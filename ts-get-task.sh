#!/usr/local/bin/bash
. commons.sh

trap error ERR;

if [ -v $1 ] ; then
  echo "Usage: $0 <taskid>" > /dev/stderr
  echo "Example: $0 1337" > /dev/stderr
  exit 2
fi

taskid="$1"

task="$(ts | awk "\$1 == $taskid { print \$0 }")"

if [ -z "$task" ]; then
  report_error "Couldn't get task with id ${taskid}."
fi

t_state="$(echo "$task" | awk '{ print $2 }')"
t_log="$(echo "$task" | awk '{ print $3 }')"
if [ "$t_state" == "finished" ]; then
  t_elevel="$(echo "$task" | awk '{ print $4 }')"
  t_times="$(echo "$task" | awk '{ print $5 }')"
  t_command="$(echo "$task" | awk '{ print $6 }')"
  report_success "$(jo state="$t_state" log="$t_log" elevel="$t_elevel" times="$t_times" command="$t_command")"
else
  report_success "$(jo state="$t_state" log="$t_log")"
fi

