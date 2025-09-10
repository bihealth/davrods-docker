#!/bin/bash

export REPO=ghcr.io/bihealth/davrods-docker
export CONTAINER_VERSION=${CONTAINER_VERSION-4.3.4_1.5.2}
export IRODS_PKG_VERSION=${IRODS_PKG_VERSION-4.3.4}
export DAVRODS_IRODS_VERSION=${DAVRODS_IRODS_VERSION-4.3.4}
export BUILD_VERSION=${BUILD_VERSION-1}

docker build \
    -t "${REPO}:${CONTAINER_VERSION}-${BUILD_VERSION}" \
    --build-arg IRODS_PKG_VERSION=${IRODS_PKG_VERSION} \
    --build-arg DAVRODS_IRODS_VERSION=${DAVRODS_IRODS_VERSION} \
    docker

echo "Now do:"
echo "docker push ${REPO}:${CONTAINER_VERSION}-${BUILD_VERSION}"
