#!/bin/sh
HOSTS="5 6 7 8 9 10 11 12 13 14 15 18"
if [ ! -z "$1" ]
  then
    HOSTS=$1
fi
for i in $HOSTS; do
  ssh host${i} "ovs-vsctl del-port br-int tunmonhost${i}"
done
