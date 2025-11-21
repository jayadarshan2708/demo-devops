#!/bin/bash
apt-get update
apt-get install -y docker.io docker-compose
systemctl enable docker
systemctl start docker
mkdir -p /opt/demo
chown ubuntu:ubuntu /opt/demo
