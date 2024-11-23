#!/bin/bash
random_value = 1
service_a_ip=""
service_b_ip=""

log_name="c_event.log"

rand_create (){
    random_value=`cat /dev/urandom | LC_CTYPE=C tr -dc '0-9' | fold -w $1 |head -n 1`
}

forward_fortio_create(){
  fortio load -qps $5 -t $1s -c 5 "$2:8080/forwardGet?targetSvc=$3:8080&targetApi=$4"
}

#通过forward调整到其他服务，内存增长
# 接收参数1 服务名，参数2 增长数量
forward_oom (){
  curl "$1:8080/forwardGet?targetSvc=$2:8080&targetApi=oom?count=$3"
}

log_print() {
  echo $1 > log_name
}


while 1>0
do
  rand_create 2
  echo $random_value

  #1
  # b sleep
  if [ "$random_value" = "11"  ];then
     forward_fortio_create 20 $service_a_ip details2 sleepGet?time=5000 50
     log_print random_value
  fi

  #2
    # b-c sleep 3s
  if [ "$random_value" = "22"  ];then
     forward_fortio_create 20 $service_a_ip details2 forwardTo/sleep/3000 50
     log_print random_value
  fi

  #3
  # oom增长,b和c同时增长
  if [ "$random_value" = "33"  ];then
     forward_oom $service_a_ip details2 2 &
     forward_oom $service_b_ip details3 3 &
     sleep 20s
     log_print random_value
  fi

  #4
  #CPU b-c  次数3000
  if [ "$random_value" = "44"  ];then
     forward_fortio_create 20 $service_a_ip details2 forwardTo/createObjectLimitCount/3000 50
     log_print random_value
  fi

  #5  
    #CPU b  次数3000
  if [ "$random_value" = "55"  ];then
     forward_fortio_create 20 $service_a_ip details2 createObjectLimitCount?count=3000 50
     log_print random_value
  fi

  #6
  #net a->b-c ya
  if [ "$random_value" = "66"  ];then
     forward_fortio_create 20 $service_a_ip details2 forwardTo/sleep/200 500
     log_print random_value
  fi

  #7
  #net b-C ya
  if [ "$random_value" = "77"  ];then
     forward_fortio_create 20 $service_b_ip details3 sleep?time=200 500
     log_print random_value
  fi

  #8
  #配置错误
  if [ "$random_value" = "88"  ];then
     #
     echo "error"
  fi

done
