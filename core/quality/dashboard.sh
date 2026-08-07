#!/bin/bash
set -euo pipefail

# Quality Dashboard Script
# Generate a quality dashboard report (JSON + HTML)
#
# Usage:
#   ./core/quality/dashboard.sh                    # JSON to stdout, HTML to core/quality/
#   ./core/quality/dashboard.sh --output <file>    # Write JSON report
#   ./core/quality/dashboard.sh --html <file>      # Write HTML report

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
GENERATOR="$ROOT_DIR/scripts/quality_dashboard.py"

OUTPUT="${ROOT_DIR}/core/quality/quality-report.json"
HTML="${ROOT_DIR}/core/quality/dashboard.html"
WITH_TESTS=0

while [ $# -gt 0 ]; do
    case "$1" in
        --output) OUTPUT="$2"; shift 2 ;;
        --html) HTML="$2"; shift 2 ;;
        --with-tests) WITH_TESTS=1; shift ;;
        --stdout-only) OUTPUT=""; shift ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

ARGS=(--root "$ROOT_DIR")
[ -n "$OUTPUT" ] && ARGS+=(--output "$OUTPUT")
[ -n "$HTML" ] && ARGS+=(--html "$HTML")
[ "$WITH_TESTS" = "1" ] && ARGS+=(--with-tests)

python3 "$GENERATOR" "${ARGS[@]}"
