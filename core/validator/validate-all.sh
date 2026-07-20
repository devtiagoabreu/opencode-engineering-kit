#!/bin/bash
set -euo pipefail

# Validate All Assets Script
# Validates all assets in the repository

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "Validating all assets..."
echo ""

# Run validation
"$SCRIPT_DIR/validate.sh" "$ROOT_DIR"

echo ""
echo "Validation complete!"