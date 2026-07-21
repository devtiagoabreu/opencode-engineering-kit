#!/bin/bash
set -euo pipefail

# Access Control Script
# Manages access control for the repository

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "Checking access control..."
echo ""

# Check file permissions
echo "=== Checking File Permissions ==="
find "$ROOT_DIR" -type f -name "*.sh" | while read -r file; do
    if [ ! -x "$file" ]; then
        log_warn "Script not executable: $file"
    fi
done

# Check for sensitive files
echo ""
echo "=== Checking for Sensitive Files ==="
SENSITIVE_FILES=(
    ".env"
    ".env.local"
    ".env.production"
    "credentials.json"
    "service-account.json"
    "*.pem"
    "*.key"
)

for pattern in "${SENSITIVE_FILES[@]}"; do
    find "$ROOT_DIR" -name "$pattern" -type f 2>/dev/null | while read -r file; do
        log_warn "Sensitive file found: $file"
    done
done

# Check .gitignore
echo ""
echo "=== Checking .gitignore ==="
if [ -f "$ROOT_DIR/.gitignore" ]; then
    log_info ".gitignore exists"
    
    # Check for common entries
    for entry in ".env" "node_modules" "*.log"; do
        if grep -q "$entry" "$ROOT_DIR/.gitignore"; then
            log_info "  ✓ $entry is ignored"
        else
            log_warn "  ⚠ $entry is not ignored"
        fi
    done
else
    log_warn ".gitignore not found"
fi

echo ""
log_info "Access control check complete!"