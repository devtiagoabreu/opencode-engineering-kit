#!/bin/bash
set -euo pipefail

# Registry Generator Script
# Generates index files for all asset types

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "Generating registry indexes..."

# Generate skills index
echo "Generating skills index..."
if [ -d "$ROOT_DIR/skills" ]; then
  find "$ROOT_DIR/skills" -name "metadata.json" -type f | while read -r metadata_file; do
    skill_dir="$(dirname "$metadata_file")"
    skill_name="$(basename "$skill_dir")"
    echo "  - $skill_name"
  done > "$SCRIPT_DIR/index/skills.txt"
fi

# Generate agents index
echo "Generating agents index..."
if [ -d "$ROOT_DIR/agents" ]; then
  find "$ROOT_DIR/agents" -name "*.md" -type f | while read -r agent_file; do
    agent_name="$(basename "$agent_file" .md)"
    echo "  - $agent_name"
  done > "$SCRIPT_DIR/index/agents.txt"
fi

# Generate prompts index
echo "Generating prompts index..."
if [ -d "$ROOT_DIR/prompts" ]; then
  find "$ROOT_DIR/prompts" -name "*.md" -type f | while read -r prompt_file; do
    prompt_name="$(basename "$prompt_file" .md)"
    echo "  - $prompt_name"
  done > "$SCRIPT_DIR/index/prompts.txt"
fi

# Generate templates index
echo "Generating templates index..."
if [ -d "$ROOT_DIR/templates" ]; then
  find "$ROOT_DIR/templates" -name "*.md" -type f | while read -r template_file; do
    template_name="$(basename "$template_file" .md)"
    echo "  - $template_name"
  done > "$SCRIPT_DIR/index/templates.txt"
fi

# Generate commands index
echo "Generating commands index..."
if [ -d "$ROOT_DIR/commands" ]; then
  find "$ROOT_DIR/commands" -name "*.md" -type f | while read -r command_file; do
    command_name="$(basename "$command_file" .md)"
    echo "  - $command_name"
  done > "$SCRIPT_DIR/index/commands.txt"
fi

echo "Registry generation complete!"
echo ""
echo "Indexes created:"
ls -la "$SCRIPT_DIR/index/"