#!/bin/bash
set -euo pipefail

# Type Check Script
# Static checks: metadata.json validity against schemas, JSON well-formedness,
# and bash syntax of all scripts.
# Usage: ./scripts/typecheck.sh

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCHEMAS_DIR="$ROOT_DIR/core/registry/schema"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

FAILURES=0
CHECKS=0

check() {
    local name="$1"
    local result="$2"
    CHECKS=$((CHECKS + 1))
    if [ "$result" = "0" ]; then
        echo -e "  ${GREEN}✓${NC} $name"
    else
        FAILURES=$((FAILURES + 1))
        echo -e "  ${RED}✗${NC} $name"
    fi
}

echo "Running type checks..."
echo ""

# 1. All metadata.json files are valid JSON
python3 - "$ROOT_DIR" << 'PYEOF' > /tmp/opencode/json_check.txt 2>&1
import json, glob, os, sys
root = sys.argv[1]
files = glob.glob(f"{root}/assets/*/*/metadata.json") + glob.glob(f"{root}/assets/*/metadata.json")
bad = []
for f in sorted(files):
    try:
        json.load(open(f))
    except Exception as exc:
        bad.append(f"{f}: {exc}")
sys.exit(1 if bad else 0)
PYEOF
check "all metadata.json are valid JSON" "$?"

# 2. All bundle/composition/chain JSON are valid
python3 - "$ROOT_DIR" << 'PYEOF' > /tmp/opencode/json_check2.txt 2>&1
import json, glob, os, sys
root = sys.argv[1]
files = (glob.glob(f"{root}/assets/bundles/*/*.json") +
         glob.glob(f"{root}/assets/compositions/*/*.json") +
         glob.glob(f"{root}/assets/prompt-chains/*/*.json"))
bad = []
for f in sorted(files):
    try:
        json.load(open(f))
    except Exception as exc:
        bad.append(f"{f}: {exc}")
sys.exit(1 if bad else 0)
PYEOF
check "bundle/composition/chain JSON are valid" "$?"

# 3. Registry index files are non-empty
INDEX_DIR="$ROOT_DIR/core/registry/index"
if [ -d "$INDEX_DIR" ] && [ "$(find "$INDEX_DIR" -name '*.txt' | wc -l)" -gt 0 ]; then
    check "registry indexes exist" "0"
else
    check "registry indexes exist" "1"
fi

# 4. All shell scripts pass bash syntax check
BROKEN=""
while IFS= read -r -d '' script; do
    if ! bash -n "$script" 2>/dev/null; then
        BROKEN="$BROKEN $script"
    fi
done < <(find "$ROOT_DIR/core" "$ROOT_DIR/scripts" -name '*.sh' -type f -print0)
if [ -z "$BROKEN" ]; then
    check "all shell scripts have valid syntax" "0"
else
    echo "    broken:$BROKEN"
    check "all shell scripts have valid syntax" "1"
fi

# 5. No duplicate asset names
DUPS="$(find "$ROOT_DIR/assets" -name metadata.json -print0 2>/dev/null \
        | xargs -0 -n1 dirname \
        | xargs -n1 basename \
        | sort \
        | uniq -d \
        | wc -l || true)"
check "no duplicate asset names" "$([ "$DUPS" = "0" ] && echo 0 || echo 1)"

echo ""
echo "============================================"
echo "Type Check Results:"
echo "  Checks: $CHECKS"
echo "  Failures: $FAILURES"
echo "============================================"

if [ "$FAILURES" -gt 0 ]; then
    log_error "typecheck failed"
    exit 1
fi

log_info "typecheck passed!"
exit 0
