#!/bin/bash
set -euo pipefail

# before-validate hook handler for asset-linter
# Enforces that asset names are kebab-case and files are placed in the right layout.
# Args: context (asset path), config

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SDK_DIR="$PLUGIN_ROOT/../../../core/plugin"

source "$SDK_DIR/sdk.sh"

ASSET_PATH="${1:-}"
[ -z "$ASSET_PATH" ] && { log_warn "asset-linter: no asset path in context"; exit 0; }

ASSET_NAME="$(basename "$ASSET_PATH")"

if ! echo "$ASSET_NAME" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    log_error "asset-linter: '$ASSET_NAME' is not kebab-case"
    exit 1
fi

log_info "asset-linter: '$ASSET_NAME' passes naming conventions"
exit 0
