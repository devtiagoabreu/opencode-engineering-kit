#!/usr/bin/env bash

set -e

mkdir -p docs

FILES=(
architecture.md
coding-standards.md
development-workflow.md
roadmap.md
agents.md
skills.md
templates.md
prompts.md
commands.md
context.md
quality.md
testing.md
security.md
performance.md
versioning.md
release-process.md
research.md
contributing.md
style-guide.md
directory-structure.md
)

for f in "${FILES[@]}"
do
    touch "docs/$f"
    echo "Criado docs/$f"
done

echo
echo "Documentação criada."