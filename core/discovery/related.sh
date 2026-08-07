#!/bin/bash
set -euo pipefail

# Related Assets Finder
# Finds assets related to a given asset (same category, shared tags, shared dependencies)
# Usage: ./core/discovery/related.sh <asset-name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
ASSETS_DIR="$ROOT_DIR/assets"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

if [ $# -eq 0 ]; then
    echo "Usage: $0 <asset-name>"
    echo "Example: $0 docker-best-practices"
    exit 1
fi

ASSET_NAME="$1"

METADATA="$(find "$ASSETS_DIR" -name "metadata.json" -type f -path "*/$ASSET_NAME/metadata.json" | head -1)"

if [ -z "$METADATA" ]; then
    log_warn "Asset not found: $ASSET_NAME"
    exit 1
fi

echo "Finding assets related to: $ASSET_NAME"
echo ""

python3 - "$ASSET_NAME" "$METADATA" "$ASSETS_DIR" << 'PYEOF'
import json, os, sys, glob

asset_name, metadata, assets_dir = sys.argv[1], sys.argv[2], sys.argv[3]

def read_meta(path):
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return {}

def asset_info(path):
    name = os.path.basename(os.path.dirname(path))
    meta = read_meta(path)
    rel = os.path.relpath(path, assets_dir)
    atype = rel.split(os.sep)[0]
    return {
        "name": name,
        "type": atype,
        "tags": set(meta.get("tags", [])),
        "category": meta.get("category", ""),
        "deps": {d.get("name", "") for d in meta.get("dependencies", [])},
    }

target = asset_info(metadata)
target_tags = target["tags"]
target_deps = target["deps"]

related = []
for path in sorted(glob.glob(f"{assets_dir}/skills/*/*/metadata.json") +
                   glob.glob(f"{assets_dir}/agents/*/*/metadata.json") +
                   glob.glob(f"{assets_dir}/prompts/*/metadata.json")):
    info = asset_info(path)
    if info["name"] == asset_name:
        continue

    score = 0
    reasons = []

    # Same category
    if info["category"] and info["category"] == target["category"]:
        score += 3
        reasons.append("same category")

    # Shared tags
    shared_tags = target_tags & info["tags"]
    if shared_tags:
        score += len(shared_tags)
        reasons.append("shared tags: " + ", ".join(sorted(shared_tags)))

    # Shared dependencies
    shared_deps = target_deps & info["deps"]
    if shared_deps:
        score += len(shared_deps)
        reasons.append("shared dependencies")

    # Target depends on this asset
    if info["name"] in target_deps:
        score += 4
        reasons.append("required by target")

    # This asset depends on target
    if asset_name in info["deps"]:
        score += 4
        reasons.append("depends on target")

    if score > 0:
        related.append({"name": info["name"], "type": info["type"], "score": score, "reasons": reasons})

related.sort(key=lambda r: r["score"], reverse=True)

if not related:
    print(f"No related assets found for {asset_name}")
else:
    for r in related[:10]:
        print(f"[{r['score']}] {r['name']} ({r['type']})")
        print(f"     {'; '.join(r['reasons'])}")
PYEOF

echo ""
log_info "Related assets search complete!"
