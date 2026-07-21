#!/bin/bash
set -euo pipefail

# Audit Logging Script
# Logs security-relevant events

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
LOG_DIR="$ROOT_DIR/logs"

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

# Functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Log file
LOG_FILE="$LOG_DIR/audit-$(date +%Y-%m-%d).log"

# Log function
audit_log() {
    local event="$1"
    local details="$2"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    echo "[$timestamp] $event: $details" >> "$LOG_FILE"
    log_info "Logged: $event"
}

echo "Audit logging system initialized"
echo ""

# Log system info
audit_log "SYSTEM_INFO" "OS: $(uname -s) $(uname -r)"
audit_log "SYSTEM_INFO" "User: $(whoami)"
audit_log "SYSTEM_INFO" "Directory: $ROOT_DIR"

# Log git info
if [ -d "$ROOT_DIR/.git" ]; then
    cd "$ROOT_DIR"
    audit_log "GIT_INFO" "Branch: $(git branch --show-current)"
    audit_log "GIT_INFO" "Last commit: $(git log -1 --format='%H %s')"
fi

echo ""
log_info "Audit log saved to: $LOG_FILE"