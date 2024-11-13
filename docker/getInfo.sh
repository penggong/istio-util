#!/bin/bash
PORT=1
#k8s_details1
process_info=$1

get_port(){

  docker_info=`docker ps -a |grep $process_info |grep Up`
  docker_id=`echo $docker_info |cut -b 1-12`
  docker_pid=`docker inspect -f '{{.State.Pid}}' $docker_id`
  
  javapidInfo=`ps -ef|grep $docker_pid|grep jar`
  PORT=`echo $javapidInfo |cut -b 6-12`
  PORT=`echo $PORT|sed 's/ //g'`
  echo $PORT

}

get_port
getrun(){
 out=`runqlat-bpfcc -p $PORT 1 1 |grep -F ">" |tail -n 1`
 echo $out >> p-runqlat.txt
}

getmemleak(){
  echo "memleak: /proc/$PORT/root/lib/libc.musl-x86_64.so.1"
  out=` memleak-bpfcc -p $PORT -O /proc/$PORT/root/lib/libc.musl-x86_64.so.1 -T 1 2 2 |grep bytes`
  if [ -z "$out" ];then
     out=0

  fi
  echo $out >> p-memleak.txt
}

get_accept(){
  bpftrace -e 't:syscalls:sys_enter_accept* { @[pid,comm] = count();}' > acc.txt&
  sleep 1
  kill -2 $!
  sleep 1
  accept_count=`cat acc.txt|grep $PORT`
  echo $aaa
  if [ -n "$accept_count" ];then
    echo $accept_count >> p-accept.txt
  else
    echo "0" >> p-accept.txt
  fi
}

while 1>0
do
  get_port
  if [ -n "$PORT" ];then
    status=`top -n 1 -p $PORT |grep root`
    echo $status >> p-status.txt
    getrun
    getmemleak
    get_accept
    #sleep 1
  else
    echo "0" >> p-status.txt
    echo "0" >> p-runqlat.txt
    echo "0" >> p-memleak.txt
    echo "0" >> p-accept.txt
    sleep 1
  fi
done 
