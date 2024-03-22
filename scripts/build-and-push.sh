#!/bin/bash

# Input validation
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Missing required arguments: image name, version, and directory."
  exit 1
fi

IMAGE_NAME=$1
VERSION=$2
DIRECTORY=$3
DOCKERFILE=${4}
BUILD_ARGS=${5}
REGISTRY_URL=${6}
REGISTRY_USERNAME=$7 # optional registry username
REGISTRY_PASSWORD=$8  # optional registry password
DOCKERHUB_TOKEN=${9}  # optional Docker Hub token
#check all vars are not empty with 1 liners
[ -z "$IMAGE_NAME" ] && echo "IMAGE_NAME is empty" && exit 1
[ -z "$VERSION" ] && echo "VERSION is empty" && exit 1
[ -z "$DIRECTORY" ] && echo "DIRECTORY is empty" && exit 1
[ -z "$REGISTRY_URL" ] && echo "REGISTRY_URL is empty" && exit 1

# Decide whether to use DOCKERHUB_TOKEN or REGISTRY_PASSWORD for login
if [ ! -z "$DOCKERHUB_TOKEN" ]; then
  echo "Using Docker Hub token for authentication"
  echo "$DOCKERHUB_TOKEN" | docker login "$REGISTRY_URL" -u "$REGISTRY_USERNAME" --password-stdin
elif [ ! -z "$REGISTRY_USERNAME" ] && [ ! -z "$REGISTRY_PASSWORD" ]; then
  echo "Using registry password for authentication"
  echo "$REGISTRY_PASSWORD" | docker login "$REGISTRY_URL" -u "$REGISTRY_USERNAME" --password-stdin
else
  echo "No authentication method provided"
fi

# Docker build and push
docker build -t "$REGISTRY_URL/$IMAGE_NAME:$VERSION" --file "$DOCKERFILE" $BUILD_ARGS "$DIRECTORY"
docker push "$REGISTRY_URL/$IMAGE_NAME:$VERSION"
