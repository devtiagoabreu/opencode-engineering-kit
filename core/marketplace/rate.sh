#!/bin/bash
set -euo pipefail

# Rating Script
# Add and manage ratings/reviews for published marketplace assets
#
# Usage:
#   ./core/marketplace/rate.sh add --asset <name> --reviewer <user> --rating <1-5> [--title <t>] [--content <text>]
#   ./core/marketplace/rate.sh list --asset <name>
#   ./core/marketplace/rate.sh summary --asset <name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY_DIR="$SCRIPT_DIR/registry"
REVIEWS_FILE="$REGISTRY_DIR/reviews.json"
ASSETS_FILE="$REGISTRY_DIR/assets.json"

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
    if [ ! -f "$REVIEWS_FILE" ]; then
        echo '{"reviews": []}' > "$REVIEWS_FILE"
    fi
}

asset_exists() {
    local name="$1"
    [ -f "$ASSETS_FILE" ] || return 1
    python3 "$SCRIPT_DIR/../../scripts/marketplace_assets.py" list --file "$ASSETS_FILE" 2>/dev/null \
        | grep -q "$name"
}

usage() {
    echo "Usage: $0 {add|list|summary} [options]"
    echo ""
    echo "Commands:"
    echo "  add --asset <name> --reviewer <user> --rating <1-5> [--title <t>] [--content <text>]"
    echo "  list --asset <name>"
    echo "  summary --asset <name>"
    exit 1
}

case "${1:-}" in
    add)
        ensure_registry
        ASSET=""
        REVIEWER=""
        RATING=""
        TITLE=""
        CONTENT=""
        shift
        while [ $# -gt 0 ]; do
            case "$1" in
                --asset) ASSET="$2"; shift 2 ;;
                --reviewer) REVIEWER="$2"; shift 2 ;;
                --rating) RATING="$2"; shift 2 ;;
                --title) TITLE="$2"; shift 2 ;;
                --content) CONTENT="$2"; shift 2 ;;
                *) log_error "Unknown option: $1"; exit 1 ;;
            esac
        done
        [ -z "$ASSET" ] && { log_error "Missing --asset"; exit 1; }
        [ -z "$REVIEWER" ] && { log_error "Missing --reviewer"; exit 1; }
        [ -z "$RATING" ] && { log_error "Missing --rating"; exit 1; }
        if ! echo "$RATING" | grep -qE '^[1-5]$'; then
            log_error "Rating must be an integer 1-5"
            exit 1
        fi

        if ! asset_exists "$ASSET"; then
            log_warn "Asset '$ASSET' is not in the published registry; still recording review"
        fi

        DATE="$(date +%Y-%m-%d)"
        python3 "$SCRIPT_DIR/../../scripts/marketplace_reviews.py" add \
            --file "$REVIEWS_FILE" \
            --asset "$ASSET" \
            --reviewer "$REVIEWER" \
            --rating "$RATING" \
            --title "$TITLE" \
            --content "$CONTENT" \
            --date "$DATE" > /dev/null

        log_info "Review added for $ASSET by $REVIEWER (${RATING}/5)"
        ;;
    list)
        ensure_registry
        ASSET=""
        shift
        while [ $# -gt 0 ]; do
            case "$1" in
                --asset) ASSET="$2"; shift 2 ;;
                *) log_error "Unknown option: $1"; exit 1 ;;
            esac
        done
        [ -z "$ASSET" ] && { log_error "Missing --asset"; exit 1; }
        python3 "$SCRIPT_DIR/../../scripts/marketplace_reviews.py" list \
            --file "$REVIEWS_FILE" --asset "$ASSET"
        ;;
    summary)
        ensure_registry
        ASSET=""
        shift
        while [ $# -gt 0 ]; do
            case "$1" in
                --asset) ASSET="$2"; shift 2 ;;
                *) log_error "Unknown option: $1"; exit 1 ;;
            esac
        done
        [ -z "$ASSET" ] && { log_error "Missing --asset"; exit 1; }
        python3 "$SCRIPT_DIR/../../scripts/marketplace_reviews.py" summary \
            --file "$REVIEWS_FILE" --asset "$ASSET"
        ;;
    *)
        usage
        ;;
esac
