# OpenCode Engineering Kit — User Guide

> Complete guide for using the OpenCode Engineering Kit

---

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Automatic Usage](#automatic-usage)
5. [Install and Manage the Kit by Voice Command](#install-and-manage-the-kit-by-voice-command)
6. [Worked Example — Next.js with GitHub and Vercel](#worked-example--nextjs-with-github-and-vercel)
7. [Skills](#skills)
8. [Agents](#agents)
9. [Prompts](#prompts)
10. [Templates](#templates)
11. [Commands](#commands)
12. [Playbooks and Recipes](#playbooks-and-recipes)
13. [Discovery System](#discovery-system)
14. [CLI](#cli)
15. [SkillPointer and Vault](#skillpointer-and-vault)
16. [Session Memory](#session-memory)
17. [Marketplace](#marketplace)
18. [Security](#security)
19. [Troubleshooting](#troubleshooting)

---

## Introduction

The **OpenCode Engineering Kit** is an open source library of reusable resources to accelerate productivity with AI-powered coding assistants. It works with:

- **OpenCode** (primary)
- **Claude Code**
- **Cursor**
- **GitHub Copilot** (partial)

### What's Included

- **150 Skills** — complete guides in 42 categories
- **103 Agents** — specialized AI personas in 38 categories
- **10 Prompts** — reusable prompt templates
- **4 Templates** — templates for projects and components
- **4 Commands** — documented actions for common tasks
- **3 Playbooks** — multi-step workflows
- **2 Recipes** — complete project setups
- **2 Bundles**, **2 Compositions**, **2 Prompt chains**
- **17 context files** + optional persistent memory (SQLite)
- **Automatic usage** — OpenCode checks and uses relevant skills/personas on its own
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

## Automatic Usage

When the kit is **installed in your project** (`npx opencode-engineering-kit install`), it works **automatically**: OpenCode checks on its own whether a relevant skill, persona (agent), prompt, playbook or recipe exists for the task and **uses it without you asking** — with only a short notice of what was used.

### How it works

The installer copies `context/AUTO_USAGE.md` to `.opencode/context/auto_usage.md` and registers it in `opencode.json` under `instructions`. From then on, for each task the assistant:

1. **Checks** for a relevant skill in `.opencode/skills/` (e.g., `nextjs-development`, `postgresql-database`).
2. **Checks** for a relevant persona in `.opencode/agents/` (e.g., `nextjs-developer`, `postgresql-dba`).
3. **Uses automatically** whatever is most productive, without asking.
4. **Keeps you informed** with a short notice, e.g., `Using the skill nextjs-development for this component` or `Acting as postgresql-dba to review this query`.

You do **not** need to run `search`, `list` or `doctor` for the kit to work — those tools remain available for lookup and diagnostics, but everyday usage is automatic.

### Automatic behavior examples

| Task | What OpenCode uses on its own |
|------|-------------------------------|
| Implement a search endpoint | Skill `nextjs-development` |
| Tune a slow query | Persona `postgresql-dba` |
| Build a C# API | Skill `csharp-best-practices` + persona `csharp-developer` |
| Review a PR | Persona `qa-engineer` or `code-reviewer` |
| Set up CI/CD | Skill `ci-cd-pipeline` |
| Audit security | Skill `owasp-top-10` |

### Disabling automatic usage

If you prefer manual control, remove the `.opencode/context/auto_usage.md` entry from `opencode.json > instructions` (or delete the file) and restart OpenCode. All assets remain available for manual use.

---

## Install and Manage the Kit by Voice Command

You can install and manage the kit **directly in the OpenCode chat**, without typing commands by hand. Just say (in PT or EN):

- `instale o ocekit do https://github.com/...` — OpenCode asks whether you want **global** (all projects) or **this project only**, installs it, and tells you the result.
- `status ocekit` — shows where the kit is installed and whether it is enabled.
- `stop ocekit` — disables the kit (keeps the files, removes the `opencode.json` wiring).
- `start ocekit` — re-enables the kit.

### How it works

The kit ships the **`ocekit-manager`** skill (auto-loaded when you mention "ocekit") and the **`/ocekit`** command. Both drive the CLI under the hood:

```bash
# Install into the current project (creates .opencode/ here)
npx opencode-engineering-kit install --repo <owner/repo>

# Install globally (into ~/.config/opencode/)
npx opencode-engineering-kit install --global --repo <owner/repo>

# Check state
npx opencode-engineering-kit status

# Disable / re-enable (keeps files)
npx opencode-engineering-kit stop
npx opencode-engineering-kit start
```

`--repo` accepts `owner/repo`, `https://github.com/owner/repo` or `git@github.com:owner/repo.git`. If you don't pass a link, it defaults to `devtiagoabreu/opencode-engineering-kit`.

### Global vs project

| Scope | Where it installs | Applies to |
|-------|-------------------|------------|
| **Project** | `.opencode/` + project `opencode.json` | Only that repository |
| **Global** | `~/.config/opencode/` (skills, agents, context) | All your projects |

After any change the kit reminds you to **restart OpenCode**.

---

## Worked Example — Next.js with GitHub and Vercel

**Scenario:** you are building a **Next.js (JavaScript)** app backed by **PostgreSQL**, in a local repo cloned from GitHub, where you **commit and push** daily and deploy on **Vercel**. You want to use the kit to speed up development.

### Step 1 — Install the kit in your project

From the local repo directory:

```bash
cd /path/to/your-project
npx opencode-engineering-kit install
```

The installer downloads the kit and creates the `.opencode/` directory inside your project, with skills, agents, commands, context, prompts, playbooks and templates, and wires up `opencode.json`. Confirm the installation:

```bash
npx opencode-engineering-kit doctor
```

### Step 2 — Find skills and personas for your stack

```bash
# Search Next.js and JavaScript skills
npx opencode-engineering-kit search "next.js"
npx opencode-engineering-kit search "javascript"

# Search database skills
npx opencode-engineering-kit search "postgresql"
```

Or use the kit's local discovery:

```bash
./core/discovery/search.sh "next.js"
./core/discovery/search.sh "postgresql"
```

### Step 3 — Use the right persona in OpenCode

Start OpenCode and ask it to use a kit persona, e.g. **nextjs-developer** or **javascript-developer**:

```text
Use the nextjs-developer persona to review this component.
```

Or tell OpenCode to read a skill before writing code:

```text
Read the nextjs-development skill and then implement the search
endpoint following the patterns described.
```

### Step 4 — Develop and validate

1. **Build the feature** following the Next.js skill:

    ```bash
    cd assets/skills/frontend/nextjs-development
    cat SKILL.md
    ```

2. **Validate code quality** with a review persona:

    ```text
    Use the qa-engineer persona to review the changes locally.
    ```

### Step 5 — Commit, push and deploy

1. **Commit and push** as usual:

    ```bash
    git add .
    git commit -m "feat: paginated search"
    git push origin main
    ```

2. **Vercel** detects the push and auto-deploys (Git Integration). The kit does not interfere with deployment — it only improves what you build before pushing.

### Step 6 — Update the kit

When a new kit version is released:

```bash
npx opencode-engineering-kit upgrade
```

---

## Skills

Skills are **complete guides** (instructions + examples + references) for the AI to execute specific tasks. Each skill has validated YAML frontmatter (name, description, category, version, author, compatibility) and a 600-line limit.

### Categories

| Category | Examples |
|----------|----------|
| `devops` | Docker, Kubernetes, CI/CD, Terraform, Monitoring, Incident Response, **Vercel**, **On-Premise** |
| `backend` | API Design, Auth, Caching, GraphQL, REST, Database, **Prisma ORM**, **FastAPI** |
| `frontend` | React, State Management, CSS, Accessibility, **Next.js**, **shadcn/ui**, **TanStack Query**, **Leaflet**, **Form Validation** |
| `languages` | JavaScript, TypeScript, Python, **C#**, **C++**, **C**, **PHP**, **Delphi** |
| `database` | SQL Optimization, NoSQL Modeling, **PostgreSQL**, **Oracle**, **SQL Server**, **SQLAlchemy/Alembic** |
| `testing` | Unit, Integration, E2E, Python Testing |
| `security` | OWASP Top 10, Secure Coding, SkillSpector, **RBAC** |
| `architecture` | Clean Architecture, Microservices, **Multi-Tenant SaaS**, **Plugin System**, **Event-Driven** |
| `logistics` | Supply Chain, **Route Optimization** |
| `methodology` | Brainstorming, Writing/Executing Plans, TDD, Git Worktrees, Code Review |
| `ai` | Deep Learning, RAG/LLM, LLM Multi-Provider |
| `vision` | OpenCV, **ONNX Object Detection**, **RTSP/ONVIF Cameras** |
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
| **nextjs-developer** | Next.js, App Router and Vercel specialist |
| **javascript-developer** | Modern JavaScript specialist (ES2015+, async) |
| **csharp-developer** | C# / .NET specialist |
| **php-developer** | PHP 8 and web security specialist |
| **delphi-developer** | Delphi / Object Pascal specialist |
| **cpp-developer** / **c-developer** | C++ and C specialists (memory, systems) |
| **postgresql-dba** / **oracle-dba** / **sql-server-dba** | Database administrators |
| + 90 more | construction, finance, marketing, science, health, education, music... |

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

Templates are starting points for new projects and components: `new-project`, `agent`, `skill`, and `prompt`.

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

Commands are documented actions for common OpenCode tasks: `/lint`, `/review`, `/test`, `/ocekit`. They live in `assets/commands/`.

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
