#!/bin/bash
set -euo pipefail

# Index Script
# Generate index of all assets

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

echo "Generating asset index..."
echo ""

# Create index directory
mkdir -p "$SCRIPT_DIR/index"

# Index skills
echo "=== Skills ==="
find "$ROOT_DIR/skills" -name "SKILL.md" -type f | while read -r file; do
    skill_dir="$(dirname "$file")"
    skill_name="$(basename "$skill_dir")"
    category="$(dirname "$skill_dir" | xargs basename)"
    echo "$category/$skill_name"
done | sort > "$SCRIPT_DIR/index/skills.txt"
log_info "Skills indexed: $(wc -l < "$SCRIPT_DIR/index/skills.txt")"

# Index agents
echo "=== Agents ==="
find "$ROOT_DIR/agents" -name "*.md" -type f | while read -r file; do
    agent_name="$(basename "$file" .md)"
    echo "$agent_name"
done | sort > "$SCRIPT_DIR/index/agents.txt"
log_info "Agents indexed: $(wc -l < "$SCRIPT_DIR/index/agents.txt")"

# Index prompts
echo "=== Prompts ==="
find "$ROOT_DIR/prompts" -name "*.md" -type f | while read -r file; do
    prompt_name="$(basename "$file" .md)"
    echo "$prompt_name"
done | sort > "$SCRIPT_DIR/index/prompts.txt"
log_info "Prompts indexed: $(wc -l < "$SCRIPT_DIR/index/prompts.txt")"

# Index templates
echo "=== Templates ==="
find "$ROOT_DIR/templates" -name "*.md" -type f | while read -r file; do
    template_name="$(basename "$file" .md)"
    echo "$template_name"
done | sort > "$SCRIPT_DIR/index/templates.txt"
log_info "Templates indexed: $(wc -l < "$SCRIPT_DIR/index/templates.txt")"

echo ""
echo "Index generation complete!"
echo ""
echo "Files created:"
ls -la "$SCRIPT_DIR/index/"