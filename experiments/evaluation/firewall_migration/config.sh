DRIVER=nf
DYSCO_DIR=/home/ubuntu/dysco/sigcomm/			# Set the appropriate directory
DYSCO_MODULE=$DYSCO_DIR/kernel/$DRIVER/dysco.ko		# If you are running using one of the drivers, replace dysco.ko with the driver_name.ko
DYSCO_DAEMON=$DYSCO_DIR/user/dysco_daemon

HOST01=192.168.3.141
HOST02=192.168.3.142
HOST03=192.168.3.143
HOST04=192.168.3.144
HOST05=192.168.3.145
HOST06=192.168.3.146
HOST07=192.168.3.147
HOST08=192.168.3.148
HOST09=192.168.3.149
HOST10=192.168.3.150
HOST01a=192.168.4.141
HOST02a=192.168.4.142
HOST03a=192.168.4.143
HOST04a=192.168.4.144
HOST05a=192.168.4.145
HOST06a=192.168.4.146
HOST07a=192.168.4.147
HOST08a=192.168.4.148
HOST09a=192.168.4.149
HOST10a=192.168.4.150

MIDDLE1=$HOST01
MIDDLE2=$HOST09

CLIENT1=$HOST02
CLIENT2=$HOST03
CLIENT3=$HOST04

SERVER1=$HOST06a
SERVER2=$HOST07a
SERVER3=$HOST08a

ROUTER=$HOST10

ROUTER_IP1=10.0.1.1
ROUTER_IP2=10.0.2.1
ROUTER_IP3=10.0.3.1
ROUTER_IP4=10.0.4.1
ROUTER_IP5=10.0.5.1
ROUTER_IP6=10.0.6.1

CLIENT1_IP=10.0.1.2
CLIENT2_IP=10.0.1.3
CLIENT3_IP=10.0.1.4
CLIENT1_OLD=$HOST02a
CLIENT2_OLD=$HOST03a
CLIENT3_OLD=$HOST04a

SERVER1_IP=10.0.2.2
SERVER2_IP=10.0.2.3
SERVER3_IP=10.0.2.4
SERVER1_OLD=$HOST06
SERVER2_OLD=$HOST07
SERVER3_OLD=$HOST08

MIDDLE1_IP1=10.0.3.2
MIDDLE1_IP2=10.0.4.2
MIDDLE1_OLD1=$HOST01
MIDDLE1_OLD2=$HOST01a

MIDDLE2_IP1=10.0.5.2
MIDDLE2_IP2=10.0.6.2
MIDDLE2_OLD1=$HOST09
MIDDLE2_OLD2=$HOST09a

PORT1=5001
PORT2=5002
PORT3=5003
