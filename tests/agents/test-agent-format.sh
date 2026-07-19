#!/bin/bash
set -euo pipefail

# Agent format tests
# Verifies that all agents follow the standard format

AGENTS_DIR="agents"
ERRORS=0

echo "=== Testing Agent Format ==="

if [[ ! -d "$AGENTS_DIR" ]]; then
    echo "ERROR: Directory $AGENTS_DIR not found"
    exit 1
fi

for agent_file in "$AGENTS_DIR"/*.md; do
    if [[ ! -f "$agent_file" ]]; then
        continue
    fi
    
    agent_name=$(basename "$agent_file" .md)
    
    # Check frontmatter
    if ! head -1 "$agent_file" | grep -q "^---"; then
        echo "ERROR: $agent_file missing frontmatter"
        ((ERRORS++))
    fi
    
    # Check name
    if ! grep -q "^name:" "$agent_file"; then
        echo "ERROR: $agent_file missing name field"
        ((ERRORS++))
    fi
    
    # Check description
    if ! grep -q "^description:" "$agent_file"; then
        echo "ERROR: $agent_file missing description field"
        ((ERRORS++))
    fi
    
    # Check version
    if ! grep -q "^version:" "$agent_file"; then
        echo "ERROR: $agent_file missing version field"
        ((ERRORS++))
    fi
    
    # Check size
    lines=$(wc -l < "$agent_file")
    if (( lines > 200 )); then
        echo "ERROR: $agent_file exceeds 200 lines ($lines)"
        ((ERRORS++))
    fi
    
    # Check for title
    if ! grep -q "^# " "$agent_file"; then
        echo "ERROR: $agent_file missing title"
        ((ERRORS++))
    fi
    
    echo "OK: $agent_name"
done

if (( ERRORS > 0 )); then
    echo "=== $ERRORS errors found ==="
    exit 1
fi

echo "=== All format tests passed ==="
exit 0