#!/bin/bash
set -euo pipefail

# Bootstrap script tests
# Verifies that bootstrap works correctly

SCRIPT="scripts/bootstrap.sh"
ERRORS=0

echo "=== Testing Bootstrap Script ==="

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

# Test execution (--help or similar)
if ! bash "$SCRIPT" --help &>/dev/null; then
    echo "WARNING: Script $SCRIPT does not support --help"
fi

if (( ERRORS > 0 )); then
    echo "=== $ERRORS errors found ==="
    exit 1
fi

echo "=== All bootstrap tests passed ==="
exit 0