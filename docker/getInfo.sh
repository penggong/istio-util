#!/bin/bash
PORT=1
#k8s_details1
process_info=$1

get_port(){

  docker_info=`docker ps -a |grep $process_info`
  docker_id=`echo $docker_info |cut -b 1-12`
  docker_pid=`docker inspect -f '{{.State.Pid}}' $docker_id`
  
  javapidInfo=`ps -ef|grep $docker_pid|grep jar`
  PORT=`echo $javapidInfo |cut -b 6-10`
  echo $PORT

}

get_port
getrun(){
 out=`/usr/share/bcc/tools/runqlat -p $PORT 1 1 |grep -F ">" |tail -n 1`
 echo $out >> p-runqlat.txt
}

getmemleak(){
  out=`/usr/share/bcc/tools/memleak -p $PORT -O /lib/x86_64-linux-gnu/libc-2.28.so -T 1 1 1 |grep bytes`
  echo "mem3"
  if [ -z "$out" ];then
     out=0

  fi
  echo $out >> p-memleak.txt
}

while 1>0
do
  get_port
  if [ -n "$PORT" ];then
    status=`top -n 1 -p $PORT |grep root`
    echo $status >> p-status.txt
    getrun
    getmemleak
    #sleep 1
  else
    echo "0" >> p-status.txt
  fi
done 
