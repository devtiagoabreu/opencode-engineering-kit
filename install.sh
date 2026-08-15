#!/bin/bash
set -euo pipefail

# OpenCode Engineering Kit - Installation Script
# Usage (one line):
#   curl -fsSL https://raw.githubusercontent.com/devtiagoabreu/opencode-engineering-kit/main/install.sh | bash -s -- -y
#
# Options:
#   -y                 Non-interactive install (no prompts)
#   -d <dir>           Install to a custom directory (default: ~/.opencode-engineering-kit)
#   --check            Verify the installed kit (skill scan + tests)
#   -h, --help         Show this help

REPO_URL="https://github.com/devtiagoabreu/opencode-engineering-kit.git"
INSTALL_DIR="${KIT_INSTALL_DIR:-${HOME}/.opencode-engineering-kit}"
TEMP_DIR="/tmp/opencode-engineering-kit-install"
ASSUME_YES=0
RUN_CHECK=0

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
    cp -r "$TEMP_DIR/assets" "$INSTALL_DIR/"
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

    if [[ "$RUN_CHECK" -eq 1 ]]; then
        log "Verifying installation..."
        bash "$INSTALL_DIR/core/security/skill-scan.sh"
        log "Verification complete."
    fi
}

show_help() {
    sed -n '4,13p' "$0" | sed 's/^# \{0,1\}//'
}

main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -y) ASSUME_YES=1 ;;
            -d) INSTALL_DIR="${2:?usage: -d <dir>}"; shift ;;
            --check) RUN_CHECK=1 ;;
            -h|--help) show_help; exit 0 ;;
            *) error "unknown option: $1" ;;
        esac
        shift
    done

    if [[ "$ASSUME_YES" -eq 0 ]] && [[ -d "$INSTALL_DIR" ]]; then
        echo -e "${YELLOW}[WARN]${NC} $INSTALL_DIR already exists."
        read -r -p "Reinstall (overwrite)? [y/N] " answer
        if [[ "${answer:-N}" != "y" && "${answer:-N}" != "Y" ]]; then
            log "Installation cancelled."
            exit 0
        fi
    fi

    check_prerequisites
    install
}

main "$@"
