#!/bin/bash

TIMEOUT=1
TIME=`date "+%Y%m%d_%H%M%S"`

USER=`whoami`
REXEC="expect -re \"(#|\\\\$) $\"; send \""
REXEC_END="expect -re \"(#|\\\\$) $\""

EVALDIR=/home/ubuntu/eval_dysco/dysco_sigcomm17/evaluation/latency_multimbs/

source config.sh

get_git_password()
{
    echo -n "[sudo] git password: "
    stty -echo
    read PW
    stty echo
    echo
}

remote_exec()
{
    expect -c "
              set timeout $TIMEOUT
              spawn ssh $1
              $2
              expect -re \"(#|\\\\$) $\" ;  send \"exit\r\"
              interact
              "
}

update()
{
    remote_exec $1 "
                   $REXEC cd $EVALDIR\n\"
                   $REXEC git pull\n\"
                   expect -re \"Password for*:\" ; send \"$PW\n\"
                   "
}

enable_offload()
{
    remote_exec $1 "
                   $REXEC sudo ethtool -K eno1 tx on tso on gso on\n\"
                   $REXEC sudo ethtool -K eno1 rx on gro on lro on\n\"
                   $REXEC sudo ethtool -K eno2 tx on tso on gso on\n\"
                   $REXEC sudo ethtool -K eno2 rx on gro on lro on\n\"
                   "
}

disable_offload()
{
    remote_exec $1 "
                   $REXEC sudo ethtool -K eno1 tx off tso off gso off\n\"
                   $REXEC sudo ethtool -K eno1 rx off gro off lro off\n\"
                   $REXEC sudo ethtool -K eno2 tx off tso off gso off\n\"
                   $REXEC sudo ethtool -K eno2 rx off gro off lro off\n\"
                   "
}

run_client()
{
#    remote_exec $1 "
#                   $REXEC cd $EVALDIR\n\"
#                   $REXEC ./run_$2_m$3_client.sh $4\n\"
#                   "
    cd $EVALDIR
    ./run_$2_m$3_client.sh $4
}

cleanup_client()
{
#    remote_exec $1 "
#                   $REXEC killall client dysco_module\n\"
#                   $REXEC cd $EVALDIR\n\"
#                   $REXEC ./cleanup_m$2_client.sh\n\"
#                   "
    killall client dysco_module
    cd $EVALDIR
    ./cleanup_m$2_client.sh
}

run_server()
{
    remote_exec $1 "
                   $REXEC cd $EVALDIR\n\"
                   $REXEC ./run_$2_m$3_server.sh\n\"
                   "
}

cleanup_server()
{
    # common for 1-4 mbs
    remote_exec $1 "
                   $REXEC killall server dysco_module\n\"
                   $REXEC cd $EVALDIR\n\"
                   $REXEC ./cleanup_m1_server.sh\n\"
                   "
}

run_mb()
{
    remote_exec $1 "
                   $REXEC cd $EVALDIR\n\"
                   $REXEC ./run_$2_m$3_middlebox$4.sh\n\"
                   "
}

cleanup_mb()
{
    remote_exec $1 "
                   $REXEC killall dysco_module\n\"
                   $REXEC cd $EVALDIR\n\"
                   $REXEC ./cleanup_m$2_middlebox$3.sh\n\"
                   "
}

run() {
    TYPE=$1
    NUM_MBS=$2
    NUM_TEST=$3
    case $NUM_MBS in
        1)
            run_server $HOST3 $1 $NUM_MBS
            run_mb     $HOST2 $1 $NUM_MBS 1

            sleep 5

            run_client $HOST1 $1 $NUM_MBS $3

            cleanup_client $HOST1 $NUM_MBS
            cleanup_mb     $HOST2 $NUM_MBS 1
            cleanup_server $HOST3 $NUM_MBS
            ;;
        2)
            run_mb     $HOST2 $1 $NUM_MBS 1
            run_mb     $HOST3 $1 $NUM_MBS 2
            run_server $HOST4 $1 $NUM_MBS
	    
            sleep 5
	    
            run_client $HOST1 $1 $NUM_MBS $3
	    
    	    cleanup_client $HOST1 $NUM_MBS
            cleanup_server $HOST4 $NUM_MBS
            cleanup_mb     $HOST3 $NUM_MBS 2
            cleanup_mb     $HOST2 $NUM_MBS 1

	    ## for m2
            #run_mb     $HOST3 $1 $NUM_MBS 1
            #run_mb     $HOST4 $1 $NUM_MBS 2
            #run_server $HOST5 $1 $NUM_MBS
	    #
            #sleep 5
	    #
            #run_client $HOST1 $1 $NUM_MBS $3
	    #
    	    #cleanup_client $HOST1 $NUM_MBS
            #cleanup_server $HOST5 $NUM_MBS
            #cleanup_mb     $HOST4 $NUM_MBS 2
            #cleanup_mb     $HOST3 $NUM_MBS 1
            ;;
        3)
            run_mb     $HOST2 $1 $NUM_MBS 1
            run_mb     $HOST3 $1 $NUM_MBS 2
            run_mb     $HOST4 $1 $NUM_MBS 3
            run_server $HOST5 $1 $NUM_MBS

            sleep 5

            run_client $HOST1 $1 $NUM_MBS $3

    	    cleanup_client $HOST1 $NUM_MBS
            cleanup_server $HOST5 $NUM_MBS
            cleanup_mb     $HOST4 $NUM_MBS 3
            cleanup_mb     $HOST3 $NUM_MBS 2
            cleanup_mb     $HOST2 $NUM_MBS 1
            ;;
        4)
            run_mb     $HOST2 $1 $NUM_MBS 1
            run_mb     $HOST3 $1 $NUM_MBS 2
            run_mb     $HOST4 $1 $NUM_MBS 3
            run_mb     $HOST5 $1 $NUM_MBS 4
            run_server $HOST6 $1 $NUM_MBS

            sleep 5

            run_client $HOST1 $1 $NUM_MBS $3

    	    cleanup_client $HOST1 $NUM_MBS
            cleanup_server $HOST6 $NUM_MBS
            cleanup_mb     $HOST5 $NUM_MBS 4
            cleanup_mb     $HOST4 $NUM_MBS 3
            cleanup_mb     $HOST3 $NUM_MBS 2
            cleanup_mb     $HOST2 $NUM_MBS 1
            ;;
    esac
}

############# main #############

# update all test scripts in each host
get_git_password
update $HOST1
update $HOST2
update $HOST3
update $HOST4
update $HOST5
update $HOST6

# change the result directory
enable_offload $HOST1
enable_offload $HOST2
enable_offload $HOST3
enable_offload $HOST4
enable_offload $HOST5
enable_offload $HOST6
#disable_offload $HOST1
#disable_offload $HOST2
#disable_offload $HOST3
#disable_offload $HOST4
#disable_offload $HOST5
#disable_offload $HOST6

# cleanup
cleanup_server $HOST6 4
cleanup_mb     $HOST5 4 4
cleanup_mb     $HOST4 4 3
cleanup_mb     $HOST3 4 2
cleanup_mb     $HOST2 4 1
cleanup_client $HOST1 4
cleanup_server $HOST5 3
cleanup_mb     $HOST4 3 3
cleanup_mb     $HOST3 3 2
cleanup_mb     $HOST2 3 1
cleanup_client $HOST1 3
cleanup_server $HOST4 2
cleanup_mb     $HOST3 2 2
cleanup_mb     $HOST2 2 1
cleanup_client $HOST1 2
cleanup_server $HOST3 1
cleanup_mb     $HOST2 1 1
cleanup_client $HOST1 1

# Customize the test
# $1 : dysco | baseline
# $2 : 1-4, # of mbs
# $3 : 1-3, # of test case

run dysco 1 1
run dysco 1 2
run dysco 1 3
sleep 120
run dysco 2 1
run dysco 2 2
run dysco 2 3
sleep 120
run dysco 3 1
run dysco 3 2
run dysco 3 3
sleep 120
run dysco 4 1
run dysco 4 2
run dysco 4 3
sleep 120

run baseline 1 1
run baseline 1 2
run baseline 1 3
sleep 120
run baseline 2 1
run baseline 2 2
run baseline 2 3
sleep 120
run baseline 3 1
run baseline 3 2
run baseline 3 3
sleep 120
run baseline 4 1
run baseline 4 2
run baseline 4 3
