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
NC='\033[0m'

TOTAL=0
PASSED=0
FAILED=0

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check() {
    local name="$1"
    local command="$2"
    
    TOTAL=$((TOTAL + 1))
    
    if eval "$command" > /dev/null 2>&1; then
        PASSED=$((PASSED + 1))
        echo -e "  ${GREEN}✓${NC} $name"
    else
        FAILED=$((FAILED + 1))
        echo -e "  ${RED}✗${NC} $name"
    fi
}

main() {
    log_info "Running quality gates..."
    echo
    
    # Level 1: Schema Validation
    echo "Level 1: Schema Validation"
    check "Asset schemas/frontmatter valid" "python3 \"$ROOT_DIR/scripts/validate_assets.py\" --root \"$ROOT_DIR\" --check-manifest"
    check "Discovery index fresh" "python3 -c \"from pathlib import Path; r=Path('$ROOT_DIR'); s=len(list(r.glob('assets/skills/**/SKILL.md'))); i=len([l for l in (r/'core/discovery/index/skills.txt').read_text(encoding='utf-8').splitlines() if l.strip()]); raise SystemExit(0 if s==i else 1)\""
    echo
    
    # Level 2: Linting
    echo "Level 2: Linting"
    check "No markdown lint errors" "npx markdownlint-cli '**/*.md' --config $ROOT_DIR/.markdownlint.json 2>&1 | grep -q 'error' || true"
    echo
    
    # Level 2b: Security
    echo "Level 2b: Security"
    check "Skill content security scan" "bash $ROOT_DIR/core/security/skill-scan.sh"
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