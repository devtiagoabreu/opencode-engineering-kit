#!/bin/bash
set -euo pipefail

# Validate Script
# Validate dependency declarations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Counters
TOTAL=0
PASSED=0
FAILED=0

echo "Validating dependencies..."
echo ""

# Validate skills
echo "=== Validating Skills ==="
find "$ROOT_DIR/skills" -name "SKILL.md" -type f | while read -r file; do
    skill_dir="$(dirname "$file")"
    skill_name="$(basename "$skill_dir")"
    
    TOTAL=$((TOTAL + 1))
    
    # Check for circular dependencies
    if grep -q "dependencies:" "$file"; then
        deps=$(grep -A 10 "dependencies:" "$file" | grep "name:" | sed 's/.*name: *//' | tr -d '[:space:]')
        
        for dep in $deps; do
            # Check if dependency exists
            found=false
            for dir in "$ROOT_DIR"/skills/*/"$dep" "$ROOT_DIR"/agents/"$dep".md; do
                if [ -e "$dir" ]; then
                    found=true
                    break
                fi
            done
            
            if [ "$found" = false ]; then
                log_error "Missing dependency: $dep (required by $skill_name)"
                FAILED=$((FAILED + 1))
            else
                PASSED=$((PASSED + 1))
            fi
        done
    else
        PASSED=$((PASSED + 1))
    fi
done

echo ""
echo "=== Validation Summary ==="
echo "Total: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -gt 0 ]; then
    log_error "Validation failed!"
    exit 1
fi

log_info "All dependencies are valid!"