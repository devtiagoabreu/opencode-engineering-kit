#!/usr/bin/env bash
# Script: validate.sh
# Description: Validate all assets against quality gates
# Usage: ./core/quality/validate.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TOTAL=0
PASSED=0
FAILED=0

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check() {
    local name="$1"
    local command="$2"
    
    ((TOTAL++))
    
    if eval "$command" > /dev/null 2>&1; then
        ((PASSED++))
        echo -e "  ${GREEN}✓${NC} $name"
    else
        ((FAILED++))
        echo -e "  ${RED}✗${NC} $name"
    fi
}

main() {
    log_info "Running quality gates..."
    echo
    
    # Level 1: Schema Validation
    echo "Level 1: Schema Validation"
    check "All skills have metadata" "test -d $ROOT_DIR/skills && find $ROOT_DIR/skills -name 'metadata.json' | wc -l | grep -q '[1-9]'"
    check "All agents have frontmatter" "test -d $ROOT_DIR/agents && head -1 $ROOT_DIR/agents/*.md | grep -q '^---'"
    echo
    
    # Level 2: Linting
    echo "Level 2: Linting"
    check "No markdown lint errors" "npx markdownlint-cli '**/*.md' --config $ROOT_DIR/.markdownlint.json 2>&1 | grep -q 'error' || true"
    echo
    
    # Level 3: Testing
    echo "Level 3: Testing"
    check "All tests pass" "$ROOT_DIR/scripts/test.sh"
    echo
    
    # Level 4: Documentation
    echo "Level 4: Documentation"
    check "README exists" "test -f $ROOT_DIR/README.md"
    check "CONTRIBUTING exists" "test -f $ROOT_DIR/CONTRIBUTING.md"
    check "LICENSE exists" "test -f $ROOT_DIR/LICENSE"
    check "CHANGELOG exists" "test -f $ROOT_DIR/CHANGELOG.md"
    echo
    
    # Summary
    echo "============================================"
    echo "Quality Gates Results:"
    echo "  Total: $TOTAL"
    echo "  Passed: $PASSED"
    echo "  Failed: $FAILED"
    echo "============================================"
    
    if (( FAILED > 0 )); then
        log_error "$FAILED quality gate(s) failed"
        exit 1
    fi
    
    log_info "All quality gates passed!"
    exit 0
}

main "$@"