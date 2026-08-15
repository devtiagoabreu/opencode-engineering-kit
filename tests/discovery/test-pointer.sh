#!/bin/bash
set -euo pipefail

# SkillPointer + vault tests
# Verifies core/discovery/pointer.sh: resolve, vault, tokens, list, is-pointer,
# plus vault meta generation and pointer manifest counts.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
POINTER="$ROOT_DIR/core/discovery/pointer.sh"
MANIFEST="$ROOT_DIR/core/registry/manifest.json"

TOTAL=0
PASSED=0
FAILED=0

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

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

echo "Running SkillPointer/vault tests..."
echo ""

run_test "pointer.sh exists and is executable" "[ -x '$POINTER' ]"
run_test "pointer.sh lists vault entries" "'$POINTER' list | grep -q 'repo-to-llm'"
run_test "pointer.sh lists only pointer skills with --pointer" "[ \"\$('$POINTER' list --pointer | wc -l)\" -ge 3 ]"
run_test "pointer.sh is-pointer detects pointer skills" "'$POINTER' is-pointer repo-to-llm | grep -q true"
run_test "pointer.sh is-pointer fails for non-pointer skills" "! '$POINTER' is-pointer tdd 2>/dev/null"
run_test "pointer.sh resolve returns vault content" "'$POINTER' resolve repo-to-llm | grep -q 'vault entry'"
run_test "pointer.sh resolve rejects unknown skill" "! '$POINTER' resolve nao-existe-xyz 2>/dev/null"
run_test "pointer.sh vault reports token estimate" "'$POINTER' vault skill-spector | grep -q 'token_estimate'"
run_test "pointer.sh tokens counts a file" "[ \"\$('$POINTER' tokens '$ROOT_DIR/assets/vault/tools/repo-to-llm/content.md')\" -gt 100 ]"
run_test "vault meta.json generated for all entries" "for d in '$ROOT_DIR'/assets/vault/*/*/; do [ -f \"\$d/meta.json\" ] || exit 1; done"
run_test "vault meta contains checksum" "python3 -c \"import json; json.load(open('$ROOT_DIR/assets/vault/tools/repo-to-llm/meta.json'))['sha256']\""
run_test "manifest reports pointer skills" "python3 -c \"import json; assert json.load(open('$MANIFEST'))['counts']['pointer_skills'] >= 3\""
run_test "manifest reports vault entries" "python3 -c \"import json; assert json.load(open('$MANIFEST'))['counts']['vault_entries'] >= 3\""
run_test "pointer skills have valid schema fields" "grep -q 'pointer: true' '$ROOT_DIR/assets/skills/tools/repo-to-llm/SKILL.md' && grep -q 'vault:' '$ROOT_DIR/assets/skills/tools/repo-to-llm/SKILL.md'"

echo ""
echo "=== Test Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    exit 1
fi

exit 0
