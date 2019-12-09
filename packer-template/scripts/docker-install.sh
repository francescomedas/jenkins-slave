#!/bin/bash

### Disable SELinux
sudo sed -i -e \"s/^SELINUX=enforcing/SELINUX=disabled/g\" /etc/selinux/config
sudo setenforce 0

### Clean up
sudo yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine


### Install pre-requirements
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

### Enable the Docker CE repository
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum update -y

### Install the Docker CE and its requirements
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker

### Add centos user to docker group
sudo usermod -aG docker centos

### Test engine and close the image

sudo docker run --rm hello-world
if [[  $? -eq 0 ]]; then 
    echo "TEST PASSED"
    sudo rm -rf /var/lib/docker/*

else
    echo "DOCKER TEST FAILED"
    exit 125
fi

######################################################
