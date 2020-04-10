#!/usr/bin/env bash

set -e

# Ensure semver is passed as an argument

if [ $# -ne 1 ]
then
  echo "Unexpected number of arguments $#"
  echo "Usage: $0 <version>"
  echo "  where <version> is the VS Code release version e.g. 1.44.0"
  exit 1
fi

# Install these (required by the node script) without writing them as dependencies to package.json
echo "Installing things needed by update script..."
npm install --no-save fs-extra pkg-up got

# Update version and dependencies in package.json
echo "Running update script..."
./scripts/amend-package-json "$1"

# Normalize package.json contents (this alphabetizes the dep's, among other things)
echo "Normalizing package.json..."
npx sort-package-json

# Download binaries
echo "Downloading binaries..."
npm run build
