#!/bin/bash
set -euo pipefail

echo "============================================"
echo " OpenCode Engineering Kit - Bootstrap"
echo "============================================"

# Main directories
DIRS=(
  agents
  commands
  context
  docs
  examples
  prompts
  skills
  templates
  scripts
  tests
  assets
  .github
  .github/workflows
)

for dir in "${DIRS[@]}"; do
  mkdir -p "$dir"
  echo "  $dir"
done

# Skill categories (matches actual structure)
SKILL_CATEGORIES=(
  architecture
  backend
  code-review
  database
  devops
  embedded
  frontend
  git
  iot
  languages
  projects
  quality
  security
  testing
  tools
  vision
)

for category in "${SKILL_CATEGORIES[@]}"; do
  mkdir -p "skills/$category"
  echo "  skills/$category"
done

# Agent files (flat files, not directories)
AGENTS=(
  backend-developer
  devops-engineer
  frontend-developer
)

for agent in "${AGENTS[@]}"; do
  if [[ ! -f "agents/$agent.md" ]]; then
    echo "  agents/$agent.md (new)"
  else
    echo "  agents/$agent.md (exists)"
  fi
done

# Commands
mkdir -p commands

# Templates (matches actual structure)
TEMPLATES=(
  agent
  new-project
  prompt
  skill
)

for t in "${TEMPLATES[@]}"; do
  mkdir -p "templates/$t"
  echo "  templates/$t"
done

# Prompts (matches actual structure)
PROMPTS=(
  architecture
  code-review
  debugging
)

for p in "${PROMPTS[@]}"; do
  mkdir -p "prompts/$p"
  echo "  prompts/$p"
done

# Context files
CONTEXTS=(
  architecture
  coding_rules
  conventions
  decisions
  documentation
  git
  glossary
  naming
  performance
  project
  security
  stack
  style_guide
)

for c in "${CONTEXTS[@]}"; do
  if [[ ! -f "context/$c.md" ]]; then
    touch "context/$c.md"
    echo "  context/$c.md (new)"
  else
    echo "  context/$c.md (exists)"
  fi
done

# Main files
FILES=(
  README.md
  CHANGELOG.md
  LICENSE
  PROJECT_SPEC.md
  ROADMAP.md
  CONTRIBUTING.md
  CODE_OF_CONDUCT.md
  .gitignore
  .editorconfig
  .markdownlint.json
  .yamllint.yml
  .shellcheckrc
)

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    touch "$f"
    echo "  $f (new)"
  else
    echo "  $f (exists)"
  fi
done

echo
echo "============================================"
echo " Structure created successfully!"
echo "============================================"