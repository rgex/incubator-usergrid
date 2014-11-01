#!/bin/bash

# 
#  Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  The ASF licenses this file to You
#  under the Apache License, Version 2.0 (the "License"); you may not
#  use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.  For additional information regarding
#  copyright in this work, please see the NOTICE file in the top level
#  directory of this distribution.
#




echo "${HOSTNAME}" > /etc/hostname
echo "127.0.0.1 ${HOSTNAME}" >> /etc/hosts
hostname `cat /etc/hostname`

echo "US/Eastern" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# Build environment for scripts
. /etc/profile.d/aws-credentials.sh
. /etc/profile.d/usergrid-env.sh

cd /usr/share/usergrid/init_instance
./create_raid0.sh

# Install the easy stuff
PKGS="ntp unzip groovy curl"
apt-get update
apt-get -y --force-yes install ${PKGS}
/etc/init.d/tomcat7 stop

# Install AWS Java SDK and get it into the Groovy classpath
curl http://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip > /tmp/aws-sdk-java.zip
cd /usr/share/
unzip /tmp/aws-sdk-java.zip 
mkdir -p /home/ubuntu/.groovy/lib
cp /usr/share/aws-java-sdk-*/third-party/*/*.jar /home/ubuntu/.groovy/lib
cp /usr/share/aws-java-sdk-*/lib/* /home/ubuntu/.groovy/lib 
# except for evil stax
rm /home/ubuntu/.groovy/lib/stax*
ln -s /home/ubuntu/.groovy /root/.groovy

# tag last so we can see in the console so that we know what's running
cd /usr/share/usergrid/scripts
groovy tag_instance.groovy -BUILD-IN-PROGRESS

cd /usr/share/usergrid/init_instance
./install_oraclejdk.sh 

# Install and stop Cassandra 
pushd /etc/apt/sources.list.d

curl -L http://debian.datastax.com/debian/repo_key | apt-key add -

sudo cat >> cassandra.sources.list << EOF
deb http://debian.datastax.com/community stable main
EOF

apt-get update
apt-get -y --force-yes install libcap2 cassandra=1.2.19
/etc/init.d/cassandra stop

mkdir -p /mnt/data/cassandra
chown cassandra /mnt/data/cassandra

# Wait for other instances to start up
cd /usr/share/usergrid/scripts
groovy registry_register.groovy opscenter

#TODO make this configurable for the box sizes
#Set or min/max heap to 8GB
sed -i.bak s/calculate_heap_sizes\(\)/MAX_HEAP_SIZE=\"8G\"\\nHEAP_NEWSIZE=\"1200M\"\\n\\ncalculate_heap_sizes\(\)/g /etc/cassandra/cassandra-env.sh

cd /usr/share/usergrid/scripts
groovy configure_opscenter.groovy > /etc/cassandra/cassandra.yaml
/etc/init.d/cassandra start


#Install the opscenter service
# Install opscenter
echo "deb http://debian.datastax.com/community stable main" | sudo tee -a /etc/apt/sources.list.d/datastax.community.list

apt-get update
apt-get  --force-yes -y install opscenter

sudo service opscenterd start

# tag last so we can see in the console that the script ran to completion
cd /usr/share/usergrid/scripts
groovy tag_instance.groovy