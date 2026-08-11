#!/bin/bash
set -euo pipefail

# Provenance Script
# 1. Backfills the `provenance` frontmatter block into every skill (SKILL.md)
#    and agent (.md) that does not yet have one (internal source).
# 2. Regenerates context/provenance.md with a registry of every asset and its
#    provenance (source, url, license, verified date).
#
# Usage: ./scripts/add-provenance.sh

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INTERNAL_URL="https://github.com/devtiagoabreu/opencode-engineering-kit"
VERIFIED_DATE="$(date -u +%Y-%m-%d)"

python3 - "$ROOT_DIR" "$INTERNAL_URL" "$VERIFIED_DATE" << 'PYEOF'
import os, re, sys

root, internal_url, verified = sys.argv[1], sys.argv[2], sys.argv[3]

INTERNAL = {
    "source": "OpenCode Engineering Kit (community)",
    "url": internal_url,
    "license": "MIT",
    "verified": verified,
}

def read_file(path):
    with open(path, encoding="utf-8") as f:
        return f.read()

def write_file(path, content):
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def parse_provenance(content):
    m = re.match(r"^---\n(.*?)\n---", content, re.DOTALL)
    if not m:
        return None
    front = m.group(1)
    if re.search(r"^provenance:\s*$", front, re.MULTILINE):
        src = re.search(r"^\s+source:\s*(.+)$", front, re.MULTILINE)
        url = re.search(r"^\s+url:\s*(.+)$", front, re.MULTILINE)
        lic = re.search(r"^\s+license:\s*(.+)$", front, re.MULTILINE)
        vrf = re.search(r"^\s+verified:\s*(.+)$", front, re.MULTILINE)
        return {
            "source": src.group(1).strip() if src else "unknown",
            "url": url.group(1).strip() if url else "",
            "license": lic.group(1).strip() if lic else "",
            "verified": vrf.group(1).strip() if vrf else "",
        }
    return None

def add_internal_provenance(content, provenance):
    if provenance:
        return content, provenance
    block = "provenance:\n  source: %s\n  url: %s\n  license: %s\n  verified: %s\n" % (
        INTERNAL["source"], INTERNAL["url"], INTERNAL["license"], INTERNAL["verified"])
    m = re.match(r"^---\n", content)
    if not m:
        return content, INTERNAL
    return content[:4] + block + content[4:], INTERNAL

def extract_meta(content):
    m = re.match(r"^---\n(.*?)\n---", content, re.DOTALL)
    front = m.group(1) if m else ""
    name = re.search(r"^name:\s*(.+)$", front, re.MULTILINE)
    desc = re.search(r"^description:\s*(.+)$", front, re.MULTILINE)
    return (name.group(1).strip() if name else ""), (desc.group(1).strip() if desc else "")

assets = []

def process_file(path, kind):
    content = read_file(path)
    provenance = parse_provenance(content)
    content, prov = add_internal_provenance(content, provenance)
    write_file(path, content)
    name, desc = extract_meta(content)
    assets.append((kind, name, desc, prov))

for skill_md in sorted(__import__("glob").glob(f"{root}/assets/skills/*/*/SKILL.md")):
    process_file(skill_md, "skill")

for agent_md in sorted(__import__("glob").glob(f"{root}/assets/agents/**/*.md", recursive=True)):
    process_file(agent_md, "agent")

lines = [
    "---",
    "name: provenance",
    "description: Registro de procedência (origem/licença) de todas as skills e personas do kit",
    "type: registry",
    "version: 0.1.0",
    "author: OpenCode Community",
    "---",
    "",
    "# Procedência (Provenance)",
    "",
    "Registro de origem de **cada** skill e persona do projeto. Gerado por",
    "`./scripts/add-provenance.sh`. Toda asset nova deve declarar `provenance` no",
    "frontmatter. Fontes citadas são públicas e verificadas na data indicada.",
    "",
    "## Skills",
    "",
    "| Asset | Procedência | URL | Licença | Verificado |",
    "|-------|-------------|-----|---------|------------|",
]
for kind, name, desc, prov in assets:
    if kind != "skill":
        continue
    lines.append(f"| `{name}` | {prov['source']} | {prov['url']} | {prov['license']} | {prov['verified']} |")

lines += ["", "## Personas (Agents)", "", "| Asset | Procedência | URL | Licença | Verificado |", "|-------|-------------|-----|---------|------------|"]
for kind, name, desc, prov in assets:
    if kind != "agent":
        continue
    lines.append(f"| `{name}` | {prov['source']} | {prov['url']} | {prov['license']} | {prov['verified']} |")

with open(f"{root}/context/provenance.md", "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")

print(f"Processed {len(assets)} assets ({sum(1 for a in assets if a[0]=='skill')} skills, {sum(1 for a in assets if a[0]=='agent')} agents)")
print(f"Registry written: {root}/context/provenance.md")
PYEOF
