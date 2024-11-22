#!/bin/bash

echo "check begin"

java1_last=`tail -n 1 java1/p-status.txt`
java2_last=`tail -n 1 java2/p-status.txt`
java3_last=`tail -n 1 java3/p-status.txt`
java1=$java1_last
java2=$java2_last
java3=$java3_last

get_status(){
  java1=`tail -n 1 java1/p-status.txt`
  java2=`tail -n 1 java2/p-status.txt`
  java3=`tail -n 1 java3/p-status.txt`
}

stop_all(){
  ps -ef | grep k8s_details1 | grep -v grep | cut -c 9-15 | xargs kill -9
  kill -s 9 `ps -aux | grep k8s_details1 | awk '{print $2}'`cp u-grafana.conf /etc/nginx/conf.d

  ps -ef | grep k8s_details2 | grep -v grep | cut -c 9-15 | xargs kill -9
  kill -s 9 `ps -aux | grep k8s_details1 | awk '{print $2}'`cp u-grafana.conf /etc/nginx/conf.d

  ps -ef | grep k8s_details3 | grep -v grep | cut -c 9-15 | xargs kill -9
  kill -s 9 `ps -aux | grep k8s_details1 | awk '{print $2}'`cp u-grafana.conf /etc/nginx/conf.d
}

start_all(){
  cd /home/ubuntu/istio-util/docker/java1 && nohup sh getInfo-all.sh k8s_details1 &
  cd /home/ubuntu/istio-util/docker/java2 && nohup sh getInfo-all.sh k8s_details2 &
  cd /home/ubuntu/istio-util/docker/java3 && nohup sh getInfo-all.sh k8s_details3 &
  echo "start over"
}

while 1>0
do
    sleep 3
    get_status
    if [ "$java1_last" = "$java1" ];then
        echo "eq"
        stop_all
        start_all
	sleep 10
    else 
        echo "no eq"
    fi
done
