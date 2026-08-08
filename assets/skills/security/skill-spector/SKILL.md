---
name: skill-spector
description: Scan AI agent skills for vulnerabilities, prompt injection and supply-chain risks before installing them, using NVIDIA SkillSpector
category: security
version: 0.1.0
author: OpenCode Community
tags: [security, scanner, skills, prompt-injection, supply-chain, skillspector]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Python 3.12+ and uv or pip
  - A skill to scan (directory, zip, SKILL.md or Git URL)
provides:
  - Pre-install security vetting of agent skills
  - Risk score (0-100) with severity labels
  - SARIF/JSON/Markdown reports for CI
---

# Skill Spectator (NVIDIA SkillSpector)

## Overview

This skill applies [NVIDIA SkillSpector](https://github.com/NVIDIA/SkillSpector)
to answer one question before you install an agent skill: *should I install
this at all?* Skills execute with the same privileges as the agent — file
system, shell, network and environment access — yet most are loaded on trust.
SkillSpector detects 64 vulnerability patterns across 16 categories (prompt
injection, data exfiltration, privilege escalation, supply-chain, excessive
agency, system prompt leakage, MCP tool poisoning and more) using static
analysis plus optional LLM semantic evaluation.

Research behind the tool ("Agent Skills in the Wild") found 26.1% of skills
contain at least one vulnerability and 5.2% show likely malicious intent —
skills with executable scripts are 2.12x more likely to be vulnerable.

## Prerequisites

- Python 3.12+ with `uv` (or pip + virtualenv)
- The skill or repository you want to scan
- (Optional) an LLM API key for semantic analysis stage

## Usage Instructions

### 1. Install SkillSpector

```bash
uv tool install skillspector
```

Verify:

```bash
skillspector --help
```

### 2. Scan a skill before installing it

```bash
# Scan a directory
skillspector scan /path/to/skill

# Scan a single SKILL.md
skillspector scan /path/to/skill/SKILL.md

# Scan a zip archive
skillspector scan ./downloaded-skill.zip

# Scan a remote repository
skillspector scan https://github.com/user/skill-repo
```

### 3. Generate reports for review or CI

```bash
skillspector scan /path/to/skill --format json --output ./report.json
skillspector scan /path/to/skill --format markdown --output ./report.md
skillspector scan /path/to/skill --format sarif --output ./report.sarif
```

### 4. Use the Python API

```python
from skillspector import graph

result = graph.invoke({
    "input_path": "/path/to/skill",
    "output_format": "json",
    "use_llm": False,  # True enables semantic evaluation
})
print(result["risk_score"], result["findings"])
```

### 5. Integrate with this kit's marketplace

Before publishing or installing any asset through `core/marketplace`, run
SkillSpector on the skill directory and gate on the risk score:

```bash
skillspector scan ./assets/skills/new-skill --format json \
  | jq -r '.risk_score' | tee ./risk.txt
```

## Examples

### Example 1: Vet a skill from a marketplace

```bash
uv tool install skillspector
skillspector scan ./downloaded-skill.zip --format markdown --output ./vetting.md
less ./vetting.md
```

### Example 2: CI gate that fails on high risk

```bash
score=$(skillspector scan ./assets/skills/my-skill --format json | jq -r '.risk_score')
if [ "$score" -gt 60 ]; then
  echo "SKILL BLOCKED: risk score $score" >&2
  exit 1
fi
```

### Example 3: Semantic review with an LLM backend

```bash
skillspector scan ./plugin --use-llm --format terminal
```

## References

- [NVIDIA/SkillSpector](https://github.com/NVIDIA/SkillSpector)
- [Agent Skills in the Wild (research)](https://arxiv.org/pdf/2601.10338)
- [NVIDIA Verified Agent Skills](https://docs.nvidia.com/skills/scanning-agent-skills)

## Notes

- SkillSpector is static analysis; it cannot detect runtime behavior.
- Encrypted or compiled payloads cannot be analyzed.
- Combine with this kit's `core/security/secret-scan.sh` for credential
  leakage and `core/security/dependency-audit.sh` for supply-chain checks.
- Treat scores above 60 as a blocker for automatic installs.
