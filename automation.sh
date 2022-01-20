#!/bin/bash
#creating containers
t_container_start=$(date  "+%s%3N")
sudo docker run -it -d --net=none --privileged --name p4test200 sarashakeri/ubuntu-iperf:v1.6
t_container_end=$(date "+%s%3N")
#setup interfaces
t_interfacesetup_start=$(date "+%s%3N")
P4container1=$(sudo docker inspect --format '{{ .State.Pid }}' p4test200)
sudo ip link add veth200 type veth peer name veth201
sudo ip link set veth200 netns ${P4container1} 
sudo ifconfig veth201 192.168.201.1 netmask 255.255.255.0 up
sudo docker exec p4test200 ifconfig veth200 192.168.201.2 netmask 255.255.255.0 up
sudo docker exec p4test200  route add default gw 192.168.201.1
echo "port_add veth201 201" > "addport.txt"
simple_switch_CLI < "addport.txt"
t_interfacesetup_end=$(date "+%s%3N")
#take container information
#pid=$(sudo docker inspect --format '{{ .State.Pid }}' p4test7)
#sudo  mkdir  -p /var/run/netns/
#sudo ln -sfT /proc/${pid}/ns/net /var/run/netns/p4test7
#echo sudo ip netns exec p4test7 ifconfig veth14 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'
t_addrules_start=$(date "+%s%3N")
echo "table_add ipv4_match send_to_nat 192.168.200.0/24 => 56:ab:44:0e:b8:d9 8a:cb:8b:e4:61:e2 192.168.43.2 192.168.42.2 2" > "addrules.txt"
echo "table_add ipv4_match send_to_nat 192.168.220.0/24 =>  8a:cb:8b:e4:61:e2 56:ab:44:0e:b8:d9 192.168.42.2 192.168.43.2 1" >> "addrules.txt"
#echo "port_add veth15 15" > "addport.txt"
#simple_switch_CLI < "addport.txt"
#sudo simple_switch -i 1@enp3s0f0 -i  2@veth15 tcp-test6.json 
#adding new rules
#t_addrules_start=$(date "+%s%3N")
simple_switch_CLI < addrules.txt
t_addrules_end=$(date "+%s%3N")
echo $t_addrules_end > "t10.txt"
t_container=$(($t_container_end-$t_container_start))
t_container_mili=$(bc<<<"scale=3;$t_container/1000")
t_interfacesetup=$(($t_interfacesetup_end-$t_interfacesetup_start))
t_interfacesetup_mili=$(bc<<<"scale=3;$t_interfacesetup/1000")
t_addrules=$(($t_addrules_end-$t_addrules_start))
t_addrules_mili=$(bc<<<"scale=3;$t_addrules/1000")
t_total=$(($t_addrules_end-$t_container_start))
t_total_mili=$(bc<<<"scale=3;$t_total/1000")
echo "$t_container_mili" > "/home/sshakeri/rabbitmq/container.txt"
echo "$t_interfacesetup_mili" > "/home/sshakeri/rabbitmq/interface.txt"
echo "$t_addrules_mili" > "/home/sshakeri/rabbitmq/addrule.txt"
echo "$t_total_mili" > "/home/sshakeri/rabbitmq/totalautomation.txt"
echo "$t_total_mili"
#sudo python ../rabbitmq/send.py
