#!/bin/bash
set -euo pipefail

# Plugin SDK
# Provides helper functions for building OpenCode Engineering Kit plugins
# Usage: source ./core/plugin/sdk.sh

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Logger API (available to plugins as log_*)
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Plugin context helpers
PLUGIN_CONTEXT_DIR="${PLUGIN_CONTEXT_DIR:-}"

# Validate a plugin manifest
sdk_validate_manifest() {
    local manifest="$1"
    if [ ! -f "$manifest" ]; then
        log_error "Missing plugin manifest: $manifest"
        return 1
    fi

    local name version entry
    name="$(python3 -c "
import json, sys
with open('$manifest') as f:
    m = json.load(f)
print(m.get('name', ''))
" 2>/dev/null || echo "")"
    version="$(python3 -c "
import json, sys
with open('$manifest') as f:
    m = json.load(f)
print(m.get('version', ''))
" 2>/dev/null || echo "")"
    entry="$(python3 -c "
import json, sys
with open('$manifest') as f:
    m = json.load(f)
print(m.get('entry', 'index.sh'))
" 2>/dev/null || echo "index.sh")"

    [ -z "$name" ] && { log_error "Plugin name is required"; return 1; }
    [ -z "$version" ] && { log_error "Plugin version is required"; return 1; }

    echo "$name $version $entry"
    return 0
}

# Check a plugin's declared permissions
sdk_check_permission() {
    local manifest="$1"
    local required="$2"

    python3 -c "
import json, sys
with open('$manifest') as f:
    m = json.load(f)
perms = m.get('permissions', [])
if '$required' in perms:
    sys.exit(0)
sys.exit(1)
" 2>/dev/null
}

# Create a new plugin scaffold
sdk_init_plugin() {
    local name="$1"
    local target="${2:-plugins/community/$name}"

    if [ -z "$name" ]; then
        log_error "Usage: sdk_init_plugin <name> [target-dir]"
        return 1
    fi

    mkdir -p "$target/hooks"

    cat > "$target/plugin.json" << EOF
{
  "name": "$name",
  "version": "0.1.0",
  "description": "Plugin description",
  "author": "Your Name",
  "license": "MIT",
  "opencode": {
    "minVersion": "0.1.0"
  },
  "hooks": [],
  "permissions": [
    "read:assets"
  ],
  "dependencies": {},
  "entry": "index.sh"
}
EOF

    cat > "$target/index.sh" << 'EOF'
#!/bin/bash
set -euo pipefail

# Plugin entry point

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDK_DIR="$(cd "$SCRIPT_DIR/../../../core/plugin" && pwd)"

source "$SDK_DIR/sdk.sh"

log_info "Plugin loaded: $PLUGIN_NAME"
EOF
    chmod +x "$target/index.sh"

    cat > "$target/README.md" << EOF
# $name

Plugin description.

## Hooks

- None yet

## Permissions

- read:assets
EOF

    log_info "Plugin scaffold created at $target"
}
