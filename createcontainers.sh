#!/bin/bash
create(){
numbers="$1"
echo "numbers is $numbers"
iteration=1
arg=1
sleep 1
while [ $iteration -lt $numbers ]; do
 echo "arg is $arg"
 bash /home/sshakeri/p4project/loadautomation.sh "$arg" &
 count=$(($iteration))
 iteration=$(($iteration+1))
 arg=$(($iteration+$count))
done
}
if [[ $# -lt "1" ]]; then
echo "Usage: $0 <number of contianers>"
  exit 1
else
  create "$1"
fi

