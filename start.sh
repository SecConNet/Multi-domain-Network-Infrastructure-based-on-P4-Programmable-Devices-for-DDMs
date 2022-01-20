#!/bin/bash
start_time="$(date -d "$(date -u)" "+%s%3N")"
sudo python receive.py 
#bash ../p4project/automation.sh
end_time="$(date -d "$(date -u)" "+%s%3N")"
duration=$(($end_time-$start_time))
print $duration
