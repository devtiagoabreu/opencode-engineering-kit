#!/bin/bash
set -euo pipefail

# Performance Tests
# Tests for performance benchmarks

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
    local threshold="$3"
    
    TOTAL=$((TOTAL + 1))
    
    # Measure execution time
    local start_time
    start_time=$(date +%s%N)
    
    if eval "$test_command" > /dev/null 2>&1; then
        local end_time
        end_time=$(date +%s%N)
        local duration=$(( (end_time - start_time) / 1000000 ))
        
        if [ "$duration" -lt "$threshold" ]; then
            PASSED=$((PASSED + 1))
            echo -e "${GREEN}✓${NC} $test_name (${duration}ms < ${threshold}ms)"
        else
            FAILED=$((FAILED + 1))
            echo -e "${RED}✗${NC} $test_name (${duration}ms >= ${threshold}ms)"
        fi
    else
        FAILED=$((FAILED + 1))
        echo -e "${RED}✗${NC} $test_name (command failed)"
    fi
}

echo "Running performance tests..."
echo ""

# Test search performance
run_test "Search script execution" "$ROOT_DIR/core/discovery/search.sh docker" 1000

# Test filter performance
run_test "Filter script execution" "$ROOT_DIR/core/discovery/filter.sh --category=devops" 1000

# Test index generation performance
run_test "Index generation" "$ROOT_DIR/core/discovery/index.sh" 2000

# Test validation performance
run_test "Validation execution" "$ROOT_DIR/core/validator/validate-all.sh" 5000

# Test dependency resolution performance
run_test "Dependency resolution" "$ROOT_DIR/core/resolver/resolve.sh skills/devops/docker-best-practices" 1000

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0