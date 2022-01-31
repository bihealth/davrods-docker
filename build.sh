#!/bin/bash

export REPO=ghcr.io/bihealth/davrods-docker
export DAVRODS_PKG_VERSION=${DAVRODS_PKG_VERSION-4.2.11_1.5.0}

docker build \
    -t "${REPO}:${DAVRODS_PKG_VERSION}" \
    -t "${REPO}:latest" \
    --target main \
    docker

echo "Now do:"
echo "docker push ${REPO}:${DAVRODS_PKG_VERSION}"
echo "docker push ${REPO}:latest"
