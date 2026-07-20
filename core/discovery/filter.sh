#!/bin/bash
set -euo pipefail

# Filter Script
# Filter assets by category, tag, or compatibility

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Default values
CATEGORY=""
TAG=""
COMPATIBLE=""
ASSET_TYPE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --category)
            CATEGORY="$2"
            shift 2
            ;;
        --tag)
            TAG="$2"
            shift 2
            ;;
        --compatible)
            COMPATIBLE="$2"
            shift 2
            ;;
        --type)
            ASSET_TYPE="$2"
            shift 2
            ;;
        --category=*)
            CATEGORY="${1#*=}"
            shift
            ;;
        --tag=*)
            TAG="${1#*=}"
            shift
            ;;
        --compatible=*)
            COMPATIBLE="${1#*=}"
            shift
            ;;
        --type=*)
            ASSET_TYPE="${1#*=}"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "Filtering assets..."
echo ""

# Filter skills
if [ "$ASSET_TYPE" = "" ] || [ "$ASSET_TYPE" = "skill" ]; then
    echo "=== Skills ==="
    find "$ROOT_DIR/skills" -name "SKILL.md" -type f | while read -r file; do
        skill_dir="$(dirname "$file")"
        skill_name="$(basename "$skill_dir")"
        
        # Check category
        if [ -n "$CATEGORY" ]; then
            if ! grep -qi "category: $CATEGORY" "$file"; then
                continue
            fi
        fi
        
        # Check tag
        if [ -n "$TAG" ]; then
            if ! grep -qi "tags:.*$TAG" "$file"; then
                continue
            fi
        fi
        
        # Check compatibility
        if [ -n "$COMPATIBLE" ]; then
            if ! grep -qi "compatible:.*$COMPATIBLE" "$file"; then
                continue
            fi
        fi
        
        log_info "Found: $skill_name"
        echo "  Path: $file"
        echo ""
    done
fi

# Filter agents
if [ "$ASSET_TYPE" = "" ] || [ "$ASSET_TYPE" = "agent" ]; then
    echo "=== Agents ==="
    find "$ROOT_DIR/agents" -name "*.md" -type f | while read -r file; do
        agent_name="$(basename "$file" .md)"
        log_info "Found: $agent_name"
        echo "  Path: $file"
        echo ""
    done
fi

# Filter prompts
if [ "$ASSET_TYPE" = "" ] || [ "$ASSET_TYPE" = "prompt" ]; then
    echo "=== Prompts ==="
    find "$ROOT_DIR/prompts" -name "*.md" -type f | while read -r file; do
        prompt_name="$(basename "$file" .md)"
        log_info "Found: $prompt_name"
        echo "  Path: $file"
        echo ""
    done
fi

# Filter templates
if [ "$ASSET_TYPE" = "" ] || [ "$ASSET_TYPE" = "template" ]; then
    echo "=== Templates ==="
    find "$ROOT_DIR/templates" -name "*.md" -type f | while read -r file; do
        template_name="$(basename "$file" .md)"
        log_info "Found: $template_name"
        echo "  Path: $file"
        echo ""
    done
fi

echo "Filter complete!"