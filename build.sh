#!/bin/bash

export REPO=ghcr.io/bihealth/davrods-docker
export DAVRODS_PKG_VERSION=${DAVRODS_PKG_VERSION-4.2.11_1.5.0}
export BUILD_VERSION=${BUILD_VERSION-1}

docker build \
    -t "${REPO}:${DAVRODS_PKG_VERSION}-${BUILD_VERSION}" \
    --target main \
    docker

echo "Now do:"
echo "docker push ${REPO}:${DAVRODS_PKG_VERSION}-${BUILD_VERSION}"
