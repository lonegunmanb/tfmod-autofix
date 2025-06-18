#!/usr/bin/env bash

# Function to run make target either directly (if in container) or via container
run_make() {
  local target="$1"

  if [ -z "$IN_CONTAINER" ]; then
    $CONTAINER_RUNTIME run --pull always --user "$(id -u):$(id -g)" --rm -v "$(pwd)":/src -w /src -v $AZURE_CONFIG_DIR:/azureconfig -e AZURE_CONFIG_DIR=/azureconfig -e GITHUB_TOKEN -e GITHUB_REPOSITORY -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform make "$target"
  else
    make "$target"
  fi
}

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

# Check if AZURE_CONFIG_DIR is set, if not, set it to ~/.azure
if [ -z "$AZURE_CONFIG_DIR" ]; then
  AZURE_CONFIG_DIR="$HOME/.azure"
fi

run_make pre-commit
run_make pr-check