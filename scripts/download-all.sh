#!/usr/bin/env bash

set -ex

ROOT_DIR=`pwd`
DOWNLOAD_VERSION=$(jq ".version" package.json | cut -d "\"" -f 2)
DOWNLOAD_BUILD=stable

for DOWNLOAD_PLATFORM in linux-x64 darwin
do
  echo "Platform: $DOWNLOAD_PLATFORM"
  mkdir -p $ROOT_DIR/bin/$DOWNLOAD_PLATFORM
  cd $ROOT_DIR/bin/$DOWNLOAD_PLATFORM
  echo ">>> Downloading VS Code version=${DOWNLOAD_VERSION} build=${DOWNLOAD_BUILD} for platform=${DOWNLOAD_PLATFORM}"
  curl -L https://update.code.visualstudio.com/${DOWNLOAD_VERSION}/${DOWNLOAD_PLATFORM}/${DOWNLOAD_BUILD} | tar xvz
done
