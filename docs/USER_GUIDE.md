# OpenCode Engineering Kit — User Guide

> Complete guide for using the OpenCode Engineering Kit

---

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Skills](#skills)
5. [Agents](#agents)
6. [Prompts](#prompts)
7. [Templates](#templates)
8. [Commands](#commands)
9. [Playbooks and Recipes](#playbooks-and-recipes)
10. [Discovery System](#discovery-system)
11. [CLI](#cli)
12. [SkillPointer and Vault](#skillpointer-and-vault)
13. [Session Memory](#session-memory)
14. [Marketplace](#marketplace)
15. [Security](#security)
16. [Troubleshooting](#troubleshooting)

---

## Introduction

The **OpenCode Engineering Kit** is an open source library of reusable resources to accelerate productivity with AI-powered coding assistants. It works with:

- **OpenCode** (primary)
- **Claude Code**
- **Cursor**
- **GitHub Copilot** (partial)

### What's Included

- **123 Skills** — complete guides in 42 categories
- **93 Agents** — specialized AI personas in 38 categories
- **10 Prompts** — reusable prompt templates
- **16 Templates** — project and component templates
- **3 Commands** — documented actions for common tasks
- **3 Playbooks** — multi-step workflows
- **2 Recipes** — complete project setups
- **2 Bundles**, **2 Compositions**, **2 Prompt chains**
- **15 context files** + optional persistent memory (SQLite)
- **SkillPointer/Vault** — on-demand loading of curated content

---

## Installation

### Method 1 — CLI (recommended)

Installs the kit into **any existing project**, copying assets into `.opencode/`:

```bash
cd /path/to/your/project
npx opencode-engineering-kit install
```

After installing, **restart OpenCode** to load the configuration.

### Method 2 — Global install via curl

```bash
curl -fsSL https://raw.githubusercontent.com/devtiagoabreu/opencode-engineering-kit/main/install.sh | bash
```

To use the scripts on PATH:

```bash
export PATH="$PATH:$HOME/.opencode-engineering-kit/scripts"
```

Update: `~/.opencode-engineering-kit/scripts/update.sh` (or `./update.sh` inside the repo). Remove: `./uninstall.sh`.

### Method 3 — Clone the repository

```bash
git clone https://github.com/devtiagoabreu/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

### Prerequisites

- **Git 2.0+**
- **Bash 4.0+**
- **Node.js 18+** (for the CLI via `npx`)
- **OpenCode** (recommended)

---

## Quick Start

### Using a Skill

1. Navigate to the skill:

    ```bash
    cd assets/skills/devops/docker-best-practices
    ```

2. Read the `SKILL.md` file and follow the instructions:

    ```bash
    cat SKILL.md
    ```

### Using an Agent

1. Navigate to the agent:

    ```bash
    cd assets/agents/backend/backend-developer
    ```

2. Read the persona file:

    ```bash
    cat backend-developer.md
    ```

3. Use the agent persona in your conversations.

### Copying a skill into your project

```bash
cp -r assets/skills/devops/docker-best-practices/ /your/project/
```

---

## Skills

Skills are **complete guides** (instructions + examples + references) for the AI to execute specific tasks. Each skill has validated YAML frontmatter (name, description, category, version, author, compatibility) and a 500-line limit.

### Categories

| Category | Examples |
|----------|----------|
| `devops` | Docker, Kubernetes, CI/CD, Terraform, Monitoring, Incident Response |
| `backend` | API Design, Auth, Caching, GraphQL, REST, Database |
| `frontend` | React, State Management, CSS, Accessibility |
| `testing` | Unit, Integration, E2E, Python Testing |
| `security` | OWASP Top 10, Secure Coding, SkillSpector |
| `methodology` | Brainstorming, Writing/Executing Plans, TDD, Git Worktrees, Code Review |
| `ai` | Deep Learning, RAG/LLM, LLM Multi-Provider |
| `tools` | Advanced Git, Terminal, Repo → LLM, Graphify, Session Memory |
| + 34 more | construction, finance, marketing, education, health, cloud, music, arts... |

### How to Use a Skill

1. **Find the skill** you need:

    ```bash
    ./core/discovery/search.sh "docker"
    ```

2. **Read the skill** documentation:

    ```bash
    cat assets/skills/devops/docker-best-practices/SKILL.md
    ```

3. **Follow the instructions** and **apply the best practices** to your project.

---

## Agents

Agents are **personas** (role + context + communication style) for specific roles. Each domain persona collaborates with the technology personas (see the "Como ajuda as personas de tecnologia" section in each file).

### Available Agents

| Agent | Description |
|-------|-------------|
| **devops-engineer** | Infrastructure and CI/CD specialist |
| **backend-developer** | APIs and backend specialist |
| **frontend-developer** | UI/UX and frontend specialist |
| **fullstack-developer** | Full-stack specialist |
| **security-engineer** | Security specialist |
| **qa-engineer** | Quality assurance specialist |
| **data-scientist** | ML / deep learning and data analysis |
| **ai-engineer** | RAG and LLM integration |
| **technical-writer** | Documentation specialist |
| **product-manager** | Product management specialist |
| **orquestrador** | Plans tasks, delegates to the right agents and shows tool provenance |
| + 80 more | construction, finance, marketing, science, health, education, music... |

### How to Use an Agent

1. **Find the agent** you need:

    ```bash
    ./core/discovery/search.sh "backend"
    ```

2. **Read the agent** documentation:

    ```bash
    cat assets/agents/backend/backend-developer/backend-developer.md
    ```

3. **Use the persona** in your conversations with AI assistants.

---

## Prompts

Prompts are reusable templates for common tasks (with `{{variable}}` placeholders): code review, debugging, refactoring, planning, architecture (system design), API documentation, testing strategy, security audit, RAG and performance review.

### How to Use a Prompt

```bash
# Find the prompt
./core/discovery/search.sh "code review"

# Read the prompt
cat assets/prompts/code-review/code-review-checklist.md
```

Copy the prompt to your clipboard and paste it into your AI assistant.

---

## Templates

Templates are starting points for new projects and components: `new-project`, `react`, `nextjs`, `api`, `docker`, `docker-compose`, `github-actions`, `postgresql`, `mqtt`, `esp32`, `opencv`, `adr`, `agent`, `skill`, `prompt` and `readme`.

### How to Use a Template

```bash
# List the templates
ls assets/templates/

# Copy a template to your project
cp -r assets/templates/new-project /your/project/
```

Customize the files for your needs.

---

## Commands

Commands are documented actions for common OpenCode tasks: `/lint`, `/review`, `/test`. They live in `assets/commands/`.

```bash
ls assets/commands/
cat assets/commands/review.md
```

---

## Playbooks and Recipes

- **Playbooks** (multi-step workflows): `code-review-process`, `new-project-setup`, `whatsapp-bot-setup` — in `assets/playbooks/`
- **Recipes** (complete solutions): `python-project-setup`, `react-project-setup` — in `assets/recipes/`

```bash
ls assets/playbooks/
cat assets/playbooks/new-project-setup.md
```

---

## Discovery System

The discovery system helps you find assets by keyword, category, compatibility or affinity.

### Search for Assets

```bash
# Search by keyword
./core/discovery/search.sh "docker"

# Filter by category
./core/discovery/filter.sh --category=devops

# Filter by compatibility
./core/discovery/filter.sh --compatible=opencode

# Find related assets
./core/discovery/related.sh docker-best-practices

# Recommendations
./core/discovery/recommend.sh
```

### Generate Index

```bash
./core/discovery/index.sh
```

### View Index

```bash
cat core/discovery/index/skills.txt
cat core/discovery/index/agents.txt
```

---

## CLI

The CLI (`npx opencode-engineering-kit`) provides commands to install and manage the kit:

| Command | Description |
|---------|-------------|
| `install` | Installs skills, agents, commands and context into `.opencode/` |
| `list` | Lists assets (skills, agents, prompts, templates) |
| `search <term>` | Searches assets by keyword |
| `doctor` | Checks kit integrity (schema, indexes, security scan, dependencies) |
| `upgrade` | Re-installs with `--force` from the latest remote revision |
| `export <harness>` | Generates packages for other harnesses (`.claude`, `.cursor`, `CLAUDE.md`, `.opencode`) |

### Examples

```bash
# Install into the current project
npx opencode-engineering-kit install

# Install only skills and agents, forcing overwrite
npx opencode-engineering-kit install --only skills,agents --force

# Use a local checkout (offline mode)
npx opencode-engineering-kit install --source /path/to/opencode-engineering-kit

# List skills as JSON
npx opencode-engineering-kit list --type skills --json

# Export for Claude Code
npx opencode-engineering-kit export claude
```

---

## SkillPointer and Vault

Pointer skills are minimal catalog entries: the `SKILL.md` stays small and the full content lives in `assets/vault/<category>/<skill>/`. This **avoids context injection**: content is loaded on demand, only when the task needs it.

### Pointer commands

```bash
# Resolve the full content of a skill (SKILL.md or vault entry)
./core/discovery/pointer.sh resolve repo-to-llm

# Vault info (meta + token estimate)
./core/discovery/pointer.sh vault repo-to-llm

# Token estimate for a file
./core/discovery/pointer.sh tokens assets/vault/tools/repo-to-llm/content.md

# List vault entries (or only pointer skills with --pointer)
./core/discovery/pointer.sh list
./core/discovery/pointer.sh list --pointer

# Check whether a skill is a pointer
./core/discovery/pointer.sh is-pointer repo-to-llm
```

### Current curated entries

| Skill | Vault | Tokens (approx.) |
|-------|-------|------------------|
| `repo-to-llm` | `tools/repo-to-llm` | 828 |
| `code-knowledge-graph` | `tools/code-knowledge-graph` | 767 |
| `skill-spector` | `security/skill-spector` | 779 |

The `cli doctor` checks consistency between pointer skills and vault entries (broken links, missing entries).

---

## Session Memory

The kit has optional local-first persistent memory (enabled with `KIT_MEMORY=1`). Notes are stored in SQLite (outside the repository) and can be searched back later.

```bash
export KIT_MEMORY=1
python3 context/memory/memory.py init
```

Optional vector recall:

```bash
pip install chromadb
export KIT_MEMORY_VECTOR=1
```

The skill `assets/skills/tools/session-memory/SKILL.md` documents the full flow (save, search, healthcheck).

---

## Marketplace

The marketplace lets you publish, search and rate assets.

### Browse Assets

1. Open the marketplace web interface:

    ```bash
    open marketplace-web/index.html
    ```

2. Use the search and filters to find assets.

### Install Assets via CLI

```bash
# Install a skill
./core/marketplace/install.sh skill docker-best-practices

# Install an agent
./core/marketplace/install.sh agent backend-developer
```

### Publish and Rate

```bash
# Search assets
./core/marketplace/search.sh "docker"

# Rate an asset
./core/marketplace/rate.sh add --asset <name> --reviewer <user> --rating <1-5>

# Publish an asset
./core/marketplace/publish.sh --type skill --path ./assets/skills/my-skill
```

---

## Security

The kit includes security tools for auditing your project and the content of the assets.

### Security Audits

```bash
# Skill content scan (PASS/WARN/FAIL gate with allowlist)
./core/security/skill-scan.sh

# Dependency audit
./core/security/dependency-audit.sh

# Secret scanning
./core/security/secret-scan.sh

# Vulnerability scanning
./core/security/vulnerability-scan.sh

# Access control check
./core/security/access-control.sh

# Audit logging
./core/security/audit-log.sh
```

### Security Best Practices

1. **Never commit secrets** — use environment variables
2. **Run security audits** regularly
3. **Keep dependencies updated**
4. **Follow secure coding practices**
5. Before installing a third-party skill, run SkillSpector (the `skill-spector` skill)

---

## Troubleshooting

### Common Issues

#### Issue: Scripts not executable

```bash
chmod +x scripts/*.sh
chmod +x core/**/*.sh
chmod +x tests/**/*.sh
```

#### Issue: Discovery system not finding assets

```bash
# Regenerate the index
./core/discovery/index.sh
```

#### Issue: Tests failing

```bash
# Run all tests
./scripts/test.sh

# Run a specific test
./tests/skills/test-skill-content.sh
```

#### Issue: Validation errors

```bash
# Validate all assets
./core/validator/validate-all.sh

# Validate a directory (expects skills/ and agents/ inside)
./core/validator/validate.sh assets
```

#### Issue: Kit integrity

```bash
# Check schema, indexes, security scan, dependencies and vault
npx opencode-engineering-kit doctor
```

### Getting Help

- **GitHub Issues**: <https://github.com/devtiagoabreu/opencode-engineering-kit/issues>
- **Documentation**: See the `docs/` directory
- **Examples**: See the `examples/` directory

---

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for details.

### Quick Contribution Guide

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests (`./scripts/test.sh`)
5. Submit a pull request

---

## License

This project is licensed under the MIT License — see the [LICENSE](./LICENSE) file for details.

---

## Acknowledgments

- [OpenCode](https://opencode.ai) for the platform
- [Shokunin](https://github.com/EliasOulkadi/shokunin) for inspiration
- [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill) for inspiration
- All contributors who help improve this project
