#!/bin/bash

# Validate inputs
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
  echo "Error: Missing required arguments: image name, version, and directory."
  exit 1
fi

IMAGE_NAME=$1
VERSION=$2
DIRECTORY=$3
DOCKERFILE=${4:-Dockerfile}
BUILD_ARGS=$5
REGISTRY_URL=${6:-docker.io}
REGISTRY_USERNAME=$7
REGISTRY_PASSWORD=$8

echo "Logging into Docker registry $REGISTRY_URL..."
echo "$REGISTRY_PASSWORD" | docker login "$REGISTRY_URL" -u "$REGISTRY_USERNAME" --password-stdin

echo "Building Docker image $REGISTRY_URL/$IMAGE_NAME:$VERSION..."
# If build_args is non-empty, convert it to Docker build's --build-arg format
if [ ! -z "$BUILD_ARGS" ]; then
  IFS=' ' read -r -a args_array <<< "$BUILD_ARGS"
  for arg in "${args_array[@]}"; do
    build_args_cmd+="--build-arg $arg "
  done
fi

docker build -t "$REGISTRY_URL/$IMAGE_NAME:$VERSION" $build_args_cmd--file "$DOCKERFILE" "$DIRECTORY"

echo "Pushing Docker image $REGISTRY_URL/$IMAGE_NAME:$VERSION..."
docker push "$REGISTRY_URL/$IMAGE_NAME:$VERSION"
