#!/bin/bash

#
# Current Script Source Folder detection
#
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
PWD="$(pwd)"

#
# Init
#
source $DIR/build_config_registry

if [ -z "$1" ]
then
  (>&2 echo "Docker Image definition path is not specified, exiting")
  exit 64
else
  cd ${DIR}/../${1}/
  echo "$(pwd)"
  source ./build_config_image
fi

IMAGE_ARCH=amd64
if [ -n "$2" ]
then
  IMAGE_ARCH=$2
fi

#
# Script
#

DOCKER_FILE=Dockerfile.${IMAGE_ARCH}

docker build \
    -t ${DOCKER_REGISTRY}/${DOCKER_ORG}/${DOCKER_REPO}:${IMAGE_ARCH}-${PUBLISH_VERSION} \
    -f ${DOCKER_FILE} .

docker tag ${DOCKER_IMAGE_NAME}:${IMAGE_ARCH}-${PUBLISH_VERSION} ${DOCKER_IMAGE_NAME}:${IMAGE_ARCH}-latest

cd $PWD