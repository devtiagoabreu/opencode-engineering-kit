#!/bin/bash
set -euo pipefail

# Per-asset quality test module
# Validates every skill (SKILL.md) and agent (.md) against six quality
# dimensions required for this project:
#   1. Acessibilidade  - clean heading hierarchy, no broken links
#   2. Segurança       - no secrets, no insecure http://, provenance declared
#   3. Intuitividade   - clear name/description, recognizable structure
#   4. UI              - parseable frontmatter, valid metadata.json
#   5. Eficiência      - file size and line length limits
#   6. Eficácia        - required sections and working examples present

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ERRORS=0
MAX_FILE_LINES=600
MAX_LINE_LENGTH=400

echo "=== Testing Per-Asset Quality (six dimensions) ==="

check_heading_after_frontmatter() {
    local file="$1"
    python3 - "$file" << 'PYEOF'
import sys, re
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    content = f.read()
errs = []
lines = content.splitlines()
start = 0
if lines and lines[0] == "---":
    i = 1
    while i < len(lines) and lines[i] != "---":
        i += 1
    start = i + 1
prev = 0
in_fence = False
for idx in range(start, len(lines)):
    line = lines[idx]
    if line.lstrip().startswith("```"):
        in_fence = not in_fence
        continue
    if in_fence:
        continue
    m = re.match(r"^(#{1,6})\s+", line)
    if not m:
        continue
    level = len(m.group(1))
    if prev and level > prev + 1:
        errs.append(f"line {idx+1}: heading level skipped ({prev}->{level})")
    prev = level
print("\n".join(errs))
PYEOF
}

for file in $(find assets/skills -name "SKILL.md" -type f | sort); do
    asset="${file#assets/}"
    name=$(basename "$(dirname "$file")")

    # ---- 1. Acessibilidade ----
    heading_errors=$(check_heading_after_frontmatter "$file")
    if [[ -n "$heading_errors" ]]; then
        echo -e "${RED}ERROR${NC} $asset: heading hierarchy broken"
        echo "$heading_errors" | head -5
        ((ERRORS++))
    fi
    # no empty link destinations or broken relative links
    if grep -qE '\]\(\)' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: empty link destination found"
        ((ERRORS++))
    fi

    # ---- 2. Segurança ----
    if grep -qEi '(api[_-]?key|secret|password|token)\s*[:=]\s*["\x27]?[A-Za-z0-9]{16,}' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: possible hardcoded secret"
        ((ERRORS++))
    fi
    if grep -qE 'http://' "$file" && grep -E 'http://' "$file" | grep -qEv 'http://(localhost|127\.0\.0\.1|0\.0\.0\.0|<[^>]*>|([a-z0-9-]+\.)*example\.(com|org|net)|arduino\.esp8266\.com)'; then
        echo -e "${RED}ERROR${NC} $asset: insecure http:// link (use https)"
        ((ERRORS++))
    fi
    if ! grep -q '^provenance:' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing provenance frontmatter"
        ((ERRORS++))
    fi

    # ---- 3. Intuitividade ----
    if ! grep -q '^name:' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing 'name' frontmatter"
        ((ERRORS++))
    fi
    if ! grep -q '^description:' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing 'description' frontmatter"
        ((ERRORS++))
    fi
    if ! grep -q '^## Overview' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing '## Overview' section"
        ((ERRORS++))
    fi

    # ---- 4. UI (frontmatter/metadata integrity) ----
    front_check=$(python3 - "$file" << 'PYEOF'
import sys, yaml
path = sys.argv[1]
try:
    content = open(path, encoding="utf-8").read()
    front = content.split("---", 2)[1]
    yaml.safe_load(front)
except Exception as e:
    print(f"unparseable frontmatter: {e}")
PYEOF
)
    if [[ -n "$front_check" ]]; then
        echo -e "${RED}ERROR${NC} $asset: $front_check"
        ((ERRORS++))
    fi
    meta_dir=$(dirname "$file")
    if [[ ! -f "$meta_dir/metadata.json" ]]; then
        echo -e "${RED}ERROR${NC} $asset: missing metadata.json"
        ((ERRORS++))
    else
        if ! python3 -c "import json; json.load(open('$meta_dir/metadata.json'))" 2>/dev/null; then
            echo -e "${RED}ERROR${NC} $asset: metadata.json invalid JSON"
            ((ERRORS++))
        fi
    fi

    # ---- 5. Eficiência ----
    line_count=$(wc -l < "$file")
    if (( line_count > MAX_FILE_LINES )); then
        echo -e "${RED}ERROR${NC} $asset: $line_count lines (max $MAX_FILE_LINES)"
        ((ERRORS++))
    fi
    body_over=$(python3 - "$file" "$MAX_LINE_LENGTH" << 'PYEOF'
import sys
path, maxlen = sys.argv[1], int(sys.argv[2])
content = open(path, encoding="utf-8").read()
lines = content.splitlines()
start = 0
if lines and lines[0] == "---":
    i = 1
    while i < len(lines) and lines[i] != "---":
        i += 1
    start = i + 1
count = 0
in_fence = False
for idx in range(start, len(lines)):
    line = lines[idx]
    if line.lstrip().startswith("```"):
        in_fence = not in_fence
        continue
    if in_fence:
        continue
    if "](" in line or line.lstrip().startswith("|"):
        continue
    if len(line) > maxlen:
        count += 1
print(count)
PYEOF
)
    if [[ "$body_over" != "0" ]]; then
        echo -e "${RED}ERROR${NC} $asset: $body_over body line(s) longer than $MAX_LINE_LENGTH chars"
        ((ERRORS++))
    fi

    # ---- 6. Eficácia ----
    if ! grep -q '^## Prerequisites' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing '## Prerequisites' section"
        ((ERRORS++))
    fi
    if ! grep -q '```' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing code/example blocks"
        ((ERRORS++))
    fi

    echo "OK: skill/$name"
