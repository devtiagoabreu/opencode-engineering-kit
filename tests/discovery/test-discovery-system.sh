#!/bin/bash
set -euo pipefail

# Test Discovery System
# Tests for the discovery scripts

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
    return 0
}

echo "Testing Discovery System..."
echo ""

# Test search script exists
run_test "search.sh exists" "[ -f '$ROOT_DIR/core/discovery/search.sh' ]"

# Test search script is executable
run_test "search.sh is executable" "[ -x '$ROOT_DIR/core/discovery/search.sh' ]"

# Test filter script exists
run_test "filter.sh exists" "[ -f '$ROOT_DIR/core/discovery/filter.sh' ]"

# Test filter script is executable
run_test "filter.sh is executable" "[ -x '$ROOT_DIR/core/discovery/filter.sh' ]"

# Test index script exists
run_test "index.sh exists" "[ -f '$ROOT_DIR/core/discovery/index.sh' ]"

# Test index script is executable
run_test "index.sh is executable" "[ -x '$ROOT_DIR/core/discovery/index.sh' ]"

# Test search for docker
run_test "search for docker" "bash -c '$ROOT_DIR/core/discovery/search.sh docker 2>&1 | grep -q docker-best-practices'"

# Test filter by category
run_test "filter by devops category" "bash -c '$ROOT_DIR/core/discovery/filter.sh --category=devops 2>&1 | grep -q docker-best-practices'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0