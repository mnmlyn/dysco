#!/bin/bash

ulimit -n 65535

source config.sh

sudo killall -9 dysco_daemon

sleep 1

sudo rmmod dysco

sudo ip route add $SERVER_IP4/32 via $MIDDLE_IP1 dev $IF1

CMD=../../bin/init_connections_client
$CMD $SERVER_IP4 $SERVER_PORT4 $1