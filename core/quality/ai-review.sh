#!/bin/bash
set -euo pipefail

# AI Review Script
# Run an AI-assisted quality review over kit assets and produce a report
#
# Usage:
#   ./core/quality/ai-review.sh                     # Review all assets
#   ./core/quality/ai-review.sh --asset <path>       # Review one asset
#   ./core/quality/ai-review.sh --output <file.json> # Write JSON report
#   ./core/quality/ai-review.sh --json               # Print raw JSON

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
REVIEWER="$ROOT_DIR/scripts/quality_review.py"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

ASSET=""
OUTPUT=""
JSON_FLAG=0

while [ $# -gt 0 ]; do
    case "$1" in
        --asset) ASSET="$2"; shift 2 ;;
        --output) OUTPUT="$2"; shift 2 ;;
        --json) JSON_FLAG=1; shift ;;
        *) log_error "Unknown option: $1"; exit 1 ;;
    esac
done

ARGS=(--root "$ROOT_DIR")
[ -n "$ASSET" ] && ARGS+=(--asset "$ASSET")
[ -n "$OUTPUT" ] && ARGS+=(--output "$OUTPUT")
[ "$JSON_FLAG" = "1" ] && ARGS+=(--json)

python3 "$REVIEWER" "${ARGS[@]}"
