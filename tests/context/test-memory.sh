#!/bin/bash
set -euo pipefail

# Session memory tests
# Verifies context/memory/memory.py: init, save, get, search, sessions, stats, healthcheck

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MEMORY="$ROOT_DIR/context/memory/memory.py"
TEST_DIR="$(mktemp -d)"
export KIT_MEMORY_DIR="$TEST_DIR"

TOTAL=0
PASSED=0
FAILED=0

cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

run_test() {
    local name="$1"
    local cmd="$2"
    TOTAL=$((TOTAL + 1))
    if eval "$cmd" > /dev/null 2>&1; then
        PASSED=$((PASSED + 1))
        echo -e "${GREEN}✓${NC} $name"
    else
        FAILED=$((FAILED + 1))
        echo -e "${RED}✗${NC} $name"
    fi
}

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Running session memory tests..."
echo ""

run_test "memory.py exists" "[ -f '$MEMORY' ]"
run_test "memory.py is executable" "[ -x '$MEMORY' ]"
run_test "init creates a database" "python3 '$MEMORY' init && [ -f '$TEST_DIR/memory.db' ]"

printf 'O usuario prefere TypeScript com Fastify e vitest.' \
    | python3 "$MEMORY" save --key tech-stack --session projeto-x > /dev/null 2>&1
printf 'Endpoint de relatorio usa geracao PDF server-side.' \
    | python3 "$MEMORY" save --key report-note --session projeto-x > /dev/null 2>&1

run_test "save stores a memory" "python3 '$MEMORY' get --key tech-stack | grep -q 'tech-stack'"
run_test "get returns the stored content" "python3 '$MEMORY' get --key report-note | grep -q 'PDF'"
run_test "search finds content by term" "python3 '$MEMORY' search vitest | grep -q 'tech-stack'"
run_test "search respects session filter" "python3 '$MEMORY' search vitest --session inexistente | grep -q '\[\]'"
run_test "sessions lists session with count" "python3 '$MEMORY' sessions | grep -q 'projeto-x'"
run_test "stats reports memories" "python3 '$MEMORY' stats | grep -q '\\\"memories\\\": 2'"
run_test "healthcheck reports consistent FTS" "python3 '$MEMORY' healthcheck | grep -q 'fts_consistent'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0
