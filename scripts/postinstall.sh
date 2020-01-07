#!/usr/bin/env bash

# When consumer installs this package, extract the platform-specific VS Code binary.

set -e

ROOT_DIR=`pwd`

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux x64
  cd $ROOT_DIR/bin/linux-x64
  BUNDLEFILE=VSCode-linux-x64.tar.gz
  if [[ -f "$BUNDLEFILE" ]]; then
    echo "Extracting $BUNDLEFILE"
    tar -xvf $BUNDLEFILE
    rm -f $BUNDLEFILE
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac
  cd $ROOT_DIR/bin/darwin
  BUNDLEFILE=VSCode-darwin.zip
  if [[ -f "$BUNDLEFILE" ]]; then
    if [[ ! -d "Visual Studio Code.app" ]]; then
      echo "Unzipping $BUNDLEFILE"
      unzip $BUNDLEFILE
    fi
    rm -f $BUNDLEFILE
  fi
else
  # Unknown
  echo "vscode-binaries does not support platform $OSTYPE"
fi
