#!/bin/bash
set -euo pipefail

# Plugin entry point: asset-linter

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
SDK_DIR="$PLUGIN_ROOT/../../../core/plugin"

source "$SDK_DIR/sdk.sh"

export PLUGIN_NAME="asset-linter"
export PLUGIN_VERSION="1.0.0"

log_info "Plugin loaded: $PLUGIN_NAME v$PLUGIN_VERSION"
