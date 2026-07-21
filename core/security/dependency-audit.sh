#!/bin/bash
set -euo pipefail

# Dependency Audit Script
# Scans for vulnerable dependencies

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

echo "Running dependency audit..."
echo ""

# Check for package.json files
echo "=== Checking Node.js Dependencies ==="
find "$ROOT_DIR" -name "package.json" -type f | while read -r file; do
    log_info "Checking: $file"
    
    # Check if npm audit is available
    if command -v npm &> /dev/null; then
        cd "$(dirname "$file")"
        if npm audit 2>/dev/null; then
            log_info "  ✓ No vulnerabilities found"
        else
            log_warn "  ⚠ Vulnerabilities found"
        fi
        cd "$ROOT_DIR"
    fi
done

# Check for requirements.txt files
echo ""
echo "=== Checking Python Dependencies ==="
find "$ROOT_DIR" -name "requirements.txt" -type f | while read -r file; do
    log_info "Checking: $file"
    
    # Check if pip-audit is available
    if command -v pip-audit &> /dev/null; then
        if pip-audit -r "$file" 2>/dev/null; then
            log_info "  ✓ No vulnerabilities found"
        else
            log_warn "  ⚠ Vulnerabilities found"
        fi
    else
        log_warn "  ⚠ pip-audit not installed"
    fi
done

echo ""
log_info "Dependency audit complete!"