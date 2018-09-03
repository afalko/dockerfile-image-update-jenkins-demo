#!/bin/bash

yum install -y wget yum-utils java-1.8.0-openjdk-headless git
yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce

gpasswd -a centos docker

systemctl enable docker
systemctl start docker

