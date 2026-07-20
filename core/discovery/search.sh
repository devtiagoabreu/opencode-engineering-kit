#!/bin/bash
set -euo pipefail

# Search Script
# Search for assets by keyword

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

echo "Searching for: $SEARCH_TERM"
echo ""

# Search in skills
echo "=== Skills ==="
find "$ROOT_DIR/skills" -name "SKILL.md" -type f | while read -r file; do
    if grep -qi "$SEARCH_TERM" "$file"; then
        skill_dir="$(dirname "$file")"
        skill_name="$(basename "$skill_dir")"
        log_info "Found: $skill_name"
        echo "  Path: $file"
        echo ""
    fi
done

# Search in agents
echo "=== Agents ==="
find "$ROOT_DIR/agents" -name "*.md" -type f | while read -r file; do
    if grep -qi "$SEARCH_TERM" "$file"; then
        agent_name="$(basename "$file" .md)"
        log_info "Found: $agent_name"
        echo "  Path: $file"
        echo ""
    fi
done

# Search in prompts
echo "=== Prompts ==="
find "$ROOT_DIR/prompts" -name "*.md" -type f | while read -r file; do
    if grep -qi "$SEARCH_TERM" "$file"; then
        prompt_name="$(basename "$file" .md)"
        log_info "Found: $prompt_name"
        echo "  Path: $file"
        echo ""
    fi
done

# Search in templates
echo "=== Templates ==="
find "$ROOT_DIR/templates" -name "*.md" -type f | while read -r file; do
    if grep -qi "$SEARCH_TERM" "$file"; then
        template_name="$(basename "$file" .md)"
        log_info "Found: $template_name"
        echo "  Path: $file"
        echo ""
    fi
done

echo "Search complete!"