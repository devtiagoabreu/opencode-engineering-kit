#!/bin/bash
set -euo pipefail

# Loader Script
# Load plugins from plugins directory

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

echo "Loading plugins..."
echo ""

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
        if [ -d "$plugin_dir" ]; then
            plugin_name="$(basename "$plugin_dir")"
            
            # Check if plugin.json exists
            if [ -f "$plugin_dir/plugin.json" ]; then
                log_info "Loading plugin: $plugin_name"
                
                # Validate plugin
                if [ -f "$plugin_dir/index.sh" ] || [ -f "$plugin_dir/index.js" ]; then
                    log_info "  ✓ Plugin valid"
                else
                    log_warn "  ✗ Plugin invalid: missing entry point"
                fi
            else
                log_warn "Skipping $plugin_name: missing plugin.json"
            fi
        fi
    done
fi

# Load enterprise plugins
echo ""
echo "=== Enterprise Plugins ==="
if [ -d "$PLUGINS_DIR/enterprise" ]; then
    for plugin_dir in "$PLUGINS_DIR/enterprise"/*/; do
        if [ -d "$plugin_dir" ]; then
            plugin_name="$(basename "$plugin_dir")"
            
            # Check if plugin.json exists
            if [ -f "$plugin_dir/plugin.json" ]; then
                log_info "Loading plugin: $plugin_name"
                
                # Validate plugin
                if [ -f "$plugin_dir/index.sh" ] || [ -f "$plugin_dir/index.js" ]; then
                    log_info "  ✓ Plugin valid"
                else
                    log_warn "  ✗ Plugin invalid: missing entry point"
                fi
            else
                log_warn "Skipping $plugin_name: missing plugin.json"
            fi
        fi
    done
fi

echo ""
log_info "Plugin loading complete!"