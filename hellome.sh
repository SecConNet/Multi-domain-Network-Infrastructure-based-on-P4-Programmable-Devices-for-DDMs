#!/bin/bash
echo "hellome"
#echo "hellome"
#sleep 5
t_start=$(date  "+%s%3N")
echo "$t_start" > "recordtime.txt"
echo "$t_start" > "/home/sshakeri/rabbitmq/t4.txt"
bash /home/sshakeri/p4project/automation.sh
#sleep 5
t_end=$(date "+%s%3N")
t_total=$(($t_end-$t_start))
mili=$(bc<<<"scale=3;$t_total/1000")
echo $mili > "/home/sshakeri/rabbitmq/sequentialtime.txt"
#t_10=$(date "+%s%3N")
echo $t_end > "/home/sshakeri/rabbitmq/t10.txt"
sudo python ../rabbitmq/send.py 12
