#!/bin/bash
set -euo pipefail

# Test Dependency Resolution
# Tests for the resolver scripts

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

echo "Testing Dependency Resolution..."
echo ""

# Test resolve script exists
run_test "resolve.sh exists" "[ -f '$ROOT_DIR/core/resolver/resolve.sh' ]"

# Test resolve script is executable
run_test "resolve.sh is executable" "[ -x '$ROOT_DIR/core/resolver/resolve.sh' ]"

# Test graph script exists
run_test "graph.sh exists" "[ -f '$ROOT_DIR/core/resolver/graph.sh' ]"

# Test graph script is executable
run_test "graph.sh is executable" "[ -x '$ROOT_DIR/core/resolver/graph.sh' ]"

# Test validate script exists
run_test "validate.sh exists" "[ -f '$ROOT_DIR/core/resolver/validate.sh' ]"

# Test validate script is executable
run_test "validate.sh is executable" "[ -x '$ROOT_DIR/core/resolver/validate.sh' ]"

# Test resolve for docker skill
run_test "resolve docker skill" "$ROOT_DIR/core/resolver/resolve.sh skills/devops/docker-best-practices | grep -q 'Dependency resolution'"

# Test graph generation
run_test "generate dependency graph" "$ROOT_DIR/core/resolver/graph.sh | grep -q 'Dependency Graph'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0