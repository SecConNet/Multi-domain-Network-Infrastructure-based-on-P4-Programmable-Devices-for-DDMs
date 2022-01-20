#!/bin/bash
echo "phellome"
#echo "phellome"
#sleep 5
sudo python ../rabbitmq/send.py 12 &
t_start="$(date  "+%s%3N")"
echo "$t_start" > "recordtime.txt"
echo "$t_start" > "/home/sshakeri/rabbitmq/pt4.txt"
#sudo python ../rabbitmq/send.py 12 &
bash /home/sshakeri/p4project/automation.sh 
#sleep 5
t_end="$(date  "+%s%3N")"
t_total=$(($t_end-$t_start))
t_total_mili=$(bc<<<"scale=3;$t_total/1000")
echo "$t_total_mili" > "sequentialtime.txt"
