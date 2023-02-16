#!/bin/bash

set -euo pipefail

cd $(dirname $0)/../
WORKINGDIR=$(pwd)

docker build --tag "${REGISTRY}/${TAG}:${SKOPEO_VERSION}-arm64" \
    --build-arg SKOPEO_VERSION="${SKOPEO_VERSION}" \
    --platform linux/arm64 \
    -f Dockerfile .

docker push "${REGISTRY}/${TAG}:${SKOPEO_VERSION}-arm64"
