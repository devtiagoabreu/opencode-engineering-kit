#!/bin/bash
set -euo pipefail

# Skill content tests
# Verifies that skills have adequate content

SKILLS_DIR="skills"
ERRORS=0

echo "=== Testing Skill Content ==="

if [[ ! -d "$SKILLS_DIR" ]]; then
    echo "ERROR: Directory $SKILLS_DIR not found"
    exit 1
fi

for skill_dir in "$SKILLS_DIR"/*/; do
    if [[ ! -d "$skill_dir" ]]; then
        continue
    fi
    
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"
    
    if [[ ! -f "$skill_file" ]]; then
        echo "ERROR: $skill_file not found"
        ((ERRORS++))
        continue
    fi
    
    # Check for Overview section
    if ! grep -q "## Overview" "$skill_file"; then
        echo "ERROR: $skill_file missing 'Overview' section"
        ((ERRORS++))
    fi
    
    # Check for Prerequisites section
    if ! grep -q "## Prerequisites" "$skill_file"; then
        echo "ERROR: $skill_file missing 'Prerequisites' section"
        ((ERRORS++))
    fi
    
    # Check for Usage Instructions section
    if ! grep -q "## Usage Instructions" "$skill_file"; then
        echo "ERROR: $skill_file missing 'Usage Instructions' section"
        ((ERRORS++))
    fi
    
    # Check for Examples section
    if ! grep -q "## Examples" "$skill_file"; then
        echo "ERROR: $skill_file missing 'Examples' section"
        ((ERRORS++))
    fi
    
    # Check for References section
    if ! grep -q "## References" "$skill_file"; then
        echo "ERROR: $skill_file missing 'References' section"
        ((ERRORS++))
    fi
    
    # Check for at least 1 code example
    if ! grep -q '```' "$skill_file"; then
        echo "ERROR: $skill_file missing code examples"
        ((ERRORS++))
    fi
    
    echo "OK: $skill_name"
done

if (( ERRORS > 0 )); then
    echo "=== $ERRORS errors found ==="
    exit 1
fi

echo "=== All content tests passed ==="
exit 0