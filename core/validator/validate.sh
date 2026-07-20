#!/bin/bash
set -euo pipefail

# Asset Validator Script
# Validates assets against schemas and quality standards

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
SCHEMA_DIR="$ROOT_DIR/core/registry/schema"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
TOTAL=0
PASSED=0
FAILED=0

# Log functions
log_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Validate frontmatter
validate_frontmatter() {
  local file="$1"
  local has_frontmatter=false
  
  if head -n 1 "$file" | grep -q "^---"; then
    has_frontmatter=true
  fi
  
  if [ "$has_frontmatter" = false ]; then
    log_warn "No frontmatter found in $file"
    return 1
  fi
  
  return 0
}

# Validate required fields
validate_required_fields() {
  local file="$1"
  local required_fields=("name" "description" "version")
  
  for field in "${required_fields[@]}"; do
    if ! grep -q "^$field:" "$file"; then
      log_error "Missing required field: $field in $file"
      return 1
    fi
  done
  
  return 0
}

# Validate version format
validate_version() {
  local file="$1"
  local version
  
  version=$(grep "^version:" "$file" | head -1 | sed 's/version: *//' | tr -d '[:space:]')
  
  if ! [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    log_error "Invalid version format: $version in $file"
    return 1
  fi
  
  return 0
}

# Validate single asset
validate_asset() {
  local asset_path="$1"
  local asset_type="$2"
  local asset_name
  asset_name=$(basename "$asset_path")
  
  TOTAL=$((TOTAL + 1))
  
  log_info "Validating $asset_type: $asset_name"
  
  # Check if SKILL.md or README.md exists
  if [ "$asset_type" = "skill" ]; then
    if [ ! -f "$asset_path/SKILL.md" ]; then
      log_error "Missing SKILL.md in $asset_path"
      FAILED=$((FAILED + 1))
      return 1
    fi
    validate_frontmatter "$asset_path/SKILL.md" || {
      FAILED=$((FAILED + 1))
      return 1
    }
    validate_required_fields "$asset_path/SKILL.md" || {
      FAILED=$((FAILED + 1))
      return 1
    }
    validate_version "$asset_path/SKILL.md" || {
      FAILED=$((FAILED + 1))
      return 1
    }
  elif [ "$asset_type" = "agent" ]; then
    if [ ! -f "$asset_path" ]; then
      log_error "Missing agent file: $asset_path"
      FAILED=$((FAILED + 1))
      return 1
    fi
    validate_frontmatter "$asset_path" || {
      FAILED=$((FAILED + 1))
      return 1
    }
    validate_required_fields "$asset_path" || {
      FAILED=$((FAILED + 1))
      return 1
    }
    validate_version "$asset_path" || {
      FAILED=$((FAILED + 1))
      return 1
    }
  fi
  
  PASSED=$((PASSED + 1))
  log_info "✓ $asset_name passed validation"
  return 0
}

# Main validation function
main() {
  local target="${1:-.}"
  
  echo "Validating assets in: $target"
  echo ""
  
  # Validate skills
  if [ -d "$target/skills" ]; then
    echo "=== Validating Skills ==="
    for category_dir in "$target/skills"/*/; do
      if [ -d "$category_dir" ]; then
        for skill_dir in "$category_dir"/*/; do
          if [ -d "$skill_dir" ]; then
            validate_asset "$skill_dir" "skill" || true
          fi
        done
      fi
    done
    echo ""
  fi
  
  # Validate agents
  if [ -d "$target/agents" ]; then
    echo "=== Validating Agents ==="
    for agent_file in "$target/agents"/*.md; do
      if [ -f "$agent_file" ]; then
        validate_asset "$agent_file" "agent" || true
      fi
    done
    echo ""
  fi
  
  # Summary
  echo "=== Validation Summary ==="
  echo "Total: $TOTAL"
  echo -e "Passed: ${GREEN}$PASSED${NC}"
  echo -e "Failed: ${RED}$FAILED${NC}"
  echo ""
  
  if [ $FAILED -gt 0 ]; then
    log_error "Validation failed!"
    exit 1
  fi
  
  log_info "All assets passed validation!"
  exit 0
}

# Run main function
main "$@"