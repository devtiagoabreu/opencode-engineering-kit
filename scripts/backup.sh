#!/bin/bash
set -euo pipefail

# Backup Script
# Create a timestamped archive of the kit
# Usage: ./scripts/backup.sh [--output <dir>]

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="${1:-$ROOT_DIR/backups}"

if [ "${1:-}" = "--output" ]; then
    OUTPUT_DIR="$2"
fi

mkdir -p "$OUTPUT_DIR"
STAMP="$(date +%Y%m%d-%H%M%S)"
ARCHIVE="$OUTPUT_DIR/opencode-kit-$STAMP.tar.gz"

echo "Creating backup: $ARCHIVE"
tar --exclude="$ROOT_DIR/backups" \
    --exclude="$ROOT_DIR/node_modules" \
    --exclude="$ROOT_DIR/.git" \
    -czf "$ARCHIVE" \
    -C "$ROOT_DIR" \
    assets core scripts tests plugins docs README.md CHANGELOG.md LICENSE \
    AGENTS.md 2>/dev/null || tar -czf "$ARCHIVE" -C "$ROOT_DIR" . --exclude=.git --exclude=node_modules

SIZE="$(du -h "$ARCHIVE" | cut -f1)"
echo "Backup complete: $ARCHIVE ($SIZE)"

# Keep the 10 most recent backups
ls -1t "$OUTPUT_DIR"/opencode-kit-*.tar.gz 2>/dev/null | tail -n +11 | while read -r old; do
    echo "Removing old backup: $old"
    rm -f "$old"
done
