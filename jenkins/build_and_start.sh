#!/bin/bash
echo "Creating /var/lib/jenkins and adding Jenkins user/group if not already added"
user=jenkins
group=jenkins
uid=1000
gid=1000
sudo mkdir -p /var/lib/jenkins
sudo groupadd -g ${gid} ${group} && sudo useradd -d "/var/lib/jenkins" -u ${uid} -g ${gid} -m -s /bin/bash ${user}
sudo chown jenkins:jenkins /var/lib/jenkins

echo "Building oss-argus-jenkins Docker container"
docker build --pull -t oss-argus-jenkins .
echo "Running oss-argus-jenkins"
docker-compose up -d --force-recreate
