#!/bin/bash
PORT=1
#k8s_details1
process_info=$1

nohup sh getInfo-status.sh $1 > out-status.log 2>&1 &
nohup sh getInfo-runq.sh $1 &
nohup sh getInfo-mem.sh $1 &
nohup sh getInfo-accept.sh $1 &
nohup sh getInfo-connect.sh $1 &
echo "start ok"
