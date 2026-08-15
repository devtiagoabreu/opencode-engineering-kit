#!/bin/bash
set -euo pipefail

# Generate meta.json for every vault entry in assets/vault/.
# Each entry: <category>/<skill>/content.md + meta.json (sha256, tokens, source).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
VAULT_DIR="$ROOT_DIR/assets/vault"
POINTER="$ROOT_DIR/core/discovery/pointer.sh"

if [ ! -d "$VAULT_DIR" ]; then
    echo "vault dir not found: $VAULT_DIR"
    exit 1
fi

find "$VAULT_DIR" -name content.md -type f | while read -r content; do
    entry_dir="$(dirname "$content")"
    rel="$(realpath --relative-to="$VAULT_DIR" "$entry_dir")"
    skill="$(basename "$entry_dir")"
    sha=$(sha256sum "$content" | awk '{print $1}')
    tokens=$("$POINTER" tokens "$content")
    size=$(wc -c < "$content")
    cat > "$entry_dir/meta.json" << EOF
{
  "skill": "$skill",
  "vault_path": "$rel",
  "sha256": "$sha",
  "tokens_estimate": $tokens,
  "bytes": $size,
  "curated": true,
  "content_format": "markdown"
}
EOF
    echo "  - $rel ($tokens tokens)"
done

echo "vault meta written"
