#!/bin/bash
set -euo pipefail

# Installer Script
# Install a plugin

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
    echo "Usage: $0 <plugin-name> [source-path]"
    echo "Example: $0 my-plugin /path/to/plugin"
    exit 1
fi

PLUGIN_NAME="$1"
PLUGIN_SOURCE="${2:-}"

echo "Installing plugin: $PLUGIN_NAME"
echo ""

# Create plugins directory if it doesn't exist
mkdir -p "$PLUGINS_DIR/community"

# Check if plugin already exists
if [ -d "$PLUGINS_DIR/community/$PLUGIN_NAME" ]; then
    log_warn "Plugin already installed: $PLUGIN_NAME"
    exit 0
fi

# Install plugin
if [ -n "$PLUGIN_SOURCE" ]; then
    # Install from source
    if [ ! -d "$PLUGIN_SOURCE" ]; then
        log_error "Source not found: $PLUGIN_SOURCE"
        exit 1
    fi
    
    log_info "Installing from source: $PLUGIN_SOURCE"
    cp -r "$PLUGIN_SOURCE" "$PLUGINS_DIR/community/$PLUGIN_NAME"
else
    # Create empty plugin
    log_info "Creating empty plugin: $PLUGIN_NAME"
    mkdir -p "$PLUGINS_DIR/community/$PLUGIN_NAME"
    
    # Create plugin.json
    cat > "$PLUGINS_DIR/community/$PLUGIN_NAME/plugin.json" << EOF
{
  "name": "$PLUGIN_NAME",
  "version": "0.1.0",
  "description": "Plugin description",
  "author": "Author name",
  "main": "index.sh",
  "hooks": {}
}
EOF
    
    # Create index.sh
    cat > "$PLUGINS_DIR/community/$PLUGIN_NAME/index.sh" << 'EOF'
#!/bin/bash
set -euo pipefail

# Plugin entry point

echo "Plugin loaded!"
EOF
    chmod +x "$PLUGINS_DIR/community/$PLUGIN_NAME/index.sh"
    
    # Create README
    cat > "$PLUGINS_DIR/community/$PLUGIN_NAME/README.md" << EOF
# $PLUGIN_NAME

Plugin description.

## Installation

\`\`\`bash
./core/plugin/installer.sh $PLUGIN_NAME
\`\`\`

## Usage

\`\`\`bash
./core/plugin/loader.sh
\`\`\`
EOF
fi

log_info "Plugin installed successfully!"