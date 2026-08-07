#!/bin/bash
set -euo pipefail

# Test Quality Tools
# Tests for the AI review and dashboard scripts

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Counters
TOTAL=0
PASSED=0
FAILED=0

run_test() {
    local test_name="$1"
    local test_command="$2"

    TOTAL=$((TOTAL + 1))

    if eval "$test_command" > /dev/null 2>&1; then
        PASSED=$((PASSED + 1))
        echo -e "${GREEN}✓${NC} $test_name"
    else
        FAILED=$((FAILED + 1))
        echo -e "${RED}✗${NC} $test_name"
    fi
}

echo "Testing Quality Tools..."
echo ""

# Test ai-review script exists
run_test "ai-review.sh exists" "[ -f '$ROOT_DIR/core/quality/ai-review.sh' ]"

# Test ai-review script is executable
run_test "ai-review.sh is executable" "[ -x '$ROOT_DIR/core/quality/ai-review.sh' ]"

# Test ai-review runs for one asset
run_test "ai-review reviews single asset" "bash -c '$ROOT_DIR/core/quality/ai-review.sh --asset assets/skills/devops/docker-best-practices 2>&1 | grep -q AI-ASSISTED'"

# Test ai-review produces JSON report
run_test "ai-review writes JSON report" "bash -c 'TMP=\$(mktemp); $ROOT_DIR/core/quality/ai-review.sh --output \$TMP > /dev/null 2>&1 && python3 -m json.tool \$TMP > /dev/null 2>&1'"

# Test dashboard script exists
run_test "dashboard.sh exists" "[ -f '$ROOT_DIR/core/quality/dashboard.sh' ]"

# Test dashboard script is executable
run_test "dashboard.sh is executable" "[ -x '$ROOT_DIR/core/quality/dashboard.sh' ]"

# Test dashboard produces valid JSON
run_test "dashboard produces valid JSON" "bash -c '$ROOT_DIR/core/quality/dashboard.sh --stdout-only 2>/dev/null | python3 -m json.tool > /dev/null 2>&1'"

# Test dashboard reports asset count
run_test "dashboard reports assets" "bash -c '$ROOT_DIR/core/quality/dashboard.sh --stdout-only 2>/dev/null | grep -q asset_count'"

# Test dashboard writes HTML
run_test "dashboard writes HTML" "bash -c '$ROOT_DIR/core/quality/dashboard.sh --html /tmp/opencode/dash-test.html > /dev/null 2>&1 && [ -f /tmp/opencode/dash-test.html ]'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0
