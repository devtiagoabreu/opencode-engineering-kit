#!/bin/bash
set -euo pipefail

# Install Script
# Install an asset from the marketplace

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

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <asset-type> <asset-name>"
    echo "Example: $0 skill docker-best-practices"
    echo ""
    echo "Asset types: skill, agent, prompt, template, command"
    exit 1
fi

ASSET_TYPE="$1"
ASSET_NAME="$2"

echo "Installing $ASSET_TYPE: $ASSET_NAME"
echo ""

# Validate asset type
case "$ASSET_TYPE" in
    skill|agent|prompt|template|command)
        ;;
    *)
        log_error "Invalid asset type: $ASSET_TYPE"
        echo "Valid types: skill, agent, prompt, template, command"
        exit 1
        ;;
esac

# Determine target directory
case "$ASSET_TYPE" in
    skill)
        TARGET_DIR="$ROOT_DIR/skills"
        ;;
    agent)
        TARGET_DIR="$ROOT_DIR/agents"
        ;;
    prompt)
        TARGET_DIR="$ROOT_DIR/prompts"
        ;;
    template)
        TARGET_DIR="$ROOT_DIR/templates"
        ;;
    command)
        TARGET_DIR="$ROOT_DIR/commands"
        ;;
esac

# Check if asset already exists
if [ "$ASSET_TYPE" = "skill" ]; then
    # Skills are in subdirectories
    for category_dir in "$TARGET_DIR"/*/; do
        if [ -d "$category_dir/$ASSET_NAME" ]; then
            log_warn "Asset already exists: $ASSET_NAME"
            exit 0
        fi
    done
else
    if [ -e "$TARGET_DIR/$ASSET_NAME" ] || [ -e "$TARGET_DIR/$ASSET_NAME.md" ]; then
        log_warn "Asset already exists: $ASSET_NAME"
        exit 0
    fi
fi

# For now, create a placeholder
log_info "Creating placeholder for: $ASSET_NAME"

if [ "$ASSET_TYPE" = "skill" ]; then
    mkdir -p "$TARGET_DIR/community/$ASSET_NAME"
    cat > "$TARGET_DIR/community/$ASSET_NAME/SKILL.md" << EOF
---
name: $ASSET_NAME
description: Description of $ASSET_NAME
category: community
version: 0.1.0
author: Community
tags: [community]
compatible:
  - opencode
  - claude-code
  - cursor
---

# $ASSET_NAME

## Overview

Description of $ASSET_NAME.

## Usage

Coming soon.
EOF
else
    mkdir -p "$TARGET_DIR"
    cat > "$TARGET_DIR/$ASSET_NAME.md" << EOF
---
name: $ASSET_NAME
description: Description of $ASSET_NAME
version: 0.1.0
author: Community
---

# $ASSET_NAME

## Overview

Description of $ASSET_NAME.

## Usage

Coming soon.
EOF
fi

log_info "Asset installed successfully!"