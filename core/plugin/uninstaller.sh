#!/bin/bash
set -euo pipefail

# Uninstaller Script
# Uninstall a plugin

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

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 <plugin-name>"
    echo "Example: $0 my-plugin"
    exit 1
fi

PLUGIN_NAME="$1"

echo "Uninstalling plugin: $PLUGIN_NAME"
echo ""

# Check if plugin exists
if [ ! -d "$PLUGINS_DIR/community/$PLUGIN_NAME" ]; then
    log_error "Plugin not found: $PLUGIN_NAME"
    exit 1
fi

# Remove plugin
log_info "Removing plugin: $PLUGIN_NAME"
rm -rf "$PLUGINS_DIR/community/$PLUGIN_NAME"

log_info "Plugin uninstalled successfully!"