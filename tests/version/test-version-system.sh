#!/bin/bash
set -euo pipefail

# Test Version System
# Tests for the version scripts

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

# Test function
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

echo "Testing Version System..."
echo ""

# Test scripts exist and are executable
run_test "check.sh exists" "[ -f '$ROOT_DIR/core/version/check.sh' ]"
run_test "check.sh is executable" "[ -x '$ROOT_DIR/core/version/check.sh' ]"
run_test "bump.sh exists" "[ -f '$ROOT_DIR/core/version/bump.sh' ]"
run_test "bump.sh is executable" "[ -x '$ROOT_DIR/core/version/bump.sh' ]"
run_test "compatibility.sh exists" "[ -f '$ROOT_DIR/core/version/compatibility.sh' ]"
run_test "compatibility.sh is executable" "[ -x '$ROOT_DIR/core/version/compatibility.sh' ]"

# Test version check passes
run_test "version check passes" "$ROOT_DIR/core/version/check.sh | grep -q 'All versions are valid'"

# Test bump requires an asset
run_test "bump requires asset argument" "! bash -c '$ROOT_DIR/core/version/bump.sh'"

# Test compatibility matrix generates valid JSON
run_test "compatibility matrix is valid JSON" "bash -c '$ROOT_DIR/core/version/compatibility.sh > /dev/null 2>&1 && python3 -m json.tool $ROOT_DIR/core/version/compatibility-matrix.json > /dev/null 2>&1'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0
