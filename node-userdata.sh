#!/bin/bash

yum install -y docker java-1.8.0-openjdk-headless git
systemctl enable docker
systemctl start docker

gpasswd -a ec2-user docker