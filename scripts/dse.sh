#!/bin/sh

echo "Running dse.sh"

password="admin"

echo "Got the parameters:"
echo password $password

#######################################################"
################# Turn Off the Firewall ###############"
#######################################################"
echo "Turning off the Firewall..."
service firewalld stop
chkconfig firewalld off

#######################################################"
###################### Install DSE ####################"
#######################################################"
release="7.1.0"
wget https://github.com/DSPN/install-datastax-ubuntu/archive/$release.tar.gz
tar -xvf $release.tar.gz

cd install-datastax-ubuntu-$release/bin/

# install extra packages, openjdk
./os/extra_packages.sh
./os/install_java.sh -o

opscenterDNS="opscenter.datastax.datastax.oraclevcn.com"
nodeID=$(hostname)
privateDNS=$nodeID + ".datastax.datastax.oraclevcn.com"
publicIP=`curl --retry 10 icanhazip.com`

echo "Using the settings:"
echo opscenterDNS \'$opscenterDNS\'
echo nodeID \'$nodeID\'
echo privateDNS \'$privateDNS\'
echo publicIP \'$publicIP\'

./lcm/addNode.py \
--opsc-ip $opscenterDNS \
--opscpw $password \
--trys 120 \
--pause 10 \
--clustername "mycluster" \
--dcname "dc1" \
--rack "rack1" \
--pubip $publicIP \
--privip $privateDNS \
--nodeid $nodeID