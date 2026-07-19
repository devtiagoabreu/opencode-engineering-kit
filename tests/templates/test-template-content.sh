#!/bin/bash
set -euo pipefail

# Template content tests
# Verifies that templates have adequate content

TEMPLATES_DIR="templates"
ERRORS=0

echo "=== Testing Template Content ==="

if [[ ! -d "$TEMPLATES_DIR" ]]; then
    echo "ERROR: Directory $TEMPLATES_DIR not found"
    exit 1
fi

for template_dir in "$TEMPLATES_DIR"/*/; do
    if [[ ! -d "$template_dir" ]]; then
        continue
    fi
    
    template_name=$(basename "$template_dir")
    
    # Skip empty directories
    if [[ -z "$(ls -A "$template_dir" 2>/dev/null)" ]]; then
        continue
    fi
    
    # Check for README
    if [[ ! -f "$template_dir/README.md" ]] && [[ ! -f "$template_dir/SKILL.md" ]] && [[ ! -f "$template_dir/agent.md" ]] && [[ ! -f "$template_dir/prompt.md" ]]; then
        echo "ERROR: $template_dir missing README.md, SKILL.md, agent.md, or prompt.md"
        ((ERRORS++))
    fi
    
    # Check for variables
    if ! grep -rq '{{' "$template_dir"; then
        echo "WARNING: $template_dir missing template variables"
    fi
    
    # Check for Usage section (English or Portuguese)
    if ! grep -rqE "## (Usage|Uso|Instructions|Instruções)" "$template_dir"; then
        echo "WARNING: $template_dir missing usage instructions"
    fi
    
    echo "OK: $template_name"
done

if (( ERRORS > 0 )); then
    echo "=== $ERRORS errors found ==="
    exit 1
fi

echo "=== All content tests passed ==="
exit 0