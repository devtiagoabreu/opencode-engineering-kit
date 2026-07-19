#!/bin/bash
set -euo pipefail

# Install script tests
# Verifies that install.sh works correctly

SCRIPT="install.sh"
ERRORS=0

echo "=== Testing Install Script ==="

# Check if script exists
if [[ ! -f "$SCRIPT" ]]; then
    echo "ERROR: Script $SCRIPT not found"
    exit 1
fi

# Check if executable
if [[ ! -x "$SCRIPT" ]]; then
    echo "ERROR: Script $SCRIPT is not executable"
    ((ERRORS++))
fi

# Check shebang
if ! head -1 "$SCRIPT" | grep -q "^#!/bin/bash"; then
    echo "ERROR: Script $SCRIPT missing correct shebang"
    ((ERRORS++))
fi

# Check set -euo pipefail
if ! grep -q "set -euo pipefail" "$SCRIPT"; then
    echo "ERROR: Script $SCRIPT missing set -euo pipefail"
    ((ERRORS++))
fi

# Check for required functions
if ! grep -q "check_prerequisites()" "$SCRIPT"; then
    echo "ERROR: Script $SCRIPT missing check_prerequisites function"
    ((ERRORS++))
fi

if ! grep -q "install()" "$SCRIPT"; then
    echo "ERROR: Script $SCRIPT missing install function"
    ((ERRORS++))
fi

if ! grep -q "cleanup()" "$SCRIPT"; then
    echo "ERROR: Script $SCRIPT missing cleanup function"
    ((ERRORS++))
fi

# Check for REPO_URL
if ! grep -q 'REPO_URL=' "$SCRIPT"; then
    echo "ERROR: Script $SCRIPT missing REPO_URL variable"
    ((ERRORS++))
fi

if (( ERRORS > 0 )); then
    echo "=== $ERRORS errors found ==="
    exit 1
fi

echo "=== All install tests passed ==="
exit 0