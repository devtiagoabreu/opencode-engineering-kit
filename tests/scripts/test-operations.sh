#!/bin/bash
set -euo pipefail

# Test Operations Scripts
# Tests for typecheck, monitor, backup, and deploy scripts

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

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

echo "Testing Operations Scripts..."
echo ""

# Test typecheck script
run_test "typecheck.sh exists" "[ -f '$ROOT_DIR/scripts/typecheck.sh' ]"
run_test "typecheck.sh is executable" "[ -x '$ROOT_DIR/scripts/typecheck.sh' ]"
run_test "typecheck passes" "bash '$ROOT_DIR/scripts/typecheck.sh'"

# Test monitor script
run_test "monitor.sh exists" "[ -f '$ROOT_DIR/scripts/monitor.sh' ]"
run_test "monitor.sh is executable" "[ -x '$ROOT_DIR/scripts/monitor.sh' ]"
run_test "monitor runs" "bash -c '$ROOT_DIR/scripts/monitor.sh 2>&1 | grep -q \"Health Monitor\"'"

# Test backup script
run_test "backup.sh exists" "[ -f '$ROOT_DIR/scripts/backup.sh' ]"
run_test "backup.sh is executable" "[ -x '$ROOT_DIR/scripts/backup.sh' ]"
run_test "backup creates archive" "bash -c 'OUT=\$(mktemp -d); $ROOT_DIR/scripts/backup.sh --output \$OUT > /dev/null 2>&1; ls \$OUT/opencode-kit-*.tar.gz | head -1 | grep -q tar.gz'"

# Test deploy script
run_test "deploy.sh exists" "[ -f '$ROOT_DIR/scripts/deploy.sh' ]"
run_test "deploy.sh is executable" "[ -x '$ROOT_DIR/scripts/deploy.sh' ]"
run_test "deploy.sh has valid syntax" "bash -n '$ROOT_DIR/scripts/deploy.sh'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0
