#!/usr/bin/env bash
# Test: Context content validation
# Description: Validates context files have required sections

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

CONTEXT_DIR="$ROOT_DIR/context"
ERRORS=0

echo "Testing context content..."

# Test each context file
for context_file in "$CONTEXT_DIR"/*.md; do
    if [ -f "$context_file" ]; then
        rel_path="${context_file#$ROOT_DIR/}"
        
        # Check if file has frontmatter
        if ! head -1 "$context_file" | grep -q "^---"; then
            echo "FAIL: $rel_path - Missing frontmatter"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has name
        if ! grep -q "^name:" "$context_file"; then
            echo "FAIL: $rel_path - Missing name field"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has description
        if ! grep -q "^description:" "$context_file"; then
            echo "FAIL: $rel_path - Missing description field"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has version
        if ! grep -q "^version:" "$context_file"; then
            echo "FAIL: $rel_path - Missing version field"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo "All context content tests passed!"
    exit 0
else
    echo "$ERRORS context content test(s) failed"
    exit 1
fi