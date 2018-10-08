#!/bin/bash
yum install docker git docker-compose httpd -y
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
systemctl enable docker.service
systemctl start docker.service
echo '* * * * * root cd /root/dockerfile-image-update-jenkins-demo && /usr/bin/systemd-cat -t "jenkins-deploy" /bin/bash deploy_me.sh' > /etc/cron.d/jenkins-deploy


git clone git@github.com:afalko/dockerfile-image-update-jenkins-demo.git

wget -r --no-parent -A 'epel-release-*.rpm' http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/
rpm -Uvh dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-*.rpm
yum-config-manager --enable epel*
yum install -y certbot python2-certbot-apache

echo 'ServerName jenkins.afalko.net:80
<VirtualHost *:80>
    DocumentRoot "/var/www/html"
    ServerName "jenkins.afalko.net"
</VirtualHost>' >> /etc/httpd/conf/httpd.conf
# Clear out default self-signed ssl
mv /etc/httpd/conf.d/ssl.conf{,.bak}

systemctl enable httpd.service
systemctl start httpd.service

certbot --agree-tos -m afalko@gmail.com -n --apache -d jenkins.afalko.net

systemctl restart httpd.service

echo '* * * * * root /usr/bin/tar -cf /home/ec2-user/le-backup.tar /etc/letsencrypt' > /etc/cron.d/le-backup
echo '0 22 * * * root /usr/bin/certbot renew' > /etc/cron.d/le-renew

echo 'Redirect / https://jenkins.afalko.net/
ProxyPass         /  http://localhost:8080/ nocanon
ProxyPassReverse  /  http://localhost:8080/
ProxyRequests     Off
AllowEncodedSlashes NoDecode

# Local reverse proxy authorization override
<Proxy http://localhost:8080/*>
  Order deny,allow
  Allow from all
</Proxy>' > /etc/httpd/conf.d/jenkins.conf

systemctl restart httpd.service
