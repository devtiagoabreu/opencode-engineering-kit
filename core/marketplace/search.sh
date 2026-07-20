#!/bin/bash
set -euo pipefail

# Search Script
# Search for assets in the marketplace

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Check arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 <search-term>"
    echo "Example: $0 docker"
    exit 1
fi

SEARCH_TERM="$1"

echo "Searching marketplace for: $SEARCH_TERM"
echo ""

# Search in skills
echo "=== Skills ==="
find "$ROOT_DIR/skills" -name "SKILL.md" -type f | while read -r file; do
    if grep -qi "$SEARCH_TERM" "$file"; then
        skill_dir="$(dirname "$file")"
        skill_name="$(basename "$skill_dir")"
        category="$(dirname "$skill_dir" | xargs basename)"
        
        # Extract description
        description=$(grep -m 1 "^description:" "$file" | sed 's/^description: *//' | tr -d '"')
        
        log_info "$category/$skill_name"
        echo "  Description: $description"
        echo "  Path: $file"
        echo ""
    fi
done

# Search in agents
echo "=== Agents ==="
find "$ROOT_DIR/agents" -name "*.md" -type f | while read -r file; do
    if grep -qi "$SEARCH_TERM" "$file"; then
        agent_name="$(basename "$file" .md)"
        
        # Extract description
        description=$(grep -m 1 "^## Role" -A 1 "$file" | tail -1 | sed 's/^## Role//' | tr -d '#' | tr -d ' ')
        
        log_info "$agent_name"
        echo "  Description: $description"
        echo "  Path: $file"
        echo ""
    fi
done

# Search in prompts
echo "=== Prompts ==="
find "$ROOT_DIR/prompts" -name "*.md" -type f | while read -r file; do
    if grep -qi "$SEARCH_TERM" "$file"; then
        prompt_name="$(basename "$file" .md)"
        
        # Extract description
        description=$(grep -m 1 "^description:" "$file" | sed 's/^description: *//' | tr -d '"')
        
        log_info "$prompt_name"
        echo "  Description: $description"
        echo "  Path: $file"
        echo ""
    fi
done

# Search in templates
echo "=== Templates ==="
find "$ROOT_DIR/templates" -name "*.md" -type f | while read -r file; do
    if grep -qi "$SEARCH_TERM" "$file"; then
        template_name="$(basename "$file" .md)"
        
        # Extract description
        description=$(grep -m 1 "^description:" "$file" | sed 's/^description: *//' | tr -d '"')
        
        log_info "$template_name"
        echo "  Description: $description"
        echo "  Path: $file"
        echo ""
    fi
done

echo "Search complete!"