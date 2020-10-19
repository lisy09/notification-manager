#!/bin/bash

set -x

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. >/dev/null 2>&1 && pwd )"

TARGET_REPO=${TARGET_REPO:-lisy09kubesphere}
docker build -t ${TARGET_REPO}/${TARGET_IMAGE}:${TARGET_TAG} \
    --build-arg TARGET_PROJECT=${TARGET_PROJECT} \
    -f $ROOT_DIR/multiarch_build/builder.Dockerfile \
    $ROOT_DIR