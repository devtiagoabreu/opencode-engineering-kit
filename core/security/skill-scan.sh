#!/bin/bash
set -euo pipefail

# Skill Content Security Scan
# Scans SKILL.md and agent content for dangerous patterns (download-and-execute,
# secret harvesting, hardcoded credentials, prompt-injection markers).
#
# Exit codes:
#   0 - PASS (no high-risk findings, or all findings allowlisted)
#   2 - FAIL (one or more high-risk findings not allowlisted)
#
# Allowlist: core/security/skill-scan.allow
#   one entry per line, format "<scope>:<regex>"
#   scope: "all" or a path substring of the file
#   regex: extended regex matched against file content
#   lines starting with '#' are comments
#
# Usage: ./core/security/skill-scan.sh [--json]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
ALLOW_FILE="$SCRIPT_DIR/skill-scan.allow"

JSON=0
if [[ "${1:-}" == "--json" ]]; then
    JSON=1
fi

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# High-risk patterns: FAIL unless allowlisted
HIGH_PATTERNS=(
    # download-and-execute (Unix)
    "(curl|wget)[^\n|]*\|\s*(bash|sh|zsh)\b"
    # download-and-execute (PowerShell)
    "(irm|iwr)\s+[^\n|]*\|\s*iex\b"
    "Invoke-Expression\s*\(.*(http|github)"
    # python remote code execution
    "(urllib|requests|http\.client)[^\n]*\n?\s*.*(exec|eval)\s*\("
    # hardcoded credentials
    "(password|passwd|api[_-]?key|secret|token)\s*[:=]\s*['\"][^'\"]{8,}['\"]"
    "BEGIN (RSA |EC |DSA )?PRIVATE KEY"
    # prompt-injection / instruction overrides
    "ignore (all |any )?(previous|prior|above) (instructions|prompts|directions|commands)"
    "disregard (all )?(previous|prior|above)"
    # env/secret exfiltration phrasing
    "exfiltrat"
    "send (me )?(the )?(contents of|all|any) (env|environment|secrets|credentials)"
)

# Medium-risk patterns: WARN only
MEDIUM_PATTERNS=(
    "os\.system\s*\("
    "subprocess\.(run|call|Popen)\s*\("
    "os\.environ"
    "process\.env"
    "getenv\s*\("
    "eval\s*\("
    "exec\s*\("
    "base64\s*[\-]{0,2}d"
)

# ---- Load allowlist ----
# Each entry: "scope:regex"
declare -a ALLOW_SCOPE
declare -a ALLOW_REGEX
while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    scope="${line%%:*}"
    regex="${line#*:}"
    if [[ -n "$scope" && -n "$regex" ]]; then
        ALLOW_SCOPE+=("$scope")
        ALLOW_REGEX+=("$regex")
    fi
done < "$ALLOW_FILE"

is_allowed() {
    local file="$1" pattern="$2"
    for i in "${!ALLOW_SCOPE[@]}"; do
        local scope="${ALLOW_SCOPE[$i]}" regex="${ALLOW_REGEX[$i]}"
        [[ "$scope" != "all" && "$file" != *"$scope"* ]] && continue
        if grep -qE "$regex" "$file"; then
            return 0
        fi
    done
    return 1
}

scan_file() {
    local file="$1" pattern="$2" level="$3"
    if grep -qEi "$pattern" "$file" 2>/dev/null; then
        if is_allowed "$file" "$pattern"; then
            log_info "  (allowed) $file -> $pattern"
            return 0
        fi
        if [[ "$level" == "high" ]]; then
            log_error "  FAIL $file -> $pattern"
            HIGH_FAILS=$((HIGH_FAILS + 1))
        else
            log_warn "  WARN $file -> $pattern"
        fi
        return 1
    fi
    return 0
}

HIGH_FAILS=0
WARN_TOTAL=0

if [[ "$JSON" -eq 1 ]]; then
    echo "{"
fi

echo "Running skill content security scan..."
echo ""

files=$(find "$ROOT_DIR/assets" -type f \( -name "SKILL.md" -o -name "*.md" \) -not -path "*/templates/*" 2>/dev/null)
file_count=0

while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    file_count=$((file_count + 1))
    for pattern in "${HIGH_PATTERNS[@]}"; do
        scan_file "$file" "$pattern" "high" || true
    done
    for pattern in "${MEDIUM_PATTERNS[@]}"; do
        if grep -qEi "$pattern" "$file" 2>/dev/null; then
            WARN_TOTAL=$((WARN_TOTAL + 1))
            log_warn "  WARN $file -> $pattern"
        fi
    done
done <<< "$files"

echo ""
echo "=== Skill security scan summary ==="
echo "  Files scanned: $file_count"
echo "  High-risk findings (FAIL): $HIGH_FAILS"
echo "  Medium-risk notes (WARN): $WARN_TOTAL"

if [[ "$HIGH_FAILS" -gt 0 ]]; then
    echo ""
    log_error "$HIGH_FAILS high-risk finding(s) not allowlisted. Review core/security/skill-scan.allow."
    if [[ "$JSON" -eq 1 ]]; then
        echo "  \"passed\": false, \"high_failures\": $HIGH_FAILS, \"warnings\": $WARN_TOTAL"
        echo "}"
    fi
    exit 2
fi

log_info "Skill content scan PASSED"
if [[ "$JSON" -eq 1 ]]; then
    echo "  \"passed\": true, \"high_failures\": 0, \"warnings\": $WARN_TOTAL"
    echo "}"
fi
exit 0
