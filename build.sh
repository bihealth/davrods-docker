#!/bin/bash

export REPO=ghcr.io/bihealth/davrods-docker
export CONTAINER_VERSION=${CONTAINER_VERSION-4.3.3_1.5.1}
export IRODS_PKG_VERSION=${IRODS_PKG_VERSION-4.3.3}
export DAVRODS_IRODS_VERSION=${DAVRODS_IRODS_VERSION-4.2.12}
export BUILD_VERSION=${BUILD_VERSION-1}

docker build \
    -t "${REPO}:${CONTAINER_VERSION}-${BUILD_VERSION}" \
    --build-arg IRODS_PKG_VERSION=${IRODS_PKG_VERSION} \
    --build-arg DAVRODS_IRODS_VERSION=${DAVRODS_IRODS_VERSION} \
    docker

echo "Now do:"
echo "docker push ${REPO}:${CONTAINER_VERSION}-${BUILD_VERSION}"
