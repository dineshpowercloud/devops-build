#!/usr/bin/env bash
set -e
# Usage: DOCKER_USER=dineshpowercloud DOCKER_PASS=your-docker-hub-password ./build.sh [tag]
TAG=${1:-latest}
IMAGE="${DOCKER_USER:-dineshpowercloud}/devops-app:${TAG}"

echo "Building $IMAGE"
docker build -t "$IMAGE" .
echo "Logging to Docker Hub..."
echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
docker push "$IMAGE"
# Push latest tag too
docker tag "$IMAGE" "${DOCKER_USER}/devops-app:latest"
docker push "${DOCKER_USER}/devops-app:latest"
echo "Done"
