#!/bin/sh
NETWORK_ID=`neutron net-list --name tun-mon | tail -n +4 | head -n 1 | cut -d \  -f 2`
for i in 5 6 7 8 9 10 11 12 13 14 15 18; do
    neutron port-create --name tunmonport${i} --binding:host_id=host${i} $NETWORK_ID
done
