#!/bin/bash
PORT=1

get_port(){
  docker_id=`docker ps -a |grep k8s_details1`
  PORT=`echo $docker_id |cut -b 1-12`
  PORT=`docker inspect -f '{{.State.Pid}}' $PORT`
}
get_port1(){

  port_info=`ps -ef|grep demo|grep -v grep`
  var=$port_info
  PORT=`echo $var |cut -b 6-11`
  echo $PORT


}
get_port
getrun(){
 out=`/usr/share/bcc/tools/runqlat -p $PORT 1 1 |grep -F ">" |tail -n 1`
 echo $out >> p-runqlat.txt
}

getmemleak(){
  out=`/usr/share/bcc/tools/memleak -p $PORT -T 1 1 1 |grep bytes`
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
