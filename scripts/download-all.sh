#!/usr/bin/env bash

# Before publishing this package, download binaries for supported platforms (Mac and Linux x64).
#
# The binaries are zips or tarballs.
#
# We do not extract these binaries until they land on the target machine (when the consumer installs
# this package) because they can contain symlinks or other things that are not preserved correctly
# by npm (see https://npm.community/t/how-can-i-publish-symlink/5599/5 for example). In particular,
# the Mac zip contains links inside framework subdirectories which do not survive publishing to npm.
# So we leave the zips / tarballs intact before publishing, then extract on 'postinstall'.

set -e

ROOT_DIR=`pwd`
DOWNLOAD_VERSION=$(jq ".version" package.json | cut -d "\"" -f 2)
DOWNLOAD_BUILD=stable

# Example download URLs:
# https://update.code.visualstudio.com/1.40.1/linux-x64/stable --> yields code-stable-NNNNNNNNNN.tar.gz
# https://update.code.visualstudio.com/1.40.1/darwin/stable    --> yields VSCode-darwin-stable.zip

for DOWNLOAD_PLATFORM in darwin linux-x64
do
  echo "Downloading binary for platform: $DOWNLOAD_PLATFORM"
  mkdir -p $ROOT_DIR/bin/$DOWNLOAD_PLATFORM
  cd $ROOT_DIR/bin/$DOWNLOAD_PLATFORM
  echo ">>> Downloading VS Code version=${DOWNLOAD_VERSION} build=${DOWNLOAD_BUILD} for platform=${DOWNLOAD_PLATFORM}"
  if [[ "$DOWNLOAD_PLATFORM" == "darwin" ]]; then
    # Mac
    OUTFILE=VSCode-darwin.zip
  else
    # Linux x64
    OUTFILE=VSCode-linux-x64.tar.gz
  fi
  curl -L https://update.code.visualstudio.com/${DOWNLOAD_VERSION}/${DOWNLOAD_PLATFORM}/${DOWNLOAD_BUILD} > $OUTFILE
done
