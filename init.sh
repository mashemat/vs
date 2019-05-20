#!/bin/bash

if [ $HOSTNAME = "host-eth" ]
   then
     ip addr flush dev eth1
     ethtool -K eth1 tx off rx off ufo off gso off gro off tso off
elif  [ $HOSTNAME = "host-wifi" ]
   then
     ip addr flush dev eth1
     ethtool -K eth1 tx off rx off ufo off gso off gro off tso off
elif  [ $HOSTNAME = "host-isp" ]
   then
     ip addr flush dev eth1
     ethtool -K eth1 tx off rx off ufo off gso off gro off tso off
elif  [ $HOSTNAME = "host-en" ]
   then
     ip addr flush dev eth1
     ip addr flush dev eth2
     ip addr flush dev eth3
     ip addr flush dev eth4
     ip addr flush dev eth5
     ethtool -K eth1 tx off rx off ufo off gso off gro off tso off
     ethtool -K eth2 tx off rx off ufo off gso off gro off tso off
     ethtool -K eth3 tx off rx off ufo off gso off gro off tso off
     ethtool -K eth4 tx off rx off ufo off gso off gro off tso off
     ethtool -K eth5 tx off rx off ufo off gso off gro off tso off
elif  [ $HOSTNAME = "host-enc" ]
   then
     ip addr flush dev eth1
     ethtool -K eth1 tx off rx off ufo off gso off gro off tso off
elif  [ $HOSTNAME = "host-asa" ]
   then
     ip addr flush dev eth1
     ip addr flush dev eth2
     ethtool -K eth1 tx off rx off ufo off gso off gro off tso off
     ethtool -K eth2 tx off rx off ufo off gso off gro off tso off
elif  [ $HOSTNAME = "host-int" ]
   then
     ip addr flush dev eth1
     ip addr flush dev eth2
     ip addr flush dev eth3
     ethtool -K eth1 tx off rx off ufo off gso off gro off tso off
     ethtool -K eth2 tx off rx off ufo off gso off gro off tso off
     ethtool -K eth3 tx off rx off ufo off gso off gro off tso off
elif  [ $HOSTNAME = "host-privc" ]
   then
     ip addr flush dev eth1
     ethtool -K eth1 tx off rx off ufo off gso off gro off tso off
elif  [ $HOSTNAME = "host-pubc" ]
   then
     ip addr flush dev eth1
     ethtool -K eth1 tx off rx off ufo off gso off gro off tso off
fi
/usr/bin/vpp -c /etc/hicn/super_startup.conf &>log.txt &
sleep 20
sysrepod -d -l 0 &
sysrepo-plugind -d -l 0 &
netopeer2-server -d -v 0 &
trap "kill -9 $$" SIGHUP SIGINT SIGTERM SIGCHLD
wait
