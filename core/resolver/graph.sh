#!/bin/bash
set -euo pipefail

# Graph Script
# Generate dependency graph

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

echo "Generating dependency graph..."
echo ""

# Create graph file
GRAPH_FILE="$SCRIPT_DIR/dependency-graph.txt"
echo "# Dependency Graph" > "$GRAPH_FILE"
echo "# Generated: $(date)" >> "$GRAPH_FILE"
echo "" >> "$GRAPH_FILE"

# Scan all skills
find "$ROOT_DIR/skills" -name "SKILL.md" -type f | while read -r file; do
    skill_dir="$(dirname "$file")"
    skill_name="$(basename "$skill_dir")"
    category="$(dirname "$skill_dir" | xargs basename)"
    
    echo "## $category/$skill_name" >> "$GRAPH_FILE"
    
    # Check for dependencies
    if grep -q "dependencies:" "$file"; then
        grep -A 10 "dependencies:" "$file" | tail -n +2 | while read -r line; do
            if echo "$line" | grep -q "name:"; then
                dep_name=$(echo "$line" | sed 's/.*name: *//' | tr -d '[:space:]')
                echo "  -> $dep_name" >> "$GRAPH_FILE"
            fi
        done
    else
        echo "  (no dependencies)" >> "$GRAPH_FILE"
    fi
    
    echo "" >> "$GRAPH_FILE"
done

log_info "Dependency graph saved to: $GRAPH_FILE"
echo ""
cat "$GRAPH_FILE"