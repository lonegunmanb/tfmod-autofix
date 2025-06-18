#!/usr/bin/env bash

# if Makefile is not present, download it from the repository
if [ ! -f Makefile ]; then
    echo "Makefile not found. Downloading from the repository..."
    curl -H 'Cache-Control: no-cache, no-store' -sSL "https://raw.githubusercontent.com/lonegunmanb/tfmod-autofix/main/Makefile" -o Makefile
else
    echo "Makefile found."
fi

CONTAINER_RUNTIME=${CONTAINER_RUNTIME:-docker}

if [ ! "$(command -v "$CONTAINER_RUNTIME")" ]; then
    echo "Error: $CONTAINER_RUNTIME is not installed. Please install $CONTAINER_RUNTIME first."
    exit 1
fi

if [ -z "$1" ]; then
    echo "Error: Please provide a make target. See https://github.com/lonegunmanb/tfmod-autofix/blob/main/autofixmakefile for available targets."
    echo
    usage
    exit 1
fi

# Check if AZURE_CONFIG_DIR is set, if not, set it to ~/.azure
if [ -z "$AZURE_CONFIG_DIR" ]; then
  AZURE_CONFIG_DIR="$HOME/.azure"
fi

# Check if we are running in a container
# If we are then just run make directly
if [ -z "$IN_CONTAINER" ]; then
  $CONTAINER_RUNTIME run --pull always --user "$(id -u):$(id -g)" --rm -v "$(pwd)":/src -w /src -v $AZURE_CONFIG_DIR:/azureconfig -e AZURE_CONFIG_DIR=/azureconfig -e GITHUB_TOKEN -e GITHUB_REPOSITORY -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform make "$1"
else
  make "$1"
fi
