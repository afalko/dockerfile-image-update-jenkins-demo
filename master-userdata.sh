#!/bin/bash
yum install docker nginx git docker-compose -y
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
systemctl start docker.service
echo '* * * * * root cd /root/dockerfile-image-update-jenkins-demo && /usr/bin/systemd-cat -t "jenkins-deploy" /bin/bash deploy_me.sh' > /etc/cron.d/jenkins-deploy
git clone git@github.com:afalko/dockerfile-image-update-jenkins-demo.git