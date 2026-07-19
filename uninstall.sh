#!/bin/bash
set -euo pipefail

# OpenCode Engineering Kit - Script de Desinstalação
# Uso: ./uninstall.sh

INSTALL_DIR="${HOME}/.opencode-engineering-kit"

# Cores
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

confirm() {
    local prompt="$1"
    local response
    
    read -p "$prompt (s/N): " response
    case "$response" in
        [sS][iI][mM]|[sS])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

uninstall() {
    log "Desinstalando OpenCode Engineering Kit..."
    
    if [[ ! -d "$INSTALL_DIR" ]]; then
        warn "Diretório de instalação não encontrado: $INSTALL_DIR"
        log "Nada para desinstalar."
        return 0
    fi
    
    if confirm "Tem certeza que deseja desinstalar? Isso removerá todos os arquivos em $INSTALL_DIR"; then
        rm -rf "$INSTALL_DIR"
        log "Desinstalação concluída!"
    else
        log "Desinstalação cancelada."
    fi
}

remove_from_path() {
    local shell_rc=""
    
    if [[ -f "$HOME/.bashrc" ]]; then
        shell_rc="$HOME/.bashrc"
    elif [[ -f "$HOME/.zshrc" ]]; then
        shell_rc="$HOME/.zshrc"
    fi
    
    if [[ -n "$shell_rc" ]]; then
        if grep -q "$INSTALL_DIR" "$shell_rc"; then
            log "Removendo do PATH em $shell_rc..."
            sed -i "\|$INSTALL_DIR|d" "$shell_rc"
            log "PATH atualizado. Reinicie o terminal ou execute: source $shell_rc"
        fi
    fi
}

main() {
    uninstall
    remove_from_path
}

main "$@"
