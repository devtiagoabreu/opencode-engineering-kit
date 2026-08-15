#!/bin/bash
set -euo pipefail

# SkillPointer resolver — on-demand loading of curated skill content.
#
# Skills can be "pointers": the SKILL.md stays a minimal catalog entry and the
# full content lives in assets/vault/<category>/<skill>/. This avoids context
# injection: the agent loads the vault content only when the task needs it.
#
# Usage:
#   pointer.sh resolve <skill>          # full content (SKILL.md or vault entry)
#   pointer.sh vault <skill>            # vault meta + token estimate (JSON)
#   pointer.sh tokens <file>            # token estimate for any file
#   pointer.sh list [--pointer]         # list vault entries (or pointer skills)
#   pointer.sh is-pointer <skill>       # exit 0 if the skill is a pointer

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS_DIR="$ROOT_DIR/assets/skills"
VAULT_DIR="$ROOT_DIR/assets/vault"

# Rough token estimate: ~4 characters per token (widely used approximation).
tokens() {
    local file="$1"
    local chars
    chars=$(wc -m < "$file")
    echo $(( (chars + 3) / 4 ))
}

# Resolve a skill name to its SKILL.md path (searches all categories).
find_skill() {
    local skill="$1"
    local path
    path=$(find "$SKILLS_DIR" -type f -name SKILL.md | while read -r f; do
        if grep -q "name: $skill$" "$f"; then dirname "$f"; fi
    done | head -1)
    [ -n "$path" ] && echo "$path" || echo ""
}

is_pointer() {
    local skill="$1"
    local dir
    dir=$(find_skill "$skill")
    [ -z "$dir" ] && return 1
    grep -q "^pointer: true$" "$dir/SKILL.md"
}

vault_path() {
    local skill="$1"
    local dir
    dir=$(find_skill "$skill")
    grep -E "^vault:" "$dir/SKILL.md" | head -1 | awk '{print $2}'
}

resolve() {
    local skill="$1"
    local dir
    dir=$(find_skill "$skill")
    if [ -z "$dir" ]; then
        echo "error: skill '$skill' not found" >&2
        return 1
    fi
    if is_pointer "$skill"; then
        local rel
        rel=$(vault_path "$skill")
        local content="$VAULT_DIR/$rel/content.md"
        if [ ! -f "$content" ]; then
            echo "error: vault entry missing for '$skill' (expected $content)" >&2
            return 1
        fi
        cat "$content"
    else
        cat "$dir/SKILL.md"
    fi
}

vault_info() {
    local skill="$1"
    local dir
    dir=$(find_skill "$skill")
    if [ -z "$dir" ]; then
        echo "error: skill '$skill' not found" >&2
        return 1
    fi
    local rel vault content
    rel=$(vault_path "$skill")
    if [ -n "$rel" ]; then
        vault="$VAULT_DIR/$rel"
        content="$vault/content.md"
    else
        vault=""
        content="$dir/SKILL.md"
    fi
    if [ -n "$vault" ] && [ ! -f "$content" ]; then
        echo "error: vault entry missing for '$skill' (expected $content)" >&2
        return 1
    fi
    local meta_json="{}"
    if [ -n "$vault" ] && [ -f "$vault/meta.json" ]; then
        meta_json=$(cat "$vault/meta.json")
    fi
    python3 - "$skill" "$content" "$vault" "$meta_json" "$(is_pointer "$skill" && echo true || echo false)" << 'PYEOF'
import json, os, sys
skill, content, vault, meta_json, is_pointer = sys.argv[1:6]
out = {
    "skill": skill,
    "pointer": is_pointer == "true",
    "vault": vault or "",
    "token_estimate": len(open(content, encoding="utf-8").read()) // 4 if os.path.exists(content) else 0,
}
meta = json.loads(meta_json) if meta_json.strip() else {}
out["meta"] = meta
print(json.dumps(out))
PYEOF
}

list_entries() {
    local mode="$1"
    if [ "$mode" = "--pointer" ]; then
        find "$SKILLS_DIR" -name SKILL.md -type f | while read -r f; do
            if grep -q "^pointer: true$" "$f"; then
                basename "$(dirname "$f")"
            fi
        done | sort
    else
        find "$VAULT_DIR" -name content.md -type f | while read -r f; do
                basename "$(dirname "$f")"
        done | sort
    fi
}

case "${1:-}" in
    resolve)
        [ $# -eq 2 ] || { echo "usage: pointer.sh resolve <skill>" >&2; exit 1; }
        resolve "$2"
        ;;
    vault)
        [ $# -eq 2 ] || { echo "usage: pointer.sh vault <skill>" >&2; exit 1; }
        vault_info "$2"
        ;;
    tokens)
        [ $# -eq 2 ] || { echo "usage: pointer.sh tokens <file>" >&2; exit 1; }
        tokens "$2"
        ;;
    list)
        list_entries "${2:-}"
        ;;
    is-pointer)
        [ $# -eq 2 ] || { echo "usage: pointer.sh is-pointer <skill>" >&2; exit 1; }
        if is_pointer "$2"; then
            echo "true"
        else
            echo "false"
            exit 1
        fi
        ;;
    *)
        echo "usage: pointer.sh {resolve|vault|tokens|list|is-pointer}" >&2
        exit 1
        ;;
esac
