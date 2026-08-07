#!/bin/bash
set -euo pipefail

# Monitor Script
# Health check for the engineering kit
# Usage: ./scripts/monitor.sh

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

STATUS="OK"
ISSUES=0

report() {
    local level="$1"
    local message="$2"
    case "$level" in
        ok)   echo -e "  ${GREEN}✓${NC} $message" ;;
        warn) echo -e "  ${YELLOW}!${NC} $message"; STATUS="WARN"; ISSUES=$((ISSUES + 1)) ;;
        fail) echo -e "  ${RED}✗${NC} $message"; STATUS="FAIL"; ISSUES=$((ISSUES + 2)) ;;
    esac
}

echo "=== Engineering Kit Health Monitor ==="
echo "Checked: $(date -Is)"
echo ""

echo "System:"
report ok "Host: $(hostname 2>/dev/null || echo 'unknown')"
DISK_USE="$(df "$ROOT_DIR" --output=pcent 2>/dev/null | tail -1 | tr -d ' ' | tr -d '%')"
if [ -n "$DISK_USE" ] && [ "$DISK_USE" -gt 90 ]; then
    report warn "Disk usage high: ${DISK_USE}%"
else
    report ok "Disk usage: ${DISK_USE:-?}%"
fi

echo ""
echo "Repository:"
if git -C "$ROOT_DIR" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    report ok "Git repository healthy"
    BRANCH="$(git -C "$ROOT_DIR" branch --show-current)"
    DIRTY="$(git -C "$ROOT_DIR" status --porcelain | wc -l)"
    [ "$DIRTY" -gt 0 ] && report warn "$DIRTY uncommitted changes on '$BRANCH'" || report ok "Working tree clean on '$BRANCH'"
else
    report warn "Not a git repository"
fi

echo ""
echo "Assets:"
ASSET_COUNT="$(find "$ROOT_DIR/assets" -name metadata.json | wc -l)"
report ok "Assets found: $ASSET_COUNT"
if [ -f "$ROOT_DIR/core/resolver/lockfile.json" ]; then
    UNRESOLVED="$(python3 -c "
import json
d = json.load(open('$ROOT_DIR/core/resolver/lockfile.json'))
print(sum(1 for a in d['assets'].values() if not a.get('resolved')))
" 2>/dev/null || echo "?")"
    [ "$UNRESOLVED" = "0" ] && report ok "All dependencies resolved" || report warn "$UNRESOLVED unresolved dependencies"
else
    report fail "Lockfile missing"
fi

echo ""
echo "Checks:"
if [ -f "$ROOT_DIR/core/quality/quality-report.json" ]; then
    report ok "Quality report present"
else
    report warn "No quality report (run dashboard.sh)"
fi

echo ""
echo "=== Status: $STATUS ($ISSUES issue(s)) ==="

[ "$STATUS" = "FAIL" ] && exit 1
exit 0
