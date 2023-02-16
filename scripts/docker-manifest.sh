#!/bin/bash

set -euo pipefail

cd $(dirname $0)/../
WORKINGDIR=$(pwd)

if [[ -z "${DOCKER_USERNAME:-}" || -z "${DOCKER_PASSWORD:-}" ]]; then
    echo "DOCKER_USERNAME or DOCKER_PASSWORD not set"
    exit 1
fi

# Check docker buildx installed or not
if ! docker buildx version &> /dev/null ; then
    BUILDX_ARCH=""
    case $(uname -m) in
        x86_64)
            BUILDX_ARCH="amd64"
            ;;
        aarch64)
            BUILDX_ARCH="arm64"
            ;;
        *)
            echo "unrecognized arch: $(uname -m)"
            echo "Please install docker-buildx manually"
            exit 1
            ;;
    esac
    echo "docker buildx arch: $BUILDX_ARCH"
    # Add buildx plugin from github
    mkdir -p ${HOME}/.docker/cli-plugins/ && \
    curl -sLo ${HOME}/.docker/cli-plugins/docker-buildx \
        https://github.com/docker/buildx/releases/download/v0.10.2/buildx-v0.10.2.linux-${BUILDX_ARCH} && \
    chmod +x ${HOME}/.docker/cli-plugins/docker-buildx
fi

echo "${DOCKER_PASSWORD}" | docker login \
    --username ${DOCKER_USERNAME} \
    --password-stdin

export TAG=${TAG:-"hardened-skopeo"}
export REGISTRY=${REGISTRY:-"docker.io/cnrancher"}
export SKOPEO_VERSION=${SKOPEO_VERSION}
echo "version: ${SKOPEO_VERSION}"
echo "TAG: ${TAG}:${SKOPEO_VERSION}"

docker buildx imagetools create --tag "${REGISTRY}/${TAG}:${SKOPEO_VERSION}" \
    "${REGISTRY}/${TAG}:${SKOPEO_VERSION}-arm64" \
    "${REGISTRY}/${TAG}:${SKOPEO_VERSION}-amd64"

# update latest tag
if [[ "${SKIP_LATEST_TAG:-}" != "1" ]]; then
    docker buildx imagetools create --tag "${REGISTRY}/${TAG}:latest" \
        "${REGISTRY}/${TAG}:${SKOPEO_VERSION}-arm64" \
        "${REGISTRY}/${TAG}:${SKOPEO_VERSION}-amd64"
fi
