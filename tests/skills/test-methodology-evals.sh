#!/bin/bash
set -euo pipefail

# Methodology skill evals
# Behavioral validation of the methodology skill cycle:
#   brainstorming -> writing-plans -> executing-plans
#   -> two-stage-code-review -> verification-before-completion
# plus tdd and git-worktrees as execution enablers.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
METHOD="$ROOT_DIR/assets/skills/methodology"
ERRORS=0

echo "=== Testing Methodology Skill Evals ==="

if [[ ! -d "$METHOD" ]]; then
    echo "ERROR: $METHOD not found"
    exit 1
fi

# 1. All expected skills exist with SKILL.md + metadata.json
EXPECTED=(
    brainstorming
    writing-plans
    executing-plans
    tdd
    git-worktrees
    two-stage-code-review
    verification-before-completion
)

for skill in "${EXPECTED[@]}"; do
    for file in "SKILL.md" "metadata.json"; do
        if [[ ! -f "$METHOD/$skill/$file" ]]; then
            echo "ERROR: $skill missing $file"
            ((ERRORS++))
        fi
    done
done

# 2. Frontmatter contract: category, provenance, tags
for skill in "${EXPECTED[@]}"; do
    file="$METHOD/$skill/SKILL.md"
    if ! grep -q "^category: methodology" "$file"; then
        echo "ERROR: $skill frontmatter missing 'category: methodology'"
        ((ERRORS++))
    fi
    if ! grep -qE "^provenance:" "$file"; then
        echo "ERROR: $skill frontmatter missing 'provenance' block"
        ((ERRORS++))
    fi
    if ! grep -qE "^  verified: [0-9]{4}-[0-9]{2}-[0-9]{2}$" "$file"; then
        echo "ERROR: $skill provenance missing verified date"
        ((ERRORS++))
    fi
    if ! grep -qE "^tags: \[.*\]$" "$file"; then
        echo "ERROR: $skill frontmatter missing tags"
        ((ERRORS++))
    fi
done

# 3. Behavior trigger: each skill states its role and handoff.
#    trigger_keywords maps skill -> required behavioral terms.
declare -A TRIGGER_KEYWORDS=(
    [brainstorming]="goal:options:constraints:open questions"
    [writing-plans]="acceptance criteria:phases:risks"
    [executing-plans]="evidence:criterion:deviation"
    [tdd]="Red:Green:Refactor:failing test"
    [git-worktrees]="worktree:parallel:branch"
    [two-stage-code-review]="Stage 1:Stage 2:blocker"
    [verification-before-completion]="evidence:claim:not done"
)

for skill in "${!TRIGGER_KEYWORDS[@]}"; do
    file="$METHOD/$skill/SKILL.md"
    for term in ${TRIGGER_KEYWORDS[$skill]//:/ }; do
        if ! grep -qi "$term" "$file"; then
            echo "ERROR: $skill eval missing trigger term '$term'"
            ((ERRORS++))
        fi
    done
done

# 4. Handoff: each plan/execution skill references the next step in the cycle
for pair in \
    "writing-plans:brainstorming" \
    "executing-plans:writing-plans" \
    "verification-before-completion:executing-plans"; do
    skill="${pair%%:*}"
    ref="${pair##*:}"
    if ! grep -q "$ref" "$METHOD/$skill/SKILL.md"; then
        echo "ERROR: $skill eval does not reference upstream '$ref'"
        ((ERRORS++))
    fi
done

if [[ $ERRORS -eq 0 ]]; then
    echo "  All methodology skill evals PASSED (${#EXPECTED[@]} skills)"
    exit 0
else
    echo "  $ERRORS methodology eval error(s)"
    exit 1
fi
