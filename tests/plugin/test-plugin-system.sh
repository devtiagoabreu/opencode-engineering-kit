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

# Test loader detects example plugin
run_test "loader detects asset-linter" "bash -c '$ROOT_DIR/core/plugin/loader.sh 2>&1 | grep -q asset-linter'"

# Test loader --check passes
run_test "loader --check passes" "bash '$ROOT_DIR/core/plugin/loader.sh' --check"

# Test sdk.sh exists
run_test "sdk.sh exists" "[ -f '$ROOT_DIR/core/plugin/sdk.sh' ]"

# Test sdk validates valid manifest
run_test "sdk validates valid manifest" "bash -c 'source $ROOT_DIR/core/plugin/sdk.sh && sdk_validate_manifest $ROOT_DIR/plugins/community/asset-linter/plugin.json | grep -q asset-linter'"

# Test hooks.sh exists
run_test "hooks.sh exists" "[ -f '$ROOT_DIR/core/plugin/hooks.sh' ]"

# Test hooks.sh --list
run_test "hooks.sh --list runs" "bash -c '$ROOT_DIR/core/plugin/hooks.sh --list 2>&1 | grep -q before-validate'"

# Test hooks.sh runs before-validate handler
run_test "hooks.sh before-validate runs" "bash -c '$ROOT_DIR/core/plugin/hooks.sh before-validate assets/skills/devops/docker-best-practices 2>&1 | grep -q asset-linter'"

# Test hooks.sh --describe
run_test "hooks.sh --describe" "bash -c '$ROOT_DIR/core/plugin/hooks.sh --describe before-validate 2>&1 | grep -q before'"

# Test hooks.sh fails on kebab-case violation
run_test "hooks.sh rejects bad name" "bash -c '! $ROOT_DIR/core/plugin/hooks.sh before-validate assets/skills/Bad_Asset 2>&1 | grep -q PASSES'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0