#!/bin/bash
# Script to build ARMv7 Docker image for Rasa

# Use the latest supported version if no argument has been specified
if [ -z "$1" ]; then
    VERSION=$(cat RASA_VERSION)
    echo "No version specified, using ${VERSION}"
else
    VERSION=$1
fi

RASA_DIR=rasa-${VERSION}
TARBALL=rasa-${VERSION}.tar.gz
DOWNLOAD_URL=https://github.com/RasaHQ/rasa/archive
TARBALL_URL="${DOWNLOAD_URL}"/"${VERSION}".tar.gz
PATCH=patches/rasa-"${VERSION}"-arm.patch

# Download and extract Rasa archive
if [ ! -f "${TARBALL}" ]; then
    wget -O "${TARBALL}" "${TARBALL_URL}"
fi
if [ -d "${RASA_DIR}" ]; then
    rm -rf "${RASA_DIR}"
fi
tar xzf "${TARBALL}"

# Patch Rasa if there's a patch for this version
if [ -f "${PATCH}" ]; then
    # Patch created with (for example):
    # $ diff -ruN rasa-1.10.5 rasa-1.10.5-2 > patches/rasa-1.10.5-arm.patch
    patch -s -p0 < "${PATCH}"
fi

# Copy pip.conf with piwheels URL
cp pip.conf "${RASA_DIR}"

# Build patched Rasa image
cd "${RASA_DIR}" || exit
docker build . -t rasa:"${VERSION}"
