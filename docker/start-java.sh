touch /home/java/run.log
nohup java -jar /home/java/demo-0.0.1-SNAPSHOT.jar > /home/java/run.log &

i=1
echo "java successs"
while [ $i -gt 0 ]
do
  sleep 3000
done