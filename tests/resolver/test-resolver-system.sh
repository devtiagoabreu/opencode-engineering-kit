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
run_test "resolve docker skill" "$ROOT_DIR/core/resolver/resolve.sh assets/skills/devops/docker-best-practices | grep -q 'Dependency resolution'"

# Test graph generation
run_test "generate dependency graph" "$ROOT_DIR/core/resolver/graph.sh | grep -q 'Dependency Graph'"

# Test parser script exists
run_test "parser.sh exists" "[ -f '$ROOT_DIR/core/resolver/parser.sh' ]"

# Test parser script is executable
run_test "parser.sh is executable" "[ -x '$ROOT_DIR/core/resolver/parser.sh' ]"

# Test parser validates all dependencies
run_test "parser validates dependencies" "$ROOT_DIR/core/resolver/parser.sh | grep -q 'All dependencies are resolvable'"

# Test lock script exists
run_test "lock.sh exists" "[ -f '$ROOT_DIR/core/resolver/lock.sh' ]"

# Test lock script is executable
run_test "lock.sh is executable" "[ -x '$ROOT_DIR/core/resolver/lock.sh' ]"

# Test lock generates a valid lock file
run_test "lock generates valid lockfile" "bash -c '$ROOT_DIR/core/resolver/lock.sh > /dev/null 2>&1 && python3 -m json.tool $ROOT_DIR/core/resolver/lockfile.json > /dev/null 2>&1'"

# Test lockfile resolves all assets
run_test "lockfile resolves all assets" "bash -c 'python3 -c \"import json; d=json.load(open(\\\"$ROOT_DIR/core/resolver/lockfile.json\\\")); assert all(a[\\\"resolved\\\"] for a in d[\\\"assets\\\"].values())\"'"

# Test metadata dependencies_resolved is set
run_test "metadata marks dependencies resolved" "bash -c 'python3 -c \"import json; m=json.load(open(\\\"$ROOT_DIR/assets/skills/frontend/react-patterns/metadata.json\\\")); assert m[\\\"dependencies_resolved\\\"] is True\"'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0