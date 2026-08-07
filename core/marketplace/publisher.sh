#!/bin/bash
set -euo pipefail

# Publisher Script
# Manage marketplace publisher accounts
#
# Usage:
#   ./core/marketplace/publisher.sh create --name "John Doe" --email john@example.com
#   ./core/marketplace/publisher.sh verify --publisher john-doe
#   ./core/marketplace/publisher.sh list
#   ./core/marketplace/publisher.sh remove --publisher john-doe

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY_DIR="$SCRIPT_DIR/registry"
PUBLISHERS_FILE="$REGISTRY_DIR/publishers.json"

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
    if [ ! -f "$PUBLISHERS_FILE" ]; then
        echo '{"publishers": []}' > "$PUBLISHERS_FILE"
    fi
}

usage() {
    echo "Usage: $0 {create|verify|list|remove} [options]"
    echo ""
    echo "Commands:"
    echo "  create --name <name> --email <email>   Create a publisher account"
    echo "  verify --publisher <name>               Verify a publisher (mark trusted)"
    echo "  list                                     List all publishers"
    echo "  remove --publisher <name>               Remove a publisher"
    exit 1
}

case "${1:-}" in
    create)
        ensure_registry
        NAME=""
        EMAIL=""
        shift
        while [ $# -gt 0 ]; do
            case "$1" in
                --name) NAME="$2"; shift 2 ;;
                --email) EMAIL="$2"; shift 2 ;;
                *) log_error "Unknown option: $1"; exit 1 ;;
            esac
        done
        [ -z "$NAME" ] && { log_error "Missing --name"; exit 1; }
        [ -z "$EMAIL" ] && { log_error "Missing --email"; exit 1; }

        PUBLISHER_ID="$(echo "$NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')"
        DATE="$(date +%Y-%m-%d)"

        python3 "$SCRIPT_DIR/../../scripts/marketplace_publishers.py" add \
            --file "$PUBLISHERS_FILE" \
            --id "$PUBLISHER_ID" \
            --name "$NAME" \
            --email "$EMAIL" \
            --date "$DATE" > /dev/null

        log_info "Publisher created: $PUBLISHER_ID ($NAME)"
        log_info "Verify with: ./core/marketplace/publisher.sh verify --publisher $PUBLISHER_ID"
        ;;
    verify)
        ensure_registry
        PUBLISHER=""
        shift
        while [ $# -gt 0 ]; do
            case "$1" in
                --publisher) PUBLISHER="$2"; shift 2 ;;
                *) log_error "Unknown option: $1"; exit 1 ;;
            esac
        done
        [ -z "$PUBLISHER" ] && { log_error "Missing --publisher"; exit 1; }

        if python3 "$SCRIPT_DIR/../../scripts/marketplace_publishers.py" verify \
            --file "$PUBLISHERS_FILE" --id "$PUBLISHER"; then
            log_info "Publisher verified: $PUBLISHER"
        else
            log_error "Publisher not found: $PUBLISHER"
            exit 1
        fi
        ;;
    list)
        ensure_registry
        python3 "$SCRIPT_DIR/../../scripts/marketplace_publishers.py" list --file "$PUBLISHERS_FILE"
        ;;
    remove)
        ensure_registry
        PUBLISHER=""
        shift
        while [ $# -gt 0 ]; do
            case "$1" in
                --publisher) PUBLISHER="$2"; shift 2 ;;
                *) log_error "Unknown option: $1"; exit 1 ;;
            esac
        done
        [ -z "$PUBLISHER" ] && { log_error "Missing --publisher"; exit 1; }

        if python3 "$SCRIPT_DIR/../../scripts/marketplace_publishers.py" remove \
            --file "$PUBLISHERS_FILE" --id "$PUBLISHER"; then
            log_info "Publisher removed: $PUBLISHER"
        else
            log_error "Publisher not found: $PUBLISHER"
            exit 1
        fi
        ;;
    *)
        usage
        ;;
esac
