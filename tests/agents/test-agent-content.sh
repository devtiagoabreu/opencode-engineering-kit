#!/bin/bash
set -euo pipefail

# Agent content tests
# Verifies that agents have adequate content

AGENTS_DIR="agents"
ERRORS=0

echo "=== Testing Agent Content ==="

if [[ ! -d "$AGENTS_DIR" ]]; then
    echo "ERROR: Directory $AGENTS_DIR not found"
    exit 1
fi

for agent_file in "$AGENTS_DIR"/*.md; do
    if [[ ! -f "$agent_file" ]]; then
        continue
    fi
    
    agent_name=$(basename "$agent_file" .md)
    
    # Check for Persona section (English or Portuguese)
    if ! grep -qE "## (Persona|Pessoa)" "$agent_file"; then
        echo "ERROR: $agent_file missing 'Persona' or 'Pessoa' section"
        ((ERRORS++))
    fi
    
    # Check for Skills/Capabilities section (English or Portuguese)
    if ! grep -qE "## (Skills|Habilidades|Capabilities)" "$agent_file"; then
        echo "ERROR: $agent_file missing 'Skills', 'Habilidades', or 'Capabilities' section"
        ((ERRORS++))
    fi
    
    # Check for Examples section (English or Portuguese)
    if ! grep -qE "## (Examples|Exemplos|Usage Examples)" "$agent_file"; then
        echo "ERROR: $agent_file missing 'Examples', 'Exemplos', or 'Usage Examples' section"
        ((ERRORS++))
    fi
    
    # Check for at least 1 code example
    if ! grep -q '```' "$agent_file"; then
        echo "ERROR: $agent_file missing code examples"
        ((ERRORS++))
    fi
    
    echo "OK: $agent_name"
done

if (( ERRORS > 0 )); then
    echo "=== $ERRORS errors found ==="
    exit 1
fi

echo "=== All content tests passed ==="
exit 0