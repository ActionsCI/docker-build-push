#!/bin/bash

# Input validation
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Missing required arguments: image name, version, and directory."
  exit 1
fi

IMAGE_NAME=$1
VERSION=$2
DIRECTORY=$3
DOCKERFILE=${4:-Dockerfile}
BUILD_ARGS=${5:-}
REGISTRY_URL=${6:-docker.io}
REGISTRY_USERNAME=$7
REGISTRY_PASSWORD=$8
DOCKERHUB_TOKEN=${9:-}  # New optional Docker Hub token

# Decide whether to use DOCKERHUB_TOKEN or REGISTRY_PASSWORD for login
if [ ! -z "$DOCKERHUB_TOKEN" ]; then
  echo "Using Docker Hub token for authentication"
  echo "$DOCKERHUB_TOKEN" | docker login "$REGISTRY_URL" -u "$REGISTRY_USERNAME" --password-stdin
else
  echo "Using registry password for authentication"
  echo "$REGISTRY_PASSWORD" | docker login "$REGISTRY_URL" -u "$REGISTRY_USERNAME" --password-stdin
fi

# Docker build and push
docker build -t "$REGISTRY_URL/$IMAGE_NAME:$VERSION" --file "$DOCKERFILE" $BUILD_ARGS "$DIRECTORY"
docker push "$REGISTRY_URL/$IMAGE_NAME:$VERSION"
