#!/bin/bash

set -x

MULTIARCH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR="$( cd $MULTIARCH_DIR/.. >/dev/null 2>&1 && pwd )"

TARGET_REPO=${TARGET_REPO:-lisy09kubesphere}
TARGET_PLATFORMS=linux/amd64,linux/arm64,linux/arm/v7

declare -A targets
i=0
targets+=([$i,TARGET_PROJECT]=notification-manager \
        [$i,TARGET_IMAGE]=notification-manager \
        [$i,TARGET_TAG]=v0.1.0 \
        [$i,ENTRY_BINARY]=notification-manager)
((i++))
targets+=([$i,TARGET_PROJECT]=operator \
        [$i,TARGET_IMAGE]=notification-manager-operator \
        [$i,TARGET_TAG]=v0.1.0 \
        [$i,ENTRY_BINARY]=notification-manager-operator)
max_i=$i

for (( i=0; i <= $max_i; i++ ))
do
    TARGET_PROJECT=${targets[$i,TARGET_PROJECT]}
    TARGET_IMAGE=${targets[$i,TARGET_IMAGE]}
    TARGET_TAG=${targets[$i,TARGET_TAG]}
    ENTRY_BINARY=${targets[$i,ENTRY_BINARY]}

    sed -e "s;%TARGET_PROJECT%;$TARGET_PROJECT;g" \
        -e "s;%ENTRY_BINARY%;$ENTRY_BINARY;g" \
        $MULTIARCH_DIR/final.Dockerfile > $MULTIARCH_DIR/$TARGET_PROJECT.Dockerfile

    docker buildx build \
    --platform ${TARGET_PLATFORMS} \
    -t ${TARGET_REPO}/${TARGET_IMAGE}:${TARGET_TAG} \
    -f $MULTIARCH_DIR/$TARGET_PROJECT.Dockerfile \
    $ROOT_DIR --push
done