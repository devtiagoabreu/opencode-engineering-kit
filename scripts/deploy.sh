#!/bin/bash
set -euo pipefail

# Deploy Script
# Run the full release pipeline: typecheck -> tests -> quality gates ->
# regenerate lockfile, indexes, and dashboard -> package release archive
# Usage: ./scripts/deploy.sh [--tag <version>]

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TAG="${1:-}"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

step() {
    local name="$1"
    shift
    log_info "Step: $name"
    if ! "$@"; then
        log_error "Deploy aborted at step: $name"
        exit 1
    fi
}

echo "=== Deploy pipeline ==="
echo ""

step "typecheck"        bash "$ROOT_DIR/scripts/typecheck.sh"
step "tests"            bash "$ROOT_DIR/scripts/test.sh"
step "quality gates"    bash "$ROOT_DIR/core/quality/validate.sh"
step "lockfile"         bash "$ROOT_DIR/core/resolver/lock.sh"
step "registry"         bash "$ROOT_DIR/core/registry/generate.sh"
step "dashboard"        bash "$ROOT_DIR/core/quality/dashboard.sh"

log_info "Creating release archive..."
RELEASE_DIR="$ROOT_DIR/releases"
mkdir -p "$RELEASE_DIR"
STAMP="$(date +%Y%m%d-%H%M%S)"
ARCHIVE="$RELEASE_DIR/opencode-kit-${TAG:-deploy}-$STAMP.tar.gz"
tar --exclude=.git --exclude=node_modules --exclude=backups --exclude=releases \
    -czf "$ARCHIVE" -C "$ROOT_DIR" . 2>/dev/null

echo ""
log_info "Deploy complete: $ARCHIVE ($(du -h "$ARCHIVE" | cut -f1))"
