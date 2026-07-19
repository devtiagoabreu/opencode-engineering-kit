#!/bin/bash
set -euo pipefail

# Test runner for OpenCode Engineering Kit
# Runs all tests and reports results

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TESTS_DIR="$PROJECT_ROOT/tests"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TOTAL=0
PASSED=0
FAILED=0

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

run_test() {
    local test_file="$1"
    local test_name
    test_name=$(basename "$test_file" .sh)
    
    ((TOTAL++))
    
    echo "Running: $test_name"
    if bash "$test_file" 2>&1; then
        ((PASSED++))
        echo -e "  ${GREEN}PASSED${NC}"
    else
        ((FAILED++))
        echo -e "  ${FAILED} FAILED${NC}"
    fi
    echo
}

main() {
    log "Running all tests..."
    echo
    
    # Find and run all test scripts
    while IFS= read -r -d '' test_file; do
        run_test "$test_file"
    done < <(find "$TESTS_DIR" -name "test-*.sh" -type f -print0 | sort -z)
    
    echo "============================================"
    echo "Test Results: $PASSED passed, $FAILED failed, $TOTAL total"
    echo "============================================"
    
    if (( FAILED > 0 )); then
        error "$FAILED test(s) failed"
        exit 1
    fi
    
    log "All tests passed!"
    exit 0
}

main "$@"