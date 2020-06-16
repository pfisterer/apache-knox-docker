#! /usr/bin/env bash
set -eu

pidfile="$GATEWAY_HOME/pids/gateway.pid"


# Proxy signals
function kill_app(){
    kill $(cat $pidfile)
    exit 0 # exit okay
}
trap "kill_app" SIGINT SIGTERM

# This is needed because ldap.sh and gateway.sh start in the background
xtail ./logs/ &

# Launch daemon
$GATEWAY_HOME/bin/ldap.sh start
$GATEWAY_HOME/bin/gateway.sh start

sleep 5

# Loop while the pidfile and the process exist
while [ -f $pidfile ] && kill -0 $(cat $pidfile) ; do
    sleep 1
done

exit 1