#!/bin/sh
HOSTS="5 6 7 8 9 10 11 12 13 14 15 18"
if [ ! -z "$1" ]
  then
    HOSTS=$1
fi
for i in $HOSTS; do
  TUNMONPORT=`neutron port-list --name tunmonport${i} | tail -n +4 | head -n 1`
  ID=`echo $TUNMONPORT | cut -d \  -f 2`
  MAC=`echo $TUNMONPORT | cut -d \  -f 6`

  ssh host${i} "ovs-vsctl -- --may-exist add-port br-int tunmonhost${i} \
  -- set Interface tunmonhost${i} type=internal \
  -- set Interface tunmonhost${i} external-ids:iface-status=active \
  -- set Interface tunmonhost${i} external-ids:attached-mac=${MAC} \
  -- set Interface tunmonhost${i} external-ids:iface-id=${ID} \
  && ip link set dev tunmonhost${i} address ${MAC} \
  && ip addr add 10.0.0.1`printf '%02d\n' $i`/24 dev tunmonhost${i}"
done
