#!/bin/bash
#sudo docker stop p4test200
#sudo docker rm p4test200
sudo docker stop $(sudo docker ps -aq)
sudo docker rm $(sudo docker ps -aq)
sudo simple_switch -i 200@enp3s0f0 tcp-test6.json
