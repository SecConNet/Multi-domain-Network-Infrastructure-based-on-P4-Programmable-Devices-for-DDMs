#!/bin/bash
load(){
iteration="$1"
echo "iteration is $iteration"
#creating containers
t_container_start="$(date -d "$(date -u)" "+%s%3N")"
sudo docker run -it -d --net=none --privileged --name p4test$iteration sarashakeri/ubuntu-iperf:v1.6
t_container_end="$(date -d "$(date -u)" "+%s%3N")"
#setup interfaces
#t_interfacesetup_start="$(date -d "$(date -u)" "+%s%3N")"
P4container1=$(sudo docker inspect --format '{{ .State.Pid }}' p4test$iteration)
iteration1=$(($iteration+1))
sudo ip link add "veth$iteration" type veth peer name "veth$iteration1"
sudo ip link set "veth$iteration" netns ${P4container1} 
sudo ifconfig "veth$iteration1" 192.168."$iteration".1 netmask 255.255.255.0 up
sudo docker exec "p4test$iteration" ifconfig "veth$iteration" 192.168."$iteration".2 netmask 255.255.255.0 up
sudo docker exec "p4test$iteration"  route add default gw 192.168."$iteration".1
#t_interfacesetup_end="$(date -d "$(date -u)" "+%s%3N")"
#take container information
pid=$(sudo docker inspect --format '{{ .State.Pid }}' p4test$iteration)
sudo  mkdir  -p /var/run/netns/
sudo ln -sfT /proc/${pid}/ns/net /var/run/netns/p4test$iteration
echo sudo ip netns exec p4test$iteration ifconfig veth$iteration | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'
echo "table_add ipv4_match send_to_nat 192.168.$iteration1.0/24 => 56:ab:44:0e:b8:d9 8a:cb:8b:e4:61:e2 192.168.43.2 192.168.42.2 2" > "addrules$iteration.txt"
echo "table_add ipv4_match send_to_nat 192.167.$iteration1.0/24 =>  8a:cb:8b:e4:61:e2 56:ab:44:0e:b8:d9 192.168.42.2 192.168.43.2 1" >> "addrules$iteration.txt"
echo "port_add veth$iteration1 $iteration" > "addport$iteration.txt"
#simple_switch_CLI < "addport$iteration.txt"
#sudo simple_switch -i 1@enp3s0f0 -i  2@veth15 tcp-test6.json 
#adding new rules
#t_addrules_start="$(date -d "$(date -u)" "+%s%3N")"
#simple_switch_CLI < addrules"$iteration".txt
#t_addrules_end="$(date -d "$(date -u)" "+%s%3N")"
t_container=$(($t_container_end-$t_container_start))
t_container_mili=$(bc<<<"scale=3;$t_container/1000")
#t_interfacesetup=$(($t_interfacesetup_end-$t_interfacesetup_start))
#t_interfacesetup_mili=$(bc<<<"scale=3;$t_interfacesetup/1000")
#t_addrules=$(($t_addrules_end-$t_addrules_start))
#t_addrules_mili=$(bc<<<"scale=3;$addrules/1000")
#t_total=$(($t_addrules_end-$t_container_start))
#t_total_mili=$(bc<<<"scale=3;$t_total/1000")
#echo "$t_container" > "/home/sshakeri/p4project/container.txt"
#echo "$t_interfacesetup" > "/home/sshakeri/p4project/interface.txt"
#echo "$t_addrule" > "/home/sshakeri/p4project/addrule.txt"
#echo "$t_total" > "/home/sshakeri/rabbitmq/parallelduration.txt"
#echo "$t_total"
#sudo python ../rabbitmq/send.py
}
if [[ $# -lt "1" ]]; then
echo "Usage: $0 <containernumber>"
  exit 1
else
  load "$1"
fi
