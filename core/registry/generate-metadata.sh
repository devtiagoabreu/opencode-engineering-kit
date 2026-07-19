#!/usr/bin/env bash
# Script: generate-metadata.sh
# Description: Generate metadata.json for an asset
# Usage: ./core/registry/generate-metadata.sh <asset-path>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check arguments
if [ $# -eq 0 ]; then
    log_error "Usage: $0 <asset-path>"
    exit 1
fi

ASSET_PATH="$1"

# Check if asset exists
if [ ! -d "$ASSET_PATH" ]; then
    log_error "Asset not found: $ASSET_PATH"
    exit 1
fi

# Check if metadata already exists
if [ -f "$ASSET_PATH/metadata.json" ]; then
    log_warn "metadata.json already exists in $ASSET_PATH"
    exit 0
fi

# Generate metadata
cat > "$ASSET_PATH/metadata.json" << EOF
{
  "schema_version": "1.0.0",
  "generated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "validated_at": null,
  "validation_passed": false,
  "warnings": [],
  "dependencies_resolved": false
}
EOF

log_info "Generated metadata.json for $ASSET_PATH"