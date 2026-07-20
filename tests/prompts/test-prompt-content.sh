#!/usr/bin/env bash
# Test: Prompt content validation
# Description: Validates prompt files have required sections

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

PROMPTS_DIR="$ROOT_DIR/prompts"
ERRORS=0

echo "Testing prompt content..."

# Test each prompt file
for prompt_file in "$PROMPTS_DIR"/**/*.md; do
    if [ -f "$prompt_file" ]; then
        rel_path="${prompt_file#$ROOT_DIR/}"
        
        # Check if file has frontmatter
        if ! head -1 "$prompt_file" | grep -q "^---"; then
            echo "FAIL: $rel_path - Missing frontmatter"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has name
        if ! grep -q "^name:" "$prompt_file"; then
            echo "FAIL: $rel_path - Missing name field"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has description
        if ! grep -q "^description:" "$prompt_file"; then
            echo "FAIL: $rel_path - Missing description field"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has version
        if ! grep -q "^version:" "$prompt_file"; then
            echo "FAIL: $rel_path - Missing version field"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has compatible field
        if ! grep -q "^compatible:" "$prompt_file"; then
            echo "FAIL: $rel_path - Missing compatible field"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo "All prompt content tests passed!"
    exit 0
else
    echo "$ERRORS prompt content test(s) failed"
    exit 1
fi