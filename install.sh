#!/bin/bash
set -euo pipefail

# OpenCode Engineering Kit - Installation Script
# Usage: curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode-engineering-kit/main/install.sh | bash

REPO_URL="https://github.com/opencode-ai/opencode-engineering-kit.git"
INSTALL_DIR="${HOME}/.opencode-engineering-kit"
TEMP_DIR="/tmp/opencode-engineering-kit-install"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

check_prerequisites() {
    log "Checking prerequisites..."
    
    if ! command -v git &> /dev/null; then
        error "Git not found. Please install Git first."
    fi
    
    if ! command -v bash &> /dev/null; then
        error "Bash not found."
    fi
    
    log "Prerequisites verified."
}

cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

trap cleanup EXIT

install() {
    log "Installing OpenCode Engineering Kit..."
    
    # Create temporary directory
    mkdir -p "$TEMP_DIR"
    
    # Clone repository
    log "Cloning repository..."
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR"
    
    # Create installation directory
    mkdir -p "$INSTALL_DIR"
    
    # Copy files
    log "Copying files..."
    cp -r "$TEMP_DIR/skills" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/agents" "$INSTALL_DIR/"
    cp -r "$INSTALL_DIR/templates" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/prompts" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/commands" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/context" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/scripts" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/docs" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/examples" "$INSTALL_DIR/"
    cp "$TEMP_DIR/README.md" "$INSTALL_DIR/"
    cp "$TEMP_DIR/CONTRIBUTING.md" "$INSTALL_DIR/"
    cp "$TEMP_DIR/LICENSE" "$INSTALL_DIR/"
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR/scripts/"*.sh 2>/dev/null || true
    
    log "Installation complete!"
    log "Installation directory: $INSTALL_DIR"
    log ""
    log "To use, add to your PATH:"
    log "  export PATH=\"\$PATH:$INSTALL_DIR/scripts\""
    log ""
    log "Or run directly:"
    log "  $INSTALL_DIR/scripts/bootstrap.sh"
}

main() {
    check_prerequisites
    install
}

main "$@"
