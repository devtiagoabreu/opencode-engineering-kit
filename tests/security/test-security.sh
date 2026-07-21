#!/bin/bash
set -euo pipefail

# Security Tests
# Tests for security scanning

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

echo "Running security tests..."
echo ""

# Test security scripts exist
run_test "dependency-audit.sh exists" "[ -f '$ROOT_DIR/core/security/dependency-audit.sh' ]"
run_test "secret-scan.sh exists" "[ -f '$ROOT_DIR/core/security/secret-scan.sh' ]"
run_test "vulnerability-scan.sh exists" "[ -f '$ROOT_DIR/core/security/vulnerability-scan.sh' ]"
run_test "access-control.sh exists" "[ -f '$ROOT_DIR/core/security/access-control.sh' ]"
run_test "audit-log.sh exists" "[ -f '$ROOT_DIR/core/security/audit-log.sh' ]"

# Test scripts are executable
run_test "dependency-audit.sh is executable" "[ -x '$ROOT_DIR/core/security/dependency-audit.sh' ]"
run_test "secret-scan.sh is executable" "[ -x '$ROOT_DIR/core/security/secret-scan.sh' ]"
run_test "vulnerability-scan.sh is executable" "[ -x '$ROOT_DIR/core/security/vulnerability-scan.sh' ]"
run_test "access-control.sh is executable" "[ -x '$ROOT_DIR/core/security/access-control.sh' ]"
run_test "audit-log.sh is executable" "[ -x '$ROOT_DIR/core/security/audit-log.sh' ]"

# Test secret scan runs
run_test "secret-scan.sh runs" "bash -c '$ROOT_DIR/core/security/secret-scan.sh 2>&1 | grep -q secret'"

# Test access control runs
run_test "access-control.sh runs" "bash -c '$ROOT_DIR/core/security/access-control.sh 2>&1 | grep -q access'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0