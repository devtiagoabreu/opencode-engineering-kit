#!/bin/bash
set -euo pipefail

# OpenCode Engineering Kit - Script de Atualização
# Uso: ./update.sh

REPO_URL="https://github.com/devtiagoabreu/opencode-engineering-kit.git"
INSTALL_DIR="${KIT_INSTALL_DIR:-${HOME}/.opencode-engineering-kit}"
TEMP_DIR="/tmp/opencode-engineering-kit-update"
MANIFEST_REMOTE="/tmp/opencode-engineering-kit-manifest.json"

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

read_manifest_count() {
    local manifest_file="$1" key="$2"
    if [[ -f "$manifest_file" ]]; then
        python3 -c "
import json, sys
try:
    d = json.load(open('$manifest_file'))
    print(d.get('counts', {}).get('$key', -1))
except Exception:
    print(-1)
"
    else
        echo "-1"
    fi
}

drift_check() {
    # Compares installed manifest against the latest remote manifest and
    # reports drift (missing/extra assets or stale provenance).
    local local_manifest="$INSTALL_DIR/core/registry/manifest.json"
    local remote_manifest="$TEMP_DIR/core/registry/manifest.json"

    if [[ ! -f "$local_manifest" ]]; then
        warn "Instalação sem manifest (versão antiga) — atualizando tudo."
        return 1
    fi
    if [[ ! -f "$remote_manifest" ]]; then
        warn "Repo remoto sem manifest — prosseguindo normalmente."
        return 1
    fi

    local l_skills r_skills l_agents r_agents
    l_skills=$(read_manifest_count "$local_manifest" "skills")
    r_skills=$(read_manifest_count "$remote_manifest" "skills")
    l_agents=$(read_manifest_count "$local_manifest" "agents")
    r_agents=$(read_manifest_count "$remote_manifest" "agents")

    local drift=0
    if [[ "$l_skills" != "$r_skills" ]]; then
        warn "Drift em skills: local=$l_skills remoto=$r_skills"
        drift=1
    fi
    if [[ "$l_agents" != "$r_agents" ]]; then
        warn "Drift em agents: local=$l_agents remoto=$r_agents"
        drift=1
    fi
    if [[ "$drift" -eq 0 ]]; then
        log "Manifest consistente (skills=$l_skills, agents=$l_agents)."
    else
        warn "Drift detectado — atualização vai realinhar os assets."
    fi
    return $drift
}

update() {
    log "Atualizando OpenCode Engineering Kit..."
    
    # Criar diretório temporário
    mkdir -p "$TEMP_DIR"
    
    # Clonar repositório
    log "Baixando versão mais recente..."
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR"
    
    # Detectar drift antes de atualizar
    drift_check
    
    # Backup
    backup
    
    # Atualizar arquivos
    log "Atualizando arquivos..."
    cp -r "$TEMP_DIR/assets" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/context" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/scripts" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/docs" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/examples" "$INSTALL_DIR/"
    cp -r "$TEMP_DIR/core" "$INSTALL_DIR/"
    cp "$TEMP_DIR/README.md" "$INSTALL_DIR/"
    cp "$TEMP_DIR/CONTRIBUTING.md" "$INSTALL_DIR/"
    cp "$TEMP_DIR/LICENSE" "$INSTALL_DIR/"
    
    # Tornar scripts executáveis
    chmod +x "$INSTALL_DIR/scripts/"*.sh 2>/dev/null || true
    find "$INSTALL_DIR/core" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    
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
