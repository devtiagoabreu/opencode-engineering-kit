#!/bin/bash
set -euo pipefail

# Manifest Generator
# Writes core/registry/manifest.json with a declarative snapshot of the kit:
# version, commit, asset counts, index checksums and provenance registry size.
#
# Usage: ./scripts/generate-manifest.sh

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - "$ROOT_DIR" << 'PYEOF'
import json, os, sys, hashlib, datetime, subprocess

root = sys.argv[1]

def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()

def count_files(glob_dir, suffix):
    if not os.path.isdir(glob_dir):
        return 0
    return sum(
        f.endswith(suffix) and os.path.isfile(os.path.join(dp, f))
        for dp, _, fs in os.walk(glob_dir) for f in fs
    )

def git_commit(root):
    try:
        return subprocess.run(
            ["git", "-C", root, "rev-parse", "--short", "HEAD"],
            capture_output=True, text=True, check=True,
        ).stdout.strip()
    except Exception:
        return "unknown"

indices = {}
for rel in [
    "core/discovery/index/skills.txt",
    "core/discovery/index/agents.txt",
    "core/registry/index/skills.txt",
    "core/registry/index/agents.txt",
    "core/resolver/lockfile.json",
]:
    p = os.path.join(root, rel)
    if os.path.isfile(p):
        indices[rel] = sha256(p)

provenance = os.path.join(root, "context/provenance.md")
manifest = {
    "schema_version": "1.0.0",
    "version": "0.1.0",
    "commit": git_commit(root),
    "generated": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
    "counts": {
        "skills": count_files(os.path.join(root, "assets/skills"), "SKILL.md"),
        "agents": count_files(os.path.join(root, "assets/agents"), ".md"),
        "prompts": count_files(os.path.join(root, "assets/prompts"), ".md"),
        "templates": count_files(os.path.join(root, "assets/templates"), ".md"),
        "context_files": count_files(os.path.join(root, "context"), ".md"),
    },
    "provenance_sha256": sha256(provenance) if os.path.isfile(provenance) else None,
    "index_sha256": indices,
}

out = os.path.join(root, "core/registry/manifest.json")
with open(out, "w") as f:
    json.dump(manifest, f, indent=2)
    f.write("\n")

print(f"manifest written: {out}")
print(f"  commit={manifest['commit']} skills={manifest['counts']['skills']} agents={manifest['counts']['agents']}")
PYEOF
