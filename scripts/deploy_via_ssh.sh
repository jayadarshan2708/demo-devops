#!/bin/bash
IMAGE="$1"
EC2_USER=ec2_user
EC2_HOST=
SSH_KEY_PATH=${key.pem}

if [-z "$IMAGE" ]; then
	echo "image required"
	exit 1
fi

ssh -o StrictHostChecking=no -i "$SSH_KEY_PATH" ${EC2_USER}@{EC@_HOST} <<EOF
	docker pull $IMAGE
	docker stop demo || true
	docker rm demo || true
	docker run -d --name demo -p 80:8080 $IMAGE
EOF
