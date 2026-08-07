#!/bin/bash
set -euo pipefail

# Compatibility Matrix Script
# Generates the platform compatibility matrix from all assets
# Usage: ./core/version/compatibility.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
ASSETS_DIR="$ROOT_DIR/assets"
MATRIX_FILE="$SCRIPT_DIR/compatibility-matrix.json"

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

echo "Generating compatibility matrix..."
echo ""

python3 - "$ASSETS_DIR" "$MATRIX_FILE" << 'PYEOF'
import json, os, sys, glob, re

assets_dir, matrix_file = sys.argv[1], sys.argv[2]

def parse_frontmatter(path):
    with open(path) as f:
        content = f.read()
    m = re.match(r"^---\n(.*?)\n---", content, re.DOTALL)
    if not m:
        return {}
    front = {}
    for line in m.group(1).splitlines():
        if re.match(r"^compatible:", line):
            front["compatible"] = []
            continue
        if re.match(r"^  - ", line):
            front.setdefault("compatible", []).append(line.strip()[4:].strip())
    return front

assets = {}
for metadata in sorted(glob.glob(f"{assets_dir}/skills/*/*/metadata.json")):
    name = os.path.basename(os.path.dirname(metadata))
    with open(metadata) as f:
        meta = json.load(f)
    skill_md = os.path.join(os.path.dirname(metadata), "SKILL.md")
    front = parse_frontmatter(skill_md)
    assets[name] = {
        "type": "skill",
        "version": meta.get("version", "0.0.0"),
        "compatible": front.get("compatible", ["opencode"]),
    }

for metadata in sorted(glob.glob(f"{assets_dir}/agents/*/*/metadata.json") +
                       glob.glob(f"{assets_dir}/prompts/*/metadata.json")):
    name = os.path.basename(os.path.dirname(metadata))
    asset_type = os.path.basename(os.path.dirname(os.path.dirname(metadata)))
    with open(metadata) as f:
        meta = json.load(f)
    assets[name] = {
        "type": asset_type,
        "version": meta.get("version", "0.0.0"),
        "compatible": meta.get("compatible", ["opencode"]),
    }

out = {
    "version": "1.0.0",
    "generated": __import__("datetime").datetime.now(__import__("datetime").timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "platforms": ["opencode", "claude-code", "cursor", "copilot"],
    "assets": assets,
}
with open(matrix_file, "w") as f:
    json.dump(out, f, indent=2)
print(f"Compatibility matrix generated with {len(assets)} assets")
PYEOF

log_info "Compatibility matrix saved: $MATRIX_FILE"
