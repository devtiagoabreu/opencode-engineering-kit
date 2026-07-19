#!/usr/bin/env bash

set -e

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

for dir in "${DIRS[@]}"
do
    mkdir -p "$dir"
    echo "✔ $dir"
done

# Skill categories
SKILL_CATEGORIES=(
architecture
backend
database
devops
embedded
frontend
iot
languages
projects
quality
security
tools
vision
)

for category in "${SKILL_CATEGORIES[@]}"
do
    mkdir -p "skills/$category"
    echo "✔ skills/$category"
done

# Agents
AGENTS=(
architect
planner
backend
frontend
database
embedded
vision
reviewer
security
qa
documentation
performance
devops
)

for agent in "${AGENTS[@]}"
do
    mkdir -p "agents/$agent"
done

# Commands
mkdir -p commands

# Templates
TEMPLATES=(
readme
api
adr
docker
docker-compose
esp32
nextjs
react
postgresql
mqtt
opencv
github-actions
)

for t in "${TEMPLATES[@]}"
do
    mkdir -p "templates/$t"
done

# Prompts
PROMPTS=(
planning
research
architecture
review
security
performance
documentation
testing
debug
refactoring
)

for p in "${PROMPTS[@]}"
do
    mkdir -p "prompts/$p"
done

# Context
CONTEXTS=(
coding_rules
architecture
style_guide
naming
git
documentation
security
performance
)

for c in "${CONTEXTS[@]}"
do
    touch "context/$c.md"
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
install.sh
update.sh
uninstall.sh
)

for f in "${FILES[@]}"
do
    touch "$f"
done

echo
echo "============================================"
echo " Structure created successfully!"
echo "============================================"
