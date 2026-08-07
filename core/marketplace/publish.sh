#!/bin/bash
set -euo pipefail

# Publish Script
# Publish an asset to the local marketplace registry
#
# Usage:
#   ./core/marketplace/publish.sh --type skill --path ./assets/skills/my-skill [--publisher <name>]
#   ./core/marketplace/publish.sh --list
#   ./core/marketplace/publish.sh --remove <asset-name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
REGISTRY_DIR="$SCRIPT_DIR/registry"
ASSETS_FILE="$REGISTRY_DIR/assets.json"
VALIDATOR="$ROOT_DIR/core/quality/validate.sh"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

ensure_registry() {
    mkdir -p "$REGISTRY_DIR"
    if [ ! -f "$ASSETS_FILE" ]; then
        echo '{"assets": []}' > "$ASSETS_FILE"
    fi
}

usage() {
    echo "Usage: $0 {--type <type> --path <path> [--publisher <name>] | --list | --remove <name>}"
    echo ""
    echo "Options:"
    echo "  --type <skill|agent|prompt|template|command>"
    echo "  --path <asset-dir>"
    echo "  --publisher <publisher-id>   Must exist (see publisher.sh list)"
    echo "  --list                        List published assets"
    echo "  --remove <name>               Remove a published asset"
    exit 1
}

publish_asset() {
    local asset_type="$1"
    local asset_path="$2"
    local publisher="${3:-}"

    if [ ! -d "$asset_path" ]; then
        log_error "Asset path does not exist: $asset_path"
        exit 1
    fi

    local asset_name
    asset_name="$(basename "$asset_path")"

    case "$asset_type" in
        skill) local file_name="SKILL.md" ;;
        agent) local file_name="${asset_name}.md" ;;
        prompt) local file_name="${asset_name}.md" ;;
        template) local file_name="${asset_name}.md" ;;
        command) local file_name="command.md" ;;
        *) log_error "Unknown type: $asset_type (skill|agent|prompt|template|command)"; exit 1 ;;
    esac

    if [ ! -f "$asset_path/$file_name" ]; then
        log_warn "Expected content file $file_name not found in $asset_path"
    fi

    # Validate before publishing
    if [ -f "$VALIDATOR" ]; then
        log_info "Running quality validation before publishing..."
        if ! bash "$VALIDATOR" "$asset_path" > /dev/null 2>&1; then
            log_warn "Quality validation reported issues (asset published with warnings)"
        else
            log_info "Quality validation passed"
        fi
    fi

    local metadata=""
    if [ -f "$asset_path/metadata.json" ]; then
        metadata="$(cat "$asset_path/metadata.json")"
    fi

    python3 "$SCRIPT_DIR/../../scripts/marketplace_assets.py" add \
        --file "$ASSETS_FILE" \
        --type "$asset_type" \
        --name "$asset_name" \
        --path "$(realpath "$asset_path")" \
        --publisher "${publisher:-anonymous}" \
        --metadata "$metadata" > /dev/null

    log_info "Published: $asset_type/$asset_name"
}

case "${1:-}" in
    --list)
        ensure_registry
        python3 "$SCRIPT_DIR/../../scripts/marketplace_assets.py" list --file "$ASSETS_FILE"
        ;;
    --remove)
        ensure_registry
        ASSET="${2:-}"
        [ -z "$ASSET" ] && { log_error "Missing asset name"; exit 1; }
        if python3 "$SCRIPT_DIR/../../scripts/marketplace_assets.py" remove \
            --file "$ASSETS_FILE" --name "$ASSET"; then
            log_info "Removed: $ASSET"
        else
            log_error "Asset not found: $ASSET"
            exit 1
        fi
        ;;
    --type)
        TYPE="${2:-}"
        PATH_ARG=""
        PUBLISHER=""
        shift 2
        while [ $# -gt 0 ]; do
            case "$1" in
                --path) PATH_ARG="$2"; shift 2 ;;
                --publisher) PUBLISHER="$2"; shift 2 ;;
                *) log_error "Unknown option: $1"; exit 1 ;;
            esac
        done
        [ -z "$PATH_ARG" ] && { log_error "Missing --path"; exit 1; }
        ensure_registry
        publish_asset "$TYPE" "$PATH_ARG" "$PUBLISHER"
        ;;
    *)
        usage
        ;;
esac
