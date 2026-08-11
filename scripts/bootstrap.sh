#!/bin/bash
set -euo pipefail

echo "============================================"
echo " OpenCode Engineering Kit - Bootstrap"
echo "============================================"

# Main directories
DIRS=(
  assets
  assets/skills
  assets/agents
  assets/prompts
  assets/templates
  assets/commands
  assets/playbooks
  assets/recipes
  context
  docs
  examples
  scripts
  tests
  .github
  .github/workflows
)

for dir in "${DIRS[@]}"; do
  mkdir -p "$dir"
  echo "  $dir"
done

# Skill categories (matches actual structure)
SKILL_CATEGORIES=(
  ai
  analytics
  architecture
  arts
  automation
  automotive
  backend
  cloud
  code-review
  commercial
  community
  construction
  database
  design
  devops
  documentation
  education
  embedded
  engineering
  finance
  frontend
  git
  health
  humanities
  iot
  languages
  law
  logistics
  management
  marketing
  music
  projects
  quality
  robotics
  science
  security
  sports
  testing
  tools
  vision
  web
)

for category in "${SKILL_CATEGORIES[@]}"; do
  mkdir -p "assets/skills/$category"
  echo "  assets/skills/$category"
done

# Agent categories
AGENT_CATEGORIES=(
  ai
  analytics
  architect
  arts
  automotive
  automation
  backend
  cloud
  commercial
  construction
  database
  design
  devops
  documentation
  education
  embedded
  engineering
  finance
  frontend
  health
  humanities
  languages
  law
  logistics
  management
  marketing
  music
  performance
  planner
  qa
  reviewer
  robotics
  science
  security
  sports
  vision
  web
)

for category in "${AGENT_CATEGORIES[@]}"; do
  mkdir -p "assets/agents/$category"
  echo "  assets/agents/$category"
done

# Agent files (categorized)
AGENTS=(
  ai/ai-engineer
  ai/data-scientist
  analytics/bi-analyst
  automation/automation-engineer
  backend/backend-developer
  backend/ml-engineer
  database/data-engineer
  devops/devops-engineer
  devops/site-reliability-engineer
  documentation/technical-writer
  frontend/frontend-developer
  frontend/fullstack-developer
  frontend/mobile-developer
  frontend/ui-designer
  planner/product-manager
  qa/qa-engineer
  robotics/robotics-engineer
  security/security-engineer
)

for agent in "${AGENTS[@]}"; do
  if [[ ! -f "assets/agents/$agent.md" ]]; then
    echo "  assets/agents/$agent.md (new)"
  else
    echo "  assets/agents/$agent.md (exists)"
  fi
done

# Commands
mkdir -p assets/commands

# Templates (matches actual structure)
TEMPLATES=(
  agent
  new-project
  prompt
  skill
)

for t in "${TEMPLATES[@]}"; do
  mkdir -p "assets/templates/$t"
  echo "  assets/templates/$t"
done

# Prompts (matches actual structure)
PROMPTS=(
  ai
  architecture
  code-review
  debugging
)

for p in "${PROMPTS[@]}"; do
  mkdir -p "assets/prompts/$p"
  echo "  assets/prompts/$p"
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