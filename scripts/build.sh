#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Avalanche root directory
DIJETHH_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )"; cd .. && pwd )

# Load the versions
source "$DIJETHH_PATH"/scripts/versions.sh

# Load the constants
source "$DIJETHH_PATH"/scripts/constants.sh

if [[ $# -eq 1 ]]; then
    binary_path=$1
elif [[ $# -ne 0 ]]; then
    echo "Invalid arguments to build dijethh. Requires either no arguments (default) or one arguments to specify binary location."
    exit 1
fi

# Check if DIJETHH_COMMIT is set, if not retrieve the last commit from the repo.
# This is used in the Dockerfile to allow a commit hash to be passed in without
# including the .git/ directory within the Docker image.
dijethh_commit=${DIJETHH_COMMIT:-$( git rev-list -1 HEAD )}

# Build Dijethh, which is run as a subprocess
echo "Building Dijethh Version: $dijethh_version; GitCommit: $dijethh_commit"
go build -ldflags "-X github.com/lasthyphen/dijethh/plugin/evm.GitCommit=$dijethh_commit -X github.com/lasthyphen/dijethh/plugin/evm.Version=$dijethh_version" -o "$binary_path" "plugin/"*.go
