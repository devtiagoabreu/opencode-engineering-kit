#!/bin/bash
set -euo pipefail

# OpenCode Engineering Kit - Script de Atualização
# Uso: ./update.sh

REPO_URL="https://github.com/opencode-ai/opencode-engineering-kit.git"
INSTALL_DIR="${HOME}/.opencode-engineering-kit"
TEMP_DIR="/tmp/opencode-engineering-kit-update"

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

check_prerequisites() {
    log "Verificando pré-requisitos..."
    
    if ! command -v git &> /dev/null; then
        error "Git não encontrado."
    fi
    
    if [[ ! -d "$INSTALL_DIR" ]]; then
        error "OpenCode Engineering Kit não está instalado. Execute install.sh primeiro."
    fi
    
    log "Pré-requisitos verificados."
}

cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

trap cleanup EXIT

backup() {
    local backup_dir="${INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    log "Criando backup em $backup_dir..."
    cp -r "$INSTALL_DIR" "$backup_dir"
    log "Backup criado."
}

update() {
    log "Atualizando OpenCode Engineering Kit..."
    
    # Criar diretório temporário
    mkdir -p "$TEMP_DIR"
    
    # Clonar repositório
    log "Baixando versão mais recente..."
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR"
    
    # Backup
    backup
    
    # Atualizar arquivos
    log "Atualizando arquivos..."
    cp -r "$TEMP_DIR/skills" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/agents" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/templates" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/prompts" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/commands" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/context" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/scripts" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/docs" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/examples" "$INSTALL_DIR/"
    cp "$TEMP_DIR/README.md" "$INSTALL_DIR/"
    cp "$TEMP_DIR/CONTRIBUTING.md" "$INSTALL_DIR/"
    cp "$TEMP_DIR/LICENSE" "$INSTALL_DIR/"
    
    # Tornar scripts executáveis
    chmod +x "$INSTALL_DIR/scripts/"*.sh 2>/dev/null || true
    
    log "Atualização concluída!"
}

show_version() {
    if [[ -f "$INSTALL_DIR/README.md" ]]; then
        grep -o "version-[0-9.]*" "$INSTALL_DIR/README.md" | head -1 || echo "versão desconhecida"
    fi
}

main() {
    check_prerequisites
    update
    log "Versão atual: $(show_version)"
}

main "$@"
