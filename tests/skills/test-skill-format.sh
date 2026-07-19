#!/bin/bash
set -euo pipefail

# Skill format tests
# Verifies that all skills follow the standard format

SKILLS_DIR="skills"
ERRORS=0

echo "=== Testing Skill Format ==="

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
    
    # Skip directories without SKILL.md
    if [[ ! -f "$skill_file" ]]; then
        continue
    fi
    
    # Check frontmatter
    if ! head -1 "$skill_file" | grep -q "^---"; then
        echo "ERROR: $skill_file missing frontmatter"
        ((ERRORS++))
    fi
    
    # Check name
    if ! grep -q "^name:" "$skill_file"; then
        echo "ERROR: $skill_file missing name field"
        ((ERRORS++))
    fi
    
    # Check description
    if ! grep -q "^description:" "$skill_file"; then
        echo "ERROR: $skill_file missing description field"
        ((ERRORS++))
    fi
    
    # Check category
    if ! grep -q "^category:" "$skill_file"; then
        echo "ERROR: $skill_file missing category field"
        ((ERRORS++))
    fi
    
    # Check version
    if ! grep -q "^version:" "$skill_file"; then
        echo "ERROR: $skill_file missing version field"
        ((ERRORS++))
    fi
    
    # Check size
    lines=$(wc -l < "$skill_file")
    if (( lines > 500 )); then
        echo "ERROR: $skill_file exceeds 500 lines ($lines)"
        ((ERRORS++))
    fi
    
    # Check for title
    if ! grep -q "^# " "$skill_file"; then
        echo "ERROR: $skill_file missing title"
        ((ERRORS++))
    fi
    
    echo "OK: $skill_name"
done

if (( ERRORS > 0 )); then
    echo "=== $ERRORS errors found ==="
    exit 1
fi

echo "=== All format tests passed ==="
exit 0