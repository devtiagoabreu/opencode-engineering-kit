#!/bin/bash
set -euo pipefail

# Resolve Script
# Resolve dependencies for an asset

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

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
    echo "Usage: $0 <asset-path>"
    echo "Example: $0 assets/skills/devops/docker-best-practices"
    exit 1
fi

ASSET_PATH="$1"

# Check if asset exists
if [ ! -d "$ROOT_DIR/$ASSET_PATH" ]; then
    log_error "Asset not found: $ASSET_PATH"
    exit 1
fi

echo "Resolving dependencies for: $ASSET_PATH"
echo ""

# Check if metadata.json exists
if [ ! -f "$ROOT_DIR/$ASSET_PATH/metadata.json" ]; then
    log_warn "No metadata.json found for $ASSET_PATH"
    log_info "Dependencies cannot be resolved without metadata"
    exit 0
fi

# Resolve dependencies from metadata.json
log_info "Resolving dependencies from metadata.json..."
metadata_deps="$(python3 -c "
import json, sys
with open('$ROOT_DIR/$ASSET_PATH/metadata.json') as f:
    meta = json.load(f)
for d in meta.get('dependencies', []):
    print(d.get('name', ''), d.get('version', '*'))
" 2>/dev/null || true)"

if [ -n "$metadata_deps" ]; then
    while read -r dep_name dep_version; do
        [ -z "$dep_name" ] && continue
        log_info "  - $dep_name ($dep_version)"

        found=false
        for dir in "$ROOT_DIR"/assets/skills/*/"$dep_name"; do
            if [ -d "$dir" ]; then
                found=true
                break
            fi
        done

        if [ "$found" = false ]; then
            log_warn "    Dependency not found: $dep_name"
        fi
    done <<< "$metadata_deps"
fi

# Check if SKILL.md exists
if [ -f "$ROOT_DIR/$ASSET_PATH/SKILL.md" ]; then
    # Extract dependencies from SKILL.md
    if grep -q "dependencies:" "$ROOT_DIR/$ASSET_PATH/SKILL.md"; then
        log_info "Dependencies found in SKILL.md"
        grep -A 10 "dependencies:" "$ROOT_DIR/$ASSET_PATH/SKILL.md" | tail -n +2 | while read -r line; do
            if echo "$line" | grep -q "name:"; then
                dep_name=$(echo "$line" | sed 's/.*name: *//' | tr -d '[:space:]')
                log_info "  - $dep_name"
                
                # Check if dependency exists
                found=false
                for dir in "$ROOT_DIR"/assets/skills/*/"$dep_name" "$ROOT_DIR"/assets/agents/"$dep_name".md; do
                    if [ -e "$dir" ]; then
                        found=true
                        break
                    fi
                done
                
                if [ "$found" = false ]; then
                    log_warn "    Dependency not found: $dep_name"
                fi
            fi
        done
    fi
fi

echo ""
log_info "Dependency resolution complete!"