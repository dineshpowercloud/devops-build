#!/usr/bin/env bash
set -e
# Usage: REMOTE_USER=ubuntu REMOTE_HOST=your-ec2-ip IMAGE=dineshpowercloud/devops-app:latest SSH_KEY=~/.ssh/yourkey.pem ./deploy.sh
REMOTE_USER=${REMOTE_USER:-ubuntu}
REMOTE_HOST=${REMOTE_HOST:?set REMOTE_HOST}
SSH_KEY=${SSH_KEY:-~/.ssh/id_rsa}
IMAGE=${IMAGE:-dineshpowercloud/devops-app:latest}

ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" "$REMOTE_USER@$REMOTE_HOST" <<EOF
  docker pull $IMAGE
  docker stop web || true
  docker rm web || true
  docker run -d --name web -p 80:80 --restart unless-stopped $IMAGE
EOF
