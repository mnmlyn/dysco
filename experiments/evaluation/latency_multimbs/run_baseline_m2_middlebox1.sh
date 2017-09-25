#!/bin/bash

ulimit -n 65535

source config.sh

sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
sudo sh -c 'echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects'
sudo sh -c 'echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects'

sudo rmmod dysco > /dev/null
sleep 1

sudo route add -host $SERVER2_IP gw $MIDDLE2_IP1

#echo -n "Type any key to exit: "
#read ans
#
#sudo route del -host $SERVER2_IP
#
#sudo sh -c 'echo 0 > /proc/sys/net/ipv4/ip_forward'
#sudo sh -c 'echo 1 > /proc/sys/net/ipv4/conf/all/send_redirects'
#sudo sh -c 'echo 1 > /proc/sys/net/ipv4/conf/all/accept_redirects'