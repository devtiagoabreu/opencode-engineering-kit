#!/bin/bash
set -euo pipefail

# Version Bump Script
# Bumps the version of an asset in its metadata.json
# Usage: ./core/version/bump.sh <asset-name> [patch|minor|major]

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
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

if [ $# -lt 1 ]; then
    echo "Usage: $0 <asset-name> [patch|minor|major]"
    echo "Example: $0 docker-best-practices minor"
    exit 1
fi

ASSET_NAME="$1"
BUMP_TYPE="${2:-patch}"

case "$BUMP_TYPE" in
    patch|minor|major) ;;
    *) log_error "Invalid bump type: $BUMP_TYPE (use patch, minor, or major)"; exit 1 ;;
esac

# Locate the asset metadata
METADATA="$(find "$ASSETS_DIR" -name "metadata.json" -type f -path "*/$ASSET_NAME/metadata.json" | head -1)"

if [ -z "$METADATA" ]; then
    log_error "Asset not found: $ASSET_NAME"
    exit 1
fi

echo "Bumping $ASSET_NAME ($BUMP_TYPE)..."
echo ""

python3 - "$METADATA" "$BUMP_TYPE" << 'PYEOF'
import json, sys

metadata, bump_type = sys.argv[1], sys.argv[2]

with open(metadata) as f:
    meta = json.load(f)

version = meta.get("version", "0.1.0")
major, minor, patch = (int(x) for x in version.split("."))

if bump_type == "major":
    major += 1
    minor, patch = 0, 0
elif bump_type == "minor":
    minor += 1
    patch = 0
else:
    patch += 1

new_version = f"{major}.{minor}.{patch}"
meta["version"] = new_version
meta["validated_at"] = None
meta["validation_passed"] = False

with open(metadata, "w") as f:
    json.dump(meta, f, indent=2)
    f.write("\n")

print(f"Bumped {metadata}")
print(f"  {version} -> {new_version}")
PYEOF

echo ""
log_info "Version bump complete!"
