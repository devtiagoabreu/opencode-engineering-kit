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
    
    # Skip directories without SKILL.md
    if [[ ! -f "$skill_file" ]]; then
        continue
    fi
    
    # Check for Overview section (English or Portuguese)
    if ! grep -qE "## (Overview|Visão Geral)" "$skill_file"; then
        echo "ERROR: $skill_file missing 'Overview' or 'Visão Geral' section"
        ((ERRORS++))
    fi
    
    # Check for Prerequisites section (English or Portuguese)
    if ! grep -qE "## (Prerequisites|Pré-requisitos)" "$skill_file"; then
        echo "ERROR: $skill_file missing 'Prerequisites' or 'Pré-requisitos' section"
        ((ERRORS++))
    fi
    
    # Check for Usage Instructions section (English or Portuguese)
    if ! grep -qE "## (Usage Instructions|Instruções de Uso)" "$skill_file"; then
        echo "ERROR: $skill_file missing 'Usage Instructions' or 'Instruções de Uso' section"
        ((ERRORS++))
    fi
    
    # Check for Examples section (English or Portuguese)
    if ! grep -qE "## (Examples|Exemplos)" "$skill_file"; then
        echo "ERROR: $skill_file missing 'Examples' or 'Exemplos' section"
        ((ERRORS++))
    fi
    
    # Check for References section (English or Portuguese)
    if ! grep -qE "## (References|Referências)" "$skill_file"; then
        echo "ERROR: $skill_file missing 'References' or 'Referências' section"
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