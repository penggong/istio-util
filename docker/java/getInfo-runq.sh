#!/bin/bash
PORT=1
#k8s_details1
process_info=$1


get_port(){

  docker_info=`docker ps -a |grep $process_info |grep Up`
  docker_id=`echo $docker_info |cut -b 1-12`
  docker_pid=`docker inspect -f '{{.State.Pid}}' $docker_id`
  
  javapidInfo=`ps -ef|grep $docker_pid|grep jar`
  PORT=`echo $javapidInfo |cut -b 6-11`
  PORT=`echo $PORT|sed 's/ //g'`
  echo $PORT

}

getrun(){
  time=$(date "+%Y-%m-%d %H:%M:%S")
 out=`runqlat-bpfcc -p $PORT 1 1 |grep -F ">" |tail -n 1`
 echo $time $out >> p-runqlat.txt
}

getmemleak(){
  echo "memleak: /proc/$PORT/root/lib/libc.musl-x86_64.so.1"
  out=` memleak-bpfcc -p $PORT -O /proc/$PORT/root/lib/libc.musl-x86_64.so.1 -T 1 2 2 |grep bytes`
  if [ -z "$out" ];then
     out=0

  fi
  time=$(date "+%Y-%m-%d %H:%M:%S")
  echo $time $out >> p-memleak.txt
}

get_accept(){
  bpftrace -e 't:syscalls:sys_enter_accept* { @[pid,comm] = count();}' > acc.txt&
  sleep 1
  kill -2 $!
  sleep 1
  accept_count=`cat acc.txt|grep $PORT`
  echo $aaa
  time=$(date "+%Y-%m-%d %H:%M:%S")
  if [ -n "$accept_count" ];then
    echo $time $accept_count >> p-accept.txt
  else
    echo "0" >> p-accept.txt
  fi
}

get_connect(){
  bpftrace -e 't:syscalls:sys_enter_connect* { @[pid,comm] = count();}' > connect.txt&
  sleep 1
  kill -2 $!
  sleep 1
  connect_count=`cat acc.txt|grep $PORT`
  echo $aaa
  time=$(date "+%Y-%m-%d %H:%M:%S")
  if [ -n "$connect_count" ];then
    echo $time $connect_count >> p-connect.txt
  else
    echo "0" >> p-connect.txt
  fi
}

get_status(){
  status=`top -b -n 1 -p $PORT |grep root`
  time=$(date "+%Y-%m-%d %H:%M:%S")
  echo $time $status >> p-status.txt 
}

while 1>0
do
  time=$(date "+%Y-%m-%d %H:%M:%S")
  echo "begin time :"$time
  get_port
  if [ -n "$PORT" ];then
    
    getrun
    
  else
    echo "0" >> p-runqlat.txt
    sleep 1
  fi
done 
