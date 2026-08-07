#!/bin/bash
set -euo pipefail

# Hook System
# Executes plugin hook handlers in registration order
#
# Usage:
#   ./core/plugin/hooks.sh <hook-name> [context-args...]
#   ./core/plugin/hooks.sh --list
#   ./core/plugin/hooks.sh --describe <hook-name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
PLUGINS_DIR="$ROOT_DIR/plugins"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Known hooks
KNOWN_HOOKS=(before-generate after-generate before-validate after-validate before-install after-install on-discover on-search)

find_handlers() {
    local hook_name="$1"
    find "$PLUGINS_DIR" -type f -path "*/hooks/$hook_name.sh" 2>/dev/null | sort
}

list_handlers() {
    echo "=== Registered Hook Handlers ==="
    for hook in "${KNOWN_HOOKS[@]}"; do
        handlers="$(find_handlers "$hook")"
        if [ -n "$handlers" ]; then
            echo ""
            echo "$hook:"
            while IFS= read -r handler; do
                local plugin_name
                plugin_name="$(basename "$(dirname "$(dirname "$handler")")")"
                echo "  - $plugin_name ($handler)"
            done <<< "$handlers"
        fi
    done
}

run_hook() {
    local hook_name="$1"
    shift

    if [[ ! " ${KNOWN_HOOKS[*]} " == *" $hook_name "* ]]; then
        log_warn "Unknown hook: $hook_name (known: ${KNOWN_HOOKS[*]})"
        return 1
    fi

    local handlers
    handlers="$(find_handlers "$hook_name")"

    if [ -z "$handlers" ]; then
        log_info "No handlers registered for '$hook_name'"
        return 0
    fi

    log_info "Running hook '$hook_name'"
    index=0
    while IFS= read -r handler; do
        index=$((index + 1))
        plugin_name="$(basename "$(dirname "$(dirname "$handler")")")"
        echo "[$index] $plugin_name -> $hook_name"
        # shellcheck disable=SC1090
        source "$handler" "$@"
    done <<< "$handlers"
}

case "${1:-}" in
    --list)
        list_handlers
        ;;
    --describe)
        hook="${2:-}"
        case "$hook" in
            before-generate) echo "Runs before asset generation. Args: context, config" ;;
            after-generate)  echo "Runs after asset generation. Args: context, asset" ;;
            before-validate) echo "Runs before validation. Args: context, asset" ;;
            after-validate)  echo "Runs after validation. Args: context, result" ;;
            before-install)  echo "Runs before installation. Args: context, package" ;;
            after-install)   echo "Runs after installation. Args: context, package" ;;
            on-discover)     echo "Runs on asset discovery. Args: context, asset" ;;
            on-search)       echo "Runs on search query. Args: context, query" ;;
            *)               log_warn "Unknown hook: $hook"; exit 1 ;;
        esac
        ;;
    "")
        echo "Usage: $0 <hook-name> [context-args...] | --list | --describe <hook-name>"
        exit 1
        ;;
    *)
        run_hook "$@"
        ;;
esac
