#!/bin/bash
set -euo pipefail

# Test Plugin System
# Tests for the plugin scripts

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

echo "Testing Plugin System..."
echo ""

# Test loader script exists
run_test "loader.sh exists" "[ -f '$ROOT_DIR/core/plugin/loader.sh' ]"

# Test loader script is executable
run_test "loader.sh is executable" "[ -x '$ROOT_DIR/core/plugin/loader.sh' ]"

# Test installer script exists
run_test "installer.sh exists" "[ -f '$ROOT_DIR/core/plugin/installer.sh' ]"

# Test installer script is executable
run_test "installer.sh is executable" "[ -x '$ROOT_DIR/core/plugin/installer.sh' ]"

# Test uninstaller script exists
run_test "uninstaller.sh exists" "[ -f '$ROOT_DIR/core/plugin/uninstaller.sh' ]"

# Test uninstaller script is executable
run_test "uninstaller.sh is executable" "[ -x '$ROOT_DIR/core/plugin/uninstaller.sh' ]"

# Test loader runs
run_test "loader runs" "bash -c '$ROOT_DIR/core/plugin/loader.sh 2>&1 | grep -q Loading'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0