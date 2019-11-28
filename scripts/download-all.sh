#!/usr/bin/env bash

set -ex

ROOT_DIR=`pwd`
DOWNLOAD_VERSION=$(jq ".version" package.json | cut -d "\"" -f 2)
DOWNLOAD_BUILD=stable

# Example download URLs:
# https://update.code.visualstudio.com/1.40.1/linux-x64/stable --> yields code-stable-NNNNNNNNNN.tar.gz
# https://update.code.visualstudio.com/1.40.1/darwin/stable    --> yields VSCode-darwin-stable.zip

# For Mac, due to a bug in the way the VSCode-darwin-stable.zip is constructed, if we use `tar` to
# extract it then VS Code won't start succesfully due to this strange error:

# dyld: Library not loaded: @rpath/Electron Framework.framework/Electron Framework
#   Referenced from: /Users/rconrad/dev/vscode-extensions/external/vscode-binaries/bin/darwin/Visual Studio Code.app/Contents/MacOS/Electron
#   Reason: no suitable image found.  Did find:
#         /Users/rconrad/dev/vscode-extensions/external/vscode-binaries/bin/darwin/Visual Studio Code.app/Contents/MacOS/../Frameworks/Electron Framework.framework/Electron Framework: file too short
#         /Users/rconrad/dev/vscode-extensions/external/vscode-binaries/bin/darwin/Visual Studio Code.app/Contents/MacOS/../Frameworks/Electron Framework.framework/Electron Framework: stat() failed with errno=1
#
# Exit code:   null
# Done

# Possibly related to something mentioned at https://github.com/dsheiko/puppetry/issues/23 implying
# the electron builder doesn't put together the zip correctly.

# To work around this we'll just have this script make the darwin directory and download the zip.

for DOWNLOAD_PLATFORM in linux-x64 darwin
do
  echo "Downloading binary for platform: $DOWNLOAD_PLATFORM"
  mkdir -p $ROOT_DIR/bin/$DOWNLOAD_PLATFORM
  cd $ROOT_DIR/bin/$DOWNLOAD_PLATFORM
  echo ">>> Downloading VS Code version=${DOWNLOAD_VERSION} build=${DOWNLOAD_BUILD} for platform=${DOWNLOAD_PLATFORM}"
  if [[ "$DOWNLOAD_PLATFORM" == "darwin" ]]; then
    # Mac
    # Use `unzip` to extract the zip, since `tar` results in runtime errors inside Electron
    curl -L https://update.code.visualstudio.com/${DOWNLOAD_VERSION}/${DOWNLOAD_PLATFORM}/${DOWNLOAD_BUILD} > VSCode-darwin-stable.zip
    unzip VSCode-darwin-stable.zip
    rm -f VSCode-darwin-stable.zip
  else
    # Linux x64
    curl -L https://update.code.visualstudio.com/${DOWNLOAD_VERSION}/${DOWNLOAD_PLATFORM}/${DOWNLOAD_BUILD} | tar xvz
  fi
done
