#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Building $DEVENV_PACKAGE_NAME Debian package..."

# Create a temporary build directory
BUILD_DIR=$(mktemp -d)
trap "rm -rf $BUILD_DIR" EXIT

# Copy debian files to temporary directory
mkdir -p "$BUILD_DIR/$DEVENV_PACKAGE_NAME-1.0.0"
cp -r "$SCRIPT_DIR"/* "$BUILD_DIR/$DEVENV_PACKAGE_NAME-1.0.0/"

# Move to build directory
cd "$BUILD_DIR/$DEVENV_PACKAGE_NAME-1.0.0"

# Build the package
echo "Running dpkg-buildpackage..."
dpkg-buildpackage -us -uc -b

# Copy the built package back to the repo
echo "Package built successfully!"
cp "$BUILD_DIR"/*.deb "$REPO_ROOT/"

echo "Debian package created: $(ls "$REPO_ROOT"/*.deb)"