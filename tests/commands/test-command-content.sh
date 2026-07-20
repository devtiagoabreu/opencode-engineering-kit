#!/usr/bin/env bash
# Test: Command content validation
# Description: Validates command files have required sections

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

COMMANDS_DIR="$ROOT_DIR/commands"
ERRORS=0

echo "Testing command content..."

# Test each command file
for command_file in "$COMMANDS_DIR"/*.md; do
    if [ -f "$command_file" ]; then
        rel_path="${command_file#$ROOT_DIR/}"
        
        # Check if file has frontmatter
        if ! head -1 "$command_file" | grep -q "^---"; then
            echo "FAIL: $rel_path - Missing frontmatter"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has name
        if ! grep -q "^name:" "$command_file"; then
            echo "FAIL: $rel_path - Missing name field"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has description
        if ! grep -q "^description:" "$command_file"; then
            echo "FAIL: $rel_path - Missing description field"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has version
        if ! grep -q "^version:" "$command_file"; then
            echo "FAIL: $rel_path - Missing version field"
            ERRORS=$((ERRORS + 1))
        fi
        
        # Check if file has compatible field
        if ! grep -q "^compatible:" "$command_file"; then
            echo "FAIL: $rel_path - Missing compatible field"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo "All command content tests passed!"
    exit 0
else
    echo "$ERRORS command content test(s) failed"
    exit 1
fi