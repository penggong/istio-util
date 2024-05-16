pid=$1
while :
do
        size=$(cat /proc/$pid/status |grep 'VmSize')
        time=$(date +%Y-%m-%d" "%H:%M:%S)
        echo $time $size >> find.txt
        sleep 3
done