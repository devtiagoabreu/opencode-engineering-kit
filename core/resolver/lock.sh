#!/bin/bash
set -euo pipefail

# Lock File Script
# Generates a lock file with resolved dependency versions
# Usage: ./core/resolver/lock.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
ASSETS_DIR="$ROOT_DIR/assets"
LOCK_FILE="$SCRIPT_DIR/lockfile.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo "Generating lock file..."
echo ""

python3 - "$ASSETS_DIR" "$LOCK_FILE" << 'PYEOF'
import json, os, sys, glob, datetime

assets_dir, lock_file = sys.argv[1], sys.argv[2]

metadata_files = (glob.glob(f"{assets_dir}/skills/*/*/metadata.json") +
                  glob.glob(f"{assets_dir}/agents/*/*/metadata.json") +
                  glob.glob(f"{assets_dir}/agents/*/metadata.json") +
                  glob.glob(f"{assets_dir}/prompts/*/metadata.json") +
                  glob.glob(f"{assets_dir}/bundles/*/bundle.json") +
                  glob.glob(f"{assets_dir}/compositions/*/composition.json") +
                  glob.glob(f"{assets_dir}/prompt-chains/*/chain.json"))

# Build the set of known asset names for dependency resolution
known_names = set()
for metadata in metadata_files:
    asset_dir = os.path.dirname(metadata)
    known_names.add(os.path.basename(asset_dir).lower())

assets = {}
count = 0
unresolved = 0
for metadata in sorted(metadata_files):
    asset_dir = os.path.dirname(metadata)
    asset_name = os.path.basename(asset_dir)
    rel = os.path.relpath(asset_dir, assets_dir)
    asset_type = rel.split(os.sep)[0]
    with open(metadata) as f:
        meta = json.load(f)
    deps = [{"name": d.get("name", ""), "version": d.get("version", "*")}
            for d in meta.get("dependencies", [])]

    # Resolve: every declared dependency must exist in the kit
    resolved = all(d["name"].lower() in known_names for d in deps)
    if not resolved:
        unresolved += 1

    # Persist resolution state back into the metadata
    if meta.get("dependencies_resolved") != resolved:
        meta["dependencies_resolved"] = resolved
        with open(metadata, "w") as f:
            json.dump(meta, f, indent=2)
            f.write("\n")

    assets[f"{asset_type}/{asset_name}"] = {
        "name": asset_name,
        "type": asset_type,
        "version": meta.get("version", "0.0.0"),
        "dependencies": deps,
        "resolved": resolved,
    }
    count += 1

out = {
    "version": "1.0.0",
    "generated": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "assets": assets,
}
with open(lock_file, "w") as f:
    json.dump(out, f, indent=2)
    f.write("\n")
print(f"Lock file generated with {count} assets ({count - unresolved} resolved)")
PYEOF

log_info "Lock file generated: $LOCK_FILE"
