#!/usr/bin/env bash

# When consumer installs this package, extract the platform-specific VS Code binary.

set -e

ROOT_DIR=`pwd`

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux x64
  cd $ROOT_DIR/bin/linux-x64
  tar -xvf VSCode-linux-x64.tar.gz
  rm -f VSCode-linux-x64.tar.gz
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # For Mac, due to a bug in the way the VSCode-darwin-stable.zip is constructed, if we use `tar` to
  # extract it then VS Code won't start succesfully due to this strange error:
  #
  # dyld: Library not loaded: @rpath/Electron Framework.framework/Electron Framework
  #   Referenced from: /Users/rconrad/dev/vscode-extensions/external/vscode-binaries/bin/darwin/Visual Studio Code.app/Contents/MacOS/Electron
  #   Reason: no suitable image found.  Did find:
  #         /Users/rconrad/dev/vscode-extensions/external/vscode-binaries/bin/darwin/Visual Studio Code.app/Contents/MacOS/../Frameworks/Electron Framework.framework/Electron Framework: file too short
  #         /Users/rconrad/dev/vscode-extensions/external/vscode-binaries/bin/darwin/Visual Studio Code.app/Contents/MacOS/../Frameworks/Electron Framework.framework/Electron Framework: stat() failed with errno=1
  #
  # Exit code:   null
  # Done
  #
  # It might be related to symlinks inside the Mac framework bundles, or the way the electron builder
  # assembles the zip (mentioned at https://github.com/dsheiko/puppetry/issues/23).
  #
  # To work around this we'll just have this script make the darwin directory and download the zip.
  cd $ROOT_DIR/bin/darwin
  unzip VSCode-darwin.zip
  rm -f VSCode-darwin.zip
else
  # Unknown - do nothing
  echo "vscode-binaries does not support platform $OSTYPE"
fi
