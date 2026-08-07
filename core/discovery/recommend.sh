#!/bin/bash
set -euo pipefail

# Recommendation Engine
# Recommends assets based on tags, dependencies, and popularity
# Usage: ./core/discovery/recommend.sh [--type skill|agent|prompt] [--category <cat>] [--limit N]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
ASSETS_DIR="$ROOT_DIR/assets"

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

ASSET_TYPE=""
CATEGORY=""
LIMIT=10
SEED=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --type) ASSET_TYPE="$2"; shift 2 ;;
        --category) CATEGORY="$2"; shift 2 ;;
        --limit) LIMIT="$2"; shift 2 ;;
        --seed) SEED="$2"; shift 2 ;;
        --type=*) ASSET_TYPE="${1#*=}"; shift ;;
        --category=*) CATEGORY="${1#*=}"; shift ;;
        --limit=*) LIMIT="${1#*=}"; shift ;;
        --seed=*) SEED="${1#*=}"; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

echo "Generating recommendations..."
echo ""

python3 - "$ASSET_TYPE" "$CATEGORY" "$LIMIT" "$SEED" "$ASSETS_DIR" << 'PYEOF'
import json, os, sys, glob
from collections import Counter, defaultdict

asset_type, category, limit, seed, assets_dir = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]

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
    if atype == "skills":
        atype = "skill"
    return {
        "name": name,
        "type": atype,
        "category": meta.get("category", ""),
        "tags": set(meta.get("tags", [])),
        "deps": {d.get("name", "") for d in meta.get("dependencies", [])},
        "required_by": 0,
    }

assets = {}
for path in sorted(glob.glob(f"{assets_dir}/skills/*/*/metadata.json") +
                   glob.glob(f"{assets_dir}/agents/*/*/metadata.json") +
                   glob.glob(f"{assets_dir}/prompts/*/metadata.json")):
    info = asset_info(path)
    assets[info["name"]] = info

# Count how many assets depend on each asset (popularity)
for name, info in assets.items():
    for dep in info["deps"]:
        if dep in assets:
            assets[dep]["required_by"] += 1

# Build tag -> assets map
tag_index = defaultdict(list)
for name, info in assets.items():
    for tag in info["tags"]:
        tag_index[tag].append(name)

candidates = []
for name, info in assets.items():
    if asset_type and info["type"] != asset_type:
        continue
    if category and info["category"] != category:
        continue

    score = info["required_by"] * 2

    # Seed-based relevance: shared tags with the seed asset
    if seed and seed in assets:
        shared = info["tags"] & assets[seed]["tags"]
        score += len(shared) * 3

    candidates.append((score, info["name"], info["type"], info["category"], len(info["tags"])))

candidates.sort(key=lambda c: (-c[0], -c[4], c[1]))

print(f"{'Score':<6} {'Name':<32} {'Type':<10} Category")
print("-" * 70)
for score, name, atype, cat, _ in candidates[:limit]:
    print(f"{score:<6} {name:<32} {atype:<10} {cat}")
PYEOF

echo ""
log_info "Recommendations complete!"
