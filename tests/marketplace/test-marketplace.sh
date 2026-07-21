#!/bin/bash
set -euo pipefail

# Test Marketplace
# Tests for the marketplace scripts

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

echo "Testing Marketplace..."
echo ""

# Test install script exists
run_test "install.sh exists" "[ -f '$ROOT_DIR/core/marketplace/install.sh' ]"

# Test install script is executable
run_test "install.sh is executable" "[ -x '$ROOT_DIR/core/marketplace/install.sh' ]"

# Test search script exists
run_test "search.sh exists" "[ -f '$ROOT_DIR/core/marketplace/search.sh' ]"

# Test search script is executable
run_test "search.sh is executable" "[ -x '$ROOT_DIR/core/marketplace/search.sh' ]"

# Test search for docker
run_test "search for docker" "bash -c '$ROOT_DIR/core/marketplace/search.sh docker 2>&1 | grep -q docker-best-practices'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0