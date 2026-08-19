#!/usr/bin/env bash

set -euo pipefail

# Get the directory of the current script, then go up one level to the root
SCRIPT_DIR=$(dirname "$0")
ROOT_DIR=$(cd "$SCRIPT_DIR/../.." && pwd)
PASSTHROUGH_ARGS=()
PUSH_FLAG=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-cache)
            PASSTHROUGH_ARGS+=(--no-cache)
            ;;
        --push)
            PASSTHROUGH_ARGS+=(--push)
            PUSH_FLAG=true
            ;;
        -h|--help)
            echo "Usage: $0 [--push] [--no-cache]"
            echo "  Default: builds locally for current host architecture without pushing to Docker"
            echo "  --push: builds multi-architecture images and pushes to Docker registry"
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            echo "Usage: $0 [--push] [--no-cache]" >&2
            exit 1
            ;;
    esac

    shift
done

if [[ "$PUSH_FLAG" == true ]]; then
    echo "Starting build and push of all multi-arch dev images..."
else
    echo "Starting fast local build of dev images (no push)..."
fi

# Iterate over all subdirectories in the root directory
for dir in "$ROOT_DIR"/*/; do
    BUILD_SCRIPT="${dir}scripts/build-and-push-dev-image.sh"
    if [ -f "$BUILD_SCRIPT" ]; then
        MODULE_NAME=$(basename "$dir")
        echo "============================================================"
        if [[ "$PUSH_FLAG" == true ]]; then
            echo "Building and pushing dev image for module: $MODULE_NAME"
        else
            echo "Building dev image locally for module: $MODULE_NAME"
        fi
        echo "============================================================"
        (cd "$dir" && ./scripts/build-and-push-dev-image.sh ${PASSTHROUGH_ARGS[@]+"${PASSTHROUGH_ARGS[@]}"})
    fi
done

echo "============================================================"
if [[ "$PUSH_FLAG" == true ]]; then
    echo "All dev images built and pushed successfully!"
else
    echo "All dev images built locally and loaded into Docker successfully!"
fi
echo "============================================================"
