#!/bin/bash
set -euo pipefail

# Template format tests
# Verifies that all templates follow the standard format

TEMPLATES_DIR="templates"
ERRORS=0

echo "=== Testing Template Format ==="

if [[ ! -d "$TEMPLATES_DIR" ]]; then
    echo "ERROR: Directory $TEMPLATES_DIR not found"
    exit 1
fi

for template_dir in "$TEMPLATES_DIR"/*/; do
    if [[ ! -d "$template_dir" ]]; then
        continue
    fi
    
    template_name=$(basename "$template_dir")
    
    # Check for README
    if [[ ! -f "$template_dir/README.md" ]] && [[ ! -f "$template_dir/SKILL.md" ]]; then
        echo "ERROR: $template_dir missing README.md or SKILL.md"
        ((ERRORS++))
    fi
    
    # Check for variables
    if ! grep -rq '{{' "$template_dir"; then
        echo "WARNING: $template_dir missing template variables"
    fi
    
    echo "OK: $template_name"
done

if (( ERRORS > 0 )); then
    echo "=== $ERRORS errors found ==="
    exit 1
fi

echo "=== All format tests passed ==="
exit 0