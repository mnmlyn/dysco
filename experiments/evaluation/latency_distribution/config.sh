DRIVER=nf
DYSCO_DIR=/home/ubuntu/dysco/sigcomm/			# Set the appropriate directory
DYSCO_MODULE=$DYSCO_DIR/kernel/$DRIVER/dysco.ko		# If you are running using one of the drivers, replace dysco.ko with the driver_name.ko
DYSCO_DAEMON=$DYSCO_DIR/user/dysco_daemon

IF1=eno1
IF2=eno2

CLIENT_NET=192.168.3.0/24
SERVER_NET=192.168.4.0/24

MIDDLE_IP1=192.168.3.141
MIDDLE_IP2=192.168.4.141

CLIENT_IP=192.168.3.142
SERVER_IP=192.168.4.143
SERVER_PORT=12345

CLIENT_IP1=192.168.3.142
SERVER_IP1=192.168.4.143
SERVER_PORT1=2000

CLIENT_IP2=192.168.3.144
SERVER_IP2=192.168.4.145
SERVER_PORT2=3000

CLIENT_IP3=192.168.3.146
SERVER_IP3=192.168.4.147
SERVER_PORT3=4000

CLIENT_IP4=192.168.3.148
SERVER_IP4=192.168.4.149
SERVER_PORT4=5000
