#!/bin/bash
set -euo pipefail

# after-generate hook handler for asset-linter
# Logs a summary after an asset has been generated.
# Args: context, asset

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SDK_DIR="$PLUGIN_ROOT/../../../core/plugin"

source "$SDK_DIR/sdk.sh"

ASSET_PATH="${2:-${1:-}}"
if [ -n "$ASSET_PATH" ]; then
    log_info "asset-linter: asset generated at '$ASSET_PATH'"
fi
exit 0
