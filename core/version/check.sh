#!/bin/bash
set -euo pipefail

# Version Check Script
# Parses and validates semantic versions across all assets
# Usage: ./core/version/check.sh [asset-name]

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

echo "Checking asset versions..."
echo ""

TOTAL=0
INVALID=0

check_version() {
    local asset="$1"
    local version="$2"
    TOTAL=$((TOTAL + 1))

    if ! echo "$version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
        log_error "Invalid version '$version' for $asset"
        INVALID=$((INVALID + 1))
        return 1
    fi

    major="${version%%.*}"

    if [ "$major" -eq 0 ]; then
        log_warn "$asset@$version (unstable, 0.x)"
    fi
    return 0
}

while IFS= read -r metadata; do
    asset_dir="$(dirname "$metadata")"
    asset_name="$(basename "$asset_dir")"
    asset_type="$(basename "$(dirname "$asset_dir")")"

    if [ -n "$ASSET_FILTER" ] && [ "$asset_name" != "$ASSET_FILTER" ]; then
        continue
    fi

    version="$(python3 -c "
import json
with open('$metadata') as f:
    print(json.load(f).get('version', '0.0.0'))
" 2>/dev/null || echo "0.0.0")"

    if check_version "$asset_type/$asset_name" "$version"; then
        log_info "$asset_name@$version"
    fi
done < <(find "$ASSETS_DIR" -name "metadata.json" -type f | sort)

echo ""
echo "=== Version Check Summary ==="
echo "Assets checked: $TOTAL"
echo -e "Invalid: ${RED}$INVALID${NC}"

if [ "$INVALID" -gt 0 ]; then
    log_error "$INVALID invalid version(s) found"
    exit 1
fi

log_info "All versions are valid SemVer!"
exit 0
