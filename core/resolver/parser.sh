#!/bin/bash
set -euo pipefail

# Parser Script
# Parses dependency declarations from all asset metadata files
# Usage: ./core/resolver/parser.sh [asset-name]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
ASSETS_DIR="$ROOT_DIR/assets"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

ASSET_FILTER="${1:-}"

declare -A FOUND

echo "Parsing dependency declarations..."
echo ""

# Collect all assets
ASSETS=()
while IFS= read -r metadata; do
    ASSETS+=("$(dirname "$metadata")")
done < <(find "$ASSETS_DIR" -name "metadata.json" -type f | sort)

TOTAL=0

for asset_dir in "${ASSETS[@]}"; do
    asset_type="$(basename "$(dirname "$asset_dir")")"
    asset_name="$(basename "$asset_dir")"

    if [ -n "$ASSET_FILTER" ] && [ "$asset_name" != "$ASSET_FILTER" ]; then
        continue
    fi

    TOTAL=$((TOTAL + 1))
    FOUND["$asset_name"]="$asset_dir"

    deps="$(python3 -c "
import json,sys
with open('$asset_dir/metadata.json') as f:
    meta=json.load(f)
for d in meta.get('dependencies', []):
    print(d.get('name',''))
" 2>/dev/null || true)"

    if [ -z "$deps" ]; then
        continue
    fi

    echo "[$asset_type] $asset_name"
    while IFS= read -r dep; do
        [ -z "$dep" ] && continue
        echo "  -> $dep"
    done <<< "$deps"
    echo ""
done

echo ""
echo "=== Parser Summary ==="
echo "Assets parsed: $TOTAL"

# Check for missing dependencies
echo ""
echo "=== Missing Dependency Check ==="
MISSING_COUNT=0
while IFS= read -r metadata; do
    asset_dir="$(dirname "$metadata")"
    asset_name="$(basename "$asset_dir")"

    deps="$(python3 -c "
import json
with open('$metadata') as f:
    meta=json.load(f)
for d in meta.get('dependencies', []):
    print(d.get('name',''))
" 2>/dev/null || true)"

    while IFS= read -r dep; do
        [ -z "$dep" ] && continue
        if [ -z "${FOUND["$dep"]:-}" ]; then
            log_error "Missing dependency: $dep (required by $asset_name)"
            MISSING_COUNT=$((MISSING_COUNT + 1))
        fi
    done <<< "$deps"
done < <(find "$ASSETS_DIR" -name "metadata.json" -type f)

if [ "$MISSING_COUNT" -gt 0 ]; then
    log_error "$MISSING_COUNT missing dependencies detected"
    exit 1
fi

log_info "All dependencies are resolvable!"
exit 0
