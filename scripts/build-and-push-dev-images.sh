#!/usr/bin/env bash

set -euo pipefail

# Get the directory of the current script, then go up one level to the root
SCRIPT_DIR=$(dirname "$0")
ROOT_DIR=$(cd "$SCRIPT_DIR/../.." && pwd)
NO_CACHE_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-cache)
            NO_CACHE_ARGS+=(--no-cache)
            ;;
        -h|--help)
            echo "Usage: $0 [--no-cache]"
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            echo "Usage: $0 [--no-cache]" >&2
            exit 1
            ;;
    esac

    shift
done

echo "Starting build and push of all dev images..."

# Iterate over all subdirectories in the root directory
for dir in "$ROOT_DIR"/*/; do
    BUILD_SCRIPT="${dir}scripts/build-and-push-dev-image.sh"
    if [ -f "$BUILD_SCRIPT" ]; then
        MODULE_NAME=$(basename "$dir")
        echo "============================================================"
        echo "Building and pushing dev image for module: $MODULE_NAME"
        echo "============================================================"
        if [ ${#NO_CACHE_ARGS[@]} -eq 0 ]; then
            (cd "$dir" && ./scripts/build-and-push-dev-image.sh)
        else
            (cd "$dir" && ./scripts/build-and-push-dev-image.sh "${NO_CACHE_ARGS[@]}")
        fi
    fi
done

echo "============================================================"
echo "All dev images built and pushed successfully!"
echo "============================================================"
