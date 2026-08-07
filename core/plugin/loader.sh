#!/bin/bash
set -euo pipefail

# Loader Script
# Load plugins from plugins directory
#
# Usage:
#   ./core/plugin/loader.sh                # Load all plugins
#   ./core/plugin/loader.sh --check        # Validate all plugins, exit non-zero on errors

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
PLUGINS_DIR="$ROOT_DIR/plugins"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

CHECK_MODE=0
[ "${1:-}" = "--check" ] && CHECK_MODE=1

FAILURES=0

load_plugin_dir() {
    local plugin_dir="$1"
    [ ! -d "$plugin_dir" ] && return 0

    local plugin_name
    plugin_name="$(basename "$plugin_dir")"

    if [ ! -f "$plugin_dir/plugin.json" ]; then
        log_warn "Skipping $plugin_name: missing plugin.json"
        return 0
    fi

    # Validate manifest through the SDK
    if ! manifest_info="$(sdk_validate_manifest "$plugin_dir/plugin.json")"; then
        log_error "  ✗ $plugin_name: invalid manifest"
        FAILURES=$((FAILURES + 1))
        return 0
    fi

    read -r p_name p_version p_entry <<< "$manifest_info"

    # Validate the entry point
    if [ -z "$p_entry" ]; then
        p_entry="index.sh"
    fi

    if [ ! -f "$plugin_dir/$p_entry" ]; then
        log_error "  ✗ $plugin_name: missing entry point '$p_entry'"
        FAILURES=$((FAILURES + 1))
        return 0
    fi

    log_info "Loading plugin: $p_name v$p_version"

    # Report declared hooks
    local hooks
    hooks="$(python3 -c "
import json, sys
with open('$plugin_dir/plugin.json') as f:
    m = json.load(f)
print(' '.join(m.get('hooks', [])))
" 2>/dev/null || echo "")"
    if [ -n "$hooks" ]; then
        log_info "  ✓ Hooks: $hooks"
    else
        log_info "  ✓ No hooks declared"
    fi

    # Report declared permissions
    local perms
    perms="$(python3 -c "
import json, sys
with open('$plugin_dir/plugin.json') as f:
    m = json.load(f)
print(' '.join(m.get('permissions', [])))
" 2>/dev/null || echo "")"
    if [ -n "$perms" ]; then
        log_info "  ✓ Permissions: $perms"
    fi

    # Load the entry point
    if [[ "$p_entry" == *.sh ]]; then
        PLUGIN_NAME="$p_name" PLUGIN_VERSION="$p_version" bash "$plugin_dir/$p_entry" 2>/dev/null || {
            log_warn "  - entry point exited non-zero (load continued)"
        }
    fi
}

echo "Loading plugins..."
echo ""

source "$SCRIPT_DIR/sdk.sh"

# Check if plugins directory exists
if [ ! -d "$PLUGINS_DIR" ]; then
    log_warn "Plugins directory not found: $PLUGINS_DIR"
    log_info "Creating plugins directory..."
    mkdir -p "$PLUGINS_DIR/community"
    mkdir -p "$PLUGINS_DIR/enterprise"
fi

# Load community plugins
echo "=== Community Plugins ==="
if [ -d "$PLUGINS_DIR/community" ]; then
    for plugin_dir in "$PLUGINS_DIR/community"/*/; do
        load_plugin_dir "$plugin_dir"
    done
fi

# Load enterprise plugins
echo ""
echo "=== Enterprise Plugins ==="
if [ -d "$PLUGINS_DIR/enterprise" ]; then
    for plugin_dir in "$PLUGINS_DIR/enterprise"/*/; do
        load_plugin_dir "$plugin_dir"
    done
fi

echo ""
log_info "Plugin loading complete!"

if [ "$CHECK_MODE" = "1" ] && [ "$FAILURES" -gt 0 ]; then
    log_error "$FAILURES plugin(s) failed validation"
    exit 1
fi

exit 0