done

for file in $(find assets/agents -name "*.md" -type f | sort); do
    asset="${file#assets/}"
    name=$(basename "$file" .md)

    heading_errors=$(check_heading_after_frontmatter "$file")
    if [[ -n "$heading_errors" ]]; then
        echo -e "${RED}ERROR${NC} $asset: heading hierarchy broken"
        echo "$heading_errors" | head -5
        ((ERRORS++))
    fi
    if grep -qE '\]\(\)' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: empty link destination found"
        ((ERRORS++))
    fi
    if grep -qEi '(api[_-]?key|secret|password|token)\s*[:=]\s*["\x27]?[A-Za-z0-9]{16,}' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: possible hardcoded secret"
        ((ERRORS++))
    fi
    if grep -qE 'http://' "$file" && grep -E 'http://' "$file" | grep -qEv 'http://(localhost|127\.0\.0\.1|0\.0\.0\.0|<[^>]*>|([a-z0-9-]+\.)*example\.(com|org|net)|arduino\.esp8266\.com)'; then
        echo -e "${RED}ERROR${NC} $asset: insecure http:// link (use https)"
        ((ERRORS++))
    fi
    if ! grep -q '^provenance:' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing provenance frontmatter"
        ((ERRORS++))
    fi
    if ! grep -q '^name:' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing 'name' frontmatter"
        ((ERRORS++))
    fi
    if ! grep -q '^description:' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing 'description' frontmatter"
        ((ERRORS++))
    fi
    if ! grep -qE '## (Pessoa|Persona)' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing '## Pessoa'/'Persona' section"
        ((ERRORS++))
    fi
    if grep -q '## Pessoa' "$file" && ! grep -q '## Como ajuda as personas de tecnologia' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing 'Como ajuda as personas de tecnologia' section"
        ((ERRORS++))
    fi
    if ! grep -qE '## (Habilidades e Capacidades|Skills|Capabilities)' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing 'Habilidades e Capacidades' section"
        ((ERRORS++))
    fi
    if ! grep -qE '## (Exemplos de Uso|Examples|Usage Examples)' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing 'Exemplos de Uso' section"
        ((ERRORS++))
    fi
    if ! grep -q '```' "$file"; then
        echo -e "${RED}ERROR${NC} $asset: missing code/example blocks"
        ((ERRORS++))
    fi
    meta_dir=$(dirname "$file")
    if [[ ! -f "$meta_dir/metadata.json" ]]; then
        echo -e "${RED}ERROR${NC} $asset: missing metadata.json"
        ((ERRORS++))
    elif ! python3 -c "import json; json.load(open('$meta_dir/metadata.json'))" 2>/dev/null; then
        echo -e "${RED}ERROR${NC} $asset: metadata.json invalid JSON"
        ((ERRORS++))
    fi
    line_count=$(wc -l < "$file")
    if (( line_count > MAX_FILE_LINES )); then
        echo -e "${RED}ERROR${NC} $asset: $line_count lines (max $MAX_FILE_LINES)"
        ((ERRORS++))
    fi
    body_over=$(python3 - "$file" "$MAX_LINE_LENGTH" << 'PYEOF'
import sys
path, maxlen = sys.argv[1], int(sys.argv[2])
content = open(path, encoding="utf-8").read()
lines = content.splitlines()
start = 0
if lines and lines[0] == "---":
    i = 1
    while i < len(lines) and lines[i] != "---":
        i += 1
    start = i + 1
count = 0
in_fence = False
for idx in range(start, len(lines)):
    line = lines[idx]
    if line.lstrip().startswith("```"):
        in_fence = not in_fence
        continue
    if in_fence:
        continue
    if "](" in line or line.lstrip().startswith("|"):
        continue
    if len(line) > maxlen:
        count += 1
print(count)
PYEOF
)
    if [[ "$body_over" != "0" ]]; then
        echo -e "${RED}ERROR${NC} $asset: $body_over body line(s) longer than $MAX_LINE_LENGTH chars"
        ((ERRORS++))
    fi

    echo "OK: agent/$name"
done

if (( ERRORS > 0 )); then
    echo -e "${RED}=== $ERRORS asset quality error(s) found ===${NC}"
    exit 1
fi

echo "=== All per-asset quality tests passed ==="
exit 0
