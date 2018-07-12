# Demo environment setup for - [Docker Image Update](https://github.com/salesforce/dockerfile-image-update) and [Argus Notifier plugin](https://plugins.jenkins.io/argus-notifier)

Scripts and automation to set up the following:
* [Jenkins](https://jenkins.io/) with the [Argus Notifier plugin](https://plugins.jenkins.io/argus-notifier)
* [Argus](https://github.com/salesforce/Argus)

## Getting Started

# Dependencies
You need the following installed on your system:
* Docker
* Docker Compose
* Git
* Nginx

```
yum install -y nginx git docker
systemctl start docker.service
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

Configure the target from the root of the repo:
```
echo 'MAIN_JENKINS_URL=https://<my intended domain>' >> jenkins/.jenkins.env
```
Then deploy:
```
bash ./deploy_me.sh
```

If you name any changes, keep re-running `bash ./deploy_me.sh`