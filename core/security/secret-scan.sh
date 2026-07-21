#!/bin/bash
set -euo pipefail

# Secret Scanning Script
# Scans for exposed secrets and credentials

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

# Counters
TOTAL=0
FOUND=0

echo "Running secret scan..."
echo ""

# Patterns to search for
PATTERNS=(
    "password\s*[:=]\s*['\"].*['\"]"
    "api[_-]?key\s*[:=]\s*['\"].*['\"]"
    "secret\s*[:=]\s*['\"].*['\"]"
    "token\s*[:=]\s*['\"].*['\"]"
    "AWS_ACCESS_KEY_ID"
    "AWS_SECRET_ACCESS_KEY"
    "PRIVATE KEY"
    "BEGIN RSA PRIVATE KEY"
    "BEGIN DSA PRIVATE KEY"
    "BEGIN EC PRIVATE KEY"
)

# Files to skip
SKIP_DIRS=(
    ".git"
    "node_modules"
    "vendor"
    "dist"
    "build"
    "core/security"
)

# Build find command
FIND_CMD="find \"$ROOT_DIR\" -type f"
for dir in "${SKIP_DIRS[@]}"; do
    FIND_CMD="$FIND_CMD -not -path \"*/$dir/*\""
done

# Run scan
eval "$FIND_CMD" | while read -r file; do
    # Skip binary files
    if file "$file" | grep -q "binary"; then
        continue
    fi
    
    for pattern in "${PATTERNS[@]}"; do
        TOTAL=$((TOTAL + 1))
        if grep -qiE "$pattern" "$file" 2>/dev/null; then
            FOUND=$((FOUND + 1))
            log_warn "Potential secret found in: $file"
            log_warn "  Pattern: $pattern"
        fi
    done
done

echo ""
if [ $FOUND -gt 0 ]; then
    log_error "Found $FOUND potential secrets"
    exit 1
else
    log_info "No secrets found"
    exit 0
fi