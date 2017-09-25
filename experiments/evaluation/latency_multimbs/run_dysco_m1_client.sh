#!/bin/bash

if [ $# -ne 1 ]; then
    echo "$0 <suffix of result file>"
    exit 1
fi

sudo sh -c 'echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects'
sudo sh -c 'echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects'

ulimit -n 65535

source config.sh

sudo killall -9 dysco_daemon > /dev/null
sudo rmmod dysco > /dev/null

sudo insmod $DYSCO_MODULE
sleep 1
$DYSCO_DAEMON &
sleep 1

sudo route add -host $SERVER1_IP gw $MIDDLE1_IP1

../../user/dysco_ctl policy $CLIENT_IP 2 $MIDDLE1_IP1 $SERVER1_IP tcp dst port $SERVER_PORT

sleep 5

echo "start client..."
../../bin/client $SERVER1_IP $SERVER_PORT 1000 > result/result_m1_dysco_$1.txt
echo "tear down the evaluation..."

#echo -n "Type any key to exit: "
#read ans
#
#sudo route del -host $SERVER1_IP
#sudo killall -9 dysco_daemon
#sleep 1
#sudo rmmod dysco
#echo "done."