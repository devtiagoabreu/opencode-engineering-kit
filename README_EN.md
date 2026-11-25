# OpenCode Engineering Kit

> Engineering kit to accelerate working with OpenCode: ready-to-use Skills, Agents, Prompts, Templates, Playbooks, Commands and Context — installable in any repository in seconds.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/devtiagoabreu/opencode-engineering-kit)
[![OpenCode](https://img.shields.io/badge/OpenCode-compatible-brightgreen.svg)](https://opencode.ai)
[![CI](https://github.com/devtiagoabreu/opencode-engineering-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/devtiagoabreu/opencode-engineering-kit/actions/workflows/ci.yml)

## About

The **OpenCode Engineering Kit** is an open source library of reusable assets for developers using [OpenCode](https://opencode.ai) (and compatible tools). Instead of recreating configs, prompts, and workflows from scratch on every project, you install the kit and immediately get a standardized, tested set of **skills, agents, prompts, templates, playbooks, commands, and context**.

Inspired by projects like [Shokunin](https://github.com/EliasOulkadi/shokunin) and [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill), the kit is **simple (plain Markdown), modular, portable, and model-agnostic**.

> **README (Português):** [README.md](./README.md)  
> **Status:** active evolution. See [docs/AUDIT_AND_PR_PLAN.md](./docs/AUDIT_AND_PR_PLAN.md) for diagnosis and execution plan.

### Current state

| Item | Quantity |
|------|----------|
| Skills | 183 (42 categories) |
| Agents | 107 (38 categories) |
| Prompts | 10 |
| Templates | 11 |
| Playbooks | 3 |
| Recipes | 2 |
| Commands | 7 |
| Bundles | 2 |
| Compositions | 2 |
| Prompt chains | 2 |
| Context files | 17 files |
| Example plugins | 1 (`asset-linter`) |
| Test suites | 26 shell + 3 CLI (26 `node:test` cases) |

> Counts above are synced from `core/registry/manifest.json` via `python scripts/sync_readme_counts.py --root .` (verified in CI).

### Compatibility

| Platform | Status |
|----------|--------|
| OpenCode | ✅ Primary (native format) |
| Claude Code | ✅ Compatible (via `CLAUDE.md`) |
| Cursor | ✅ Compatible (via `.cursor/rules/`) |
| GitHub Copilot | ⚠️ Partial (via instructions) |

---

## Quick start (5 minutes)

```bash
cd /path/to/your-project
npx opencode-engineering-kit install
npx opencode-engineering-kit status
npx opencode-engineering-kit list --type skills
npx opencode-engineering-kit search docker
```

Then restart OpenCode. The kit lives in `.opencode/` and `opencode.json` is merged (not overwritten).

> **Note:** `opencode-engineering-kit@0.1.0` is published on the npm registry, so the plain `npx ...` commands below work directly. For a local checkout (development), add `--source /path/to/opencode-engineering-kit`. See the [npm publishing playbook](./docs/NPM_PUBLISH_PLAYBOOK.md).

## Installation

### Prerequisites

- **Git 2.0+** — to clone and install via script
- **Bash 4.0+** — for install scripts (Linux/macOS/WSL)
- **Node.js 18+** — to install via CLI (`npx`)
- **`tar`** available in PATH (used by the CLI; present on Linux/macOS; included with Git for Windows)

---

### Method 1 — CLI: install into an existing repository (recommended)

The fastest way to use the kit inside **any existing project**. The CLI downloads the kit, copies the assets to `.opencode/`, and updates the project's `opencode.json` — no manual cloning.

```bash
cd /path/to/your-project
npx opencode-engineering-kit install
```

What happens:

```
your-project/
├── .opencode/
│   ├── skills/        # assets/skills (all categories)
│   ├── agents/        # assets/agents (flattened names: backend-developer.md)
│   ├── commands/      # assets/commands
│   ├── context/       # context/*.md (registered in instructions)
│   ├── assets/        # prompts, playbooks, recipes, templates (reference)
│   ├── core/          # indexes, registry, resolver, security, quality
│   ├── scripts/       # validation, generation and tests (used by doctor)
│   └── docs/          # documentation and provenance mappings
└── opencode.json      # skills.paths + instructions (merged with existing)
```

Then **restart OpenCode** so the new configuration is loaded.

#### CLI commands

| Command | Description |
|---------|-------------|
| `install` | Install skills, agents, commands, context, assets, `core/`, `scripts/` and `docs/` into a project (or globally with `--global`) |
| `status` | Show where the kit is installed and whether it is enabled |
| `start` | Re-enable the kit (restore the wiring recorded in `.kit-install.json`) |
| `stop` | Disable the kit (keep files, remove `opencode.json` wiring) |
| `list` | List assets from the checkout or the installed project |
| `search` | Search assets by keyword in name/description |
| `doctor` | Validate schema, links, policy, UTF-8, README counts, indexes, lockfile, security scan, vault and optional tests |
| `upgrade` | Reinstall with `--force`, reusing `--profile`/`--only` from the manifest when omitted |
| `export` | Generate a package: `export <claude\|cursor\|opencode\|claude-md> --target <dir> [--dry-run]` |

#### `install` options

| Option | Description |
|--------|-------------|
| `--target <dir>` | Target project directory (default: current directory) |
| `--global` | Install into global OpenCode config (`~/.config/opencode/`) |
| `--source <dir>` | Use a local kit checkout instead of downloading from GitHub |
| `--repo <repo>` | Kit GitHub repo (default: `devtiagoabreu/opencode-engineering-kit`) |
| `--branch <b>` | Kit branch/tag (default: `main`) |
| `--profile <name>` | Curated profile: `core`, `backend`, `frontend`, `devops`, `ai`, `brasil`, `full` |
| `--only <list>` | Subset: `skills,agents,commands,context,assets,core,scripts,docs` (default: all) |
| `--force` | Overwrite existing files in `.opencode/` |
| `--dry-run` | Show what would be done without touching the disk |
| `--verbose` | List each copied file |

#### Curated profiles

| Profile | Best for | Selection |
|---------|----------|-----------|
| `core` | Minimal trusted setup | Curated skills/agents/commands/context |
| `backend` | APIs/data | Backend/data skill categories + full agents/commands/context |
| `frontend` | UI/web | Frontend/design skill categories + full agents/commands/context |
| `devops` | Platform/CI/cloud | DevOps/cloud/security skill categories + full agents/commands/context |
| `ai` | LLM/RAG/vision | AI/analytics/vision/tools skill categories + full agents/commands/context |
| `brasil` | Brazil domain packs | Brazil-domain skill categories + full agents/commands/context |
| `full` | Full catalog | `*` for all groups |

#### Usage examples

```bash
# Install curated profile (less context noise)
npx opencode-engineering-kit install --profile core

# Upgrade reuses profile/only from .opencode/.kit-install.json when omitted
npx opencode-engineering-kit upgrade

# Install only skills and agents, forcing overwrite
npx opencode-engineering-kit install --only skills,agents --force

# Install globally (applies to all projects)
npx opencode-engineering-kit install --global

# Offline / development mode: use a local kit checkout
npx opencode-engineering-kit install --source /path/to/opencode-engineering-kit

# Simulate without changing anything
npx opencode-engineering-kit install --dry-run

# Lifecycle: check state, disable and re-enable
npx opencode-engineering-kit status
npx opencode-engineering-kit stop
npx opencode-engineering-kit start

# Discovery and diagnostics
npx opencode-engineering-kit list --type skills
npx opencode-engineering-kit search "docker kubernetes"
npx opencode-engineering-kit doctor --fast
npx opencode-engineering-kit doctor --dir . --target . --fast
npx opencode-engineering-kit upgrade --dry-run
```

> `list`, `search` and `doctor` auto-detect an installed project: they work from the project root because the installer copies `core/`, `scripts/` and `docs/` into `.opencode/`.

---

### Method 2 — Global install script (via curl)

Installs a copy of the kit at `~/.opencode-engineering-kit`, useful for consulting skills and running core scripts from anywhere.

```bash
curl -fsSL https://raw.githubusercontent.com/devtiagoabreu/opencode-engineering-kit/main/install.sh | bash
```

To use the scripts on the PATH:

```bash
export PATH="$PATH:$HOME/.opencode-engineering-kit/scripts"
```

**Update** the global install:

```bash
~/.opencode-engineering-kit/scripts/update.sh
# or, inside the cloned repo:
./update.sh
```

**Remove** the global install:

```bash
./uninstall.sh
```

---

### Method 3 — Clone the repository

```bash
git clone https://github.com/devtiagoabreu/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

`bootstrap.sh` creates the directory structure and the expected categories.

---

## Trust and install model

- **What the CLI does:** copies assets into `.opencode/` and merges `opencode.json` (`skills.paths`, `instructions`). It does not delete your existing config.
- **Audit before install:** use `--dry-run` and/or `--source <local-checkout>` to inspect source. Run `npx opencode-engineering-kit doctor --fast` on the kit checkout.
- **Post-install drift:** run `npx opencode-engineering-kit doctor --dir <kit> --target <project> --fast` to check wiring and tracked-file drift (`.opencode/.kit-install.json`). If you see `modified/missing`, reinstall with `--force` or run `upgrade`.
- **Diagnostics inside the installed project:** `list`, `search` and `doctor` auto-detect `.opencode/`; no need to point at the kit checkout.
- **JSON contract:** `doctor --json` exposes stable `checks[].code`, `checks[].skipped` (distinguishes "not run" from "passed") and actionable `recommendations[]`; useful for CI and automation.
- **Safe disable:** `stop` removes only kit wiring from `opencode.json`; `start` restores exactly what install recorded (respecting profiles and `--only`).
- **Current limits:** supply-chain verification is still evolving (schema/scan/provenance/lock). See [docs/AUDIT_AND_PR_PLAN.md](./docs/AUDIT_AND_PR_PLAN.md) for PR-02/PR-05 and [docs/QUALITY_POLICY.md](./docs/QUALITY_POLICY.md) for the rules enforced today (maturity, provenance and links).
- **Reference integrations:** capabilities adapted from the twenty named external repositories are mapped in [docs/REFERENCE_CAPABILITIES.md](./docs/REFERENCE_CAPABILITIES.md), [docs/PLATFORM_REFERENCE_CAPABILITIES.md](./docs/PLATFORM_REFERENCE_CAPABILITIES.md) and [docs/FISCAL_ENGINE_CAPABILITIES.md](./docs/FISCAL_ENGINE_CAPABILITIES.md), with licenses and scope made explicit.
- **Continuous learning:** the `/aprenda` command follows the canonical 20-repository queue in [docs/APRENDA_REPOSITORIOS.md](./docs/APRENDA_REPOSITORIOS.md), including the official Receita Federal tax engines, and regenerates provenance-tagged `beta` assets.
- **Security:** report vulnerabilities per [SECURITY.md](./SECURITY.md).

## Core vs optional/experimental

| Area | Role | Recommended maturity |
|------|------|----------------------|
| `assets/skills`, `agents`, `commands`, `context` | Direct use in projects via CLI | Core (default path) |
| `cli/` | Install and lifecycle | Core |
| `core/quality`, `core/security`, `core/registry` | Validation, scan, metadata | Core, hardening |
| `core/plugin`, `core/marketplace`, `core/resolver`, `core/version` | Platform infrastructure | Optional/advanced |
| `marketplace-web/`, `plugins/` | Discovery and extensions | Optional/experimental |

---

## What the kit contains (detailed)

### Skills — 183 ready guides

Skills are **complete guides** (instructions + examples + references) that enable the AI to perform specific tasks. Each skill has validated YAML frontmatter (name, description, category, version, author, compatibility) and a 600-line limit.

| Category | Examples |
|----------|----------|
| `ai` | Deep Learning, RAG/LLM, Evolution API, LLM Multi-Provider, Free LLMs, Context Filesystem Memory, Memory Discipline, AI SDK Agent Patterns |
| `analytics` | Business Intelligence, Privacy-First Analytics |
| `automation` | n8n Workflow Automation, LLM Workflow Orchestration |
| `design` | Design System, UI/UX, Design Tokens (DTCG), UI Visual Craft, Design Review Critic, Diagram Design |
| `documentation` | Doc → Markdown (MarkItDown) |
| `robotics` | ROS 2, control and simulation |
| `embedded` | Arduino, ESP32, ESP8266, Raspberry Pi, RTOS |
| `devops` | Docker, Kubernetes, CI/CD, Terraform, Monitoring, Incident Response, **On-Premise**, Self-Host Deployment, Vercel Runtime & Cache |
| `backend` | API Design, Auth, Caching, GraphQL, REST, Database, **FastAPI** |
| `frontend` | React, State Management, CSS, Accessibility, **A11y Audit (WCAG 2.2)**, Registry Distribution, Transactional Email Patterns |
| `testing` | Unit, Integration, E2E, Python Testing |
| `security` | OWASP Top 10, Secure Coding, SkillSpector (skill scanning), **RBAC**, Auth Plugin Architecture, **Next.js Web Security** |
| `git` | Git Workflow |
| `vision` | OpenCV, **ONNX Object Detection**, **RTSP/ONVIF Cameras** |
| `languages` | Python, **Python Modern Tooling (uv/ruff)**, TypeScript, **C#**, **C++**, **C**, **PHP**, **Delphi** |
| `iot` | MQTT, Sensors |
| `tools` | Advanced Git, Terminal, Repo → LLM, Code graph (Graphify) |
| `quality` | Code Review, Refactoring, Context/token optimization |
| `construction` | Construction execution, civil structures |
| `finance` | Accounting, taxes (Brazilian Simples Nacional), Usage-Based Billing, Bank Reconciliation, Financial Statements/DRE, Controllership Close, Fiscal Engine Integration |
| `marketing` | Digital marketing, traffic management, political marketing (election law) |
| `science` | Applied mathematics, physics, chemistry, Scientific Data Retrieval |
| `engineering` | Mechatronics, industrial automation, home automation, production planning |
| `logistics` | Supply chain, **Route Optimization** |
| `web` | Web scraping, Google Workspace/Looker Studio, Browser Use Automation |
| `management` | Lean Methodology, Psychology for People Governance |
| `health` | Crisis protocol, screening scales, psychoeducation frameworks, ADHD executive function, neurodiversity support, nutrition, podiatry |
| `cloud` | AWS and Google Cloud architecture |
| `education` | Lesson planning, teaching methods, assessment, evidence-based teaching, vestibular (ENEM/FUVEST/VUNESP) |
| `music` | Music theory, Suzuki Method |
| `arts` | Drawing, fashion, makeup, screenwriting |
| `sports` | Physical preparation |
| `automotive` | Automotive diagnostics and repair |
| `commercial` | E-commerce, CRM, plastics, weaving |
| `humanities` | Geopolitics, political analysis, labor law, criminal law |
| `architecture` | Clean Architecture, Microservices, Plugin System, Harness Engineering Patterns |
| `database` | PostgreSQL, RLS Tenancy, Database Branching Workflows |
| `projects` | Project Setup, SaaS Blueprint Patterns |
| + code-review, community | — |

**LLM context focus:** new skills cover the trending context/token ecosystem on
GitHub — `doc-to-markdown` ([MarkItDown](https://github.com/microsoft/markitdown)),
`repo-to-llm` ([gittomd](https://gittomd.com) / `llms.txt`),
`code-knowledge-graph` ([Graphify](https://github.com/Graphify-Labs/graphify))
and `context-optimization` ([Repomix](https://github.com/yamadashy/repomix) +
compaction/cache). `skill-spector` integrates the security scanner
[NVIDIA SkillSpector](https://github.com/NVIDIA/SkillSpector) into the plugin
installation flow.

All skills are copied automatically to `.opencode/skills/` when installing via
the CLI (`npx opencode-engineering-kit install`) — new categories are detected
recursively, with no extra configuration.

### Agents — 107 ready personas

Agents are **personas** (role + context + communication style) for specific roles. Examples:

| Agent | Description |
|-------|-------------|
| `backend-developer` | APIs and backend |
| `frontend-developer` | UI/UX and frontend |
| `devops-engineer` | Infrastructure and CI/CD |
| `site-reliability-engineer` | SRE |
| `security-engineer` | Security and hardening |
| `ai-engineer` | RAG, LLM integration |
| `data-scientist` | ML / deep learning and data analysis |
| `automation-engineer` | n8n workflows and WhatsApp bots |
| `bi-analyst` | Dashboards, KPIs and reports |
| `robotics-engineer` | ROS 2 and robotics |
| `orquestrador` | Plans tasks, delegates to the right agents and shows tool provenance |
| + architect, planner, reviewer, qa, performance, documentation, database, embedded, vision | — |

#### Domain personas (construction, finance, design, marketing, science, humanities, engineering, logistics, web, health, management, cloud, education, music, arts, sports, commercial, law, languages)

Each domain persona **collaborates with the tech personas**, providing technical
parameters from its area while always looking at what the user is trying to
create (the "How it helps tech personas" section in each file). Content is in
Portuguese, with headers compatible with the kit's tests.

| Category | Personas |
|----------|----------|
| `construction` | pedreiro, engenheiro-civil, arquiteto, desenhista-tecnico, pintor |
| `finance` | contador, fiscal, analista-financeiro, controladoria |
| `design` | designer-de-interiores, designer-de-tecidos, designer-digital, design-reviewer |
| `marketing` | marketing-digital, gestor-de-trafego, marketeiro-politico, criador-de-jingles-politicos |
| `science` | matematico, fisico, quimico |
| `humanities` | historiador, filosofo, analista-geopolitico, analista-politico, advogado-trabalhista, criminalista |
| `engineering` | engenheiro-mecatronico, engenheiro-de-producao, especialista-em-automacao-industrial, especialista-em-automacao-residencial |
| `logistics` | especialista-em-logistica |
| `web` | webscraper, especialista-google-workspace |
| `health` | psicologo, psiquiatra, especialista-em-autismo, especialista-em-tdah, nutricionista, podologo |
| `management` | metodologia-lean, psicologo-organizacional |
| `cloud` | arquiteto-aws-cloud, arquiteto-google-cloud |
| `education` | professor-de-historia, professor-de-geografia, professor-de-matematica, professor-de-fisica, professor-de-quimica, professor-de-filosofia, professor-de-etica, professor-de-sociologia, professor-de-robotica, professor-de-artes, professor-de-educacao-fisica, especialista-em-alfabetizacao, preparador-vestibular |
| `music` | musico, especialista-metodo-suzuki |
| `arts` | maquiador, estilista, cabeleireiro, bailarina, coreografo, roteirista |
| `sports` | personal-trainer |
| `automotive` | mecanico, mecanico-de-aviao |
| `commercial` | equipe-comercial-tecelagem, especialista-comercial-plasticos, equipe-comercial-ecommerce, relacoes-com-o-cliente |
| `languages` | professor-de-idiomas |
| `planner` | product-manager, orquestrador |
| `ai` | ai-engineer, data-scientist, especialista-em-llms |

> **Health note:** health personas have an **educational and support** focus,
> do not replace healthcare professionals, and do not issue diagnoses or
> prescriptions.
>
> **Law note:** legal personas are **educational and informational** only; they
> do not replace the guidance of a licensed attorney for concrete cases.
>
> **Politics note:** political personas present factual, plural analysis, respect
> Brazilian election law (TSE) and reject disinformation and hate speech.

### Prompts — 10 reusable

Focused prompts for one-off interactions: code review, debugging, refactoring, planning, architecture (system design), API documentation, test strategy, security audit, RAG, and performance review. They use `{{variable}}` placeholders.

### Templates — 11 for projects and components

`new-project`, `agent`, `skill`, `prompt`, `agent-session-handoff`, `harness-checklist`, `scientific-retrieval-ledger`, `monthly-close-checklist`, `saas-launch-checklist`, `billing-meter-spec` and `fiscal-calculation-record`.

### Playbooks and Recipes

- **Playbooks** (multi-step flows): `code-review-process`, `new-project-setup`, `whatsapp-bot-setup`
- **Recipes** (complete solutions): `python-project-setup`, `react-project-setup`

### Commands

- `/lint`, `/review`, `/test` — documentation of OpenCode's native commands
- `/ocekit` — install and manage the kit (install, status, start, stop) straight from the chat
- `/aprenda` — run the canonical reference-repository learning queue
- `/harness-review` — review a harness engineering flow against the adapted patterns
- `/diagram` — generate diagrams using the `diagram-design` skill

### Bundles, Compositions, and Prompt chains

- **Bundles**: `backend-starter`, `devops-starter` (ready asset packs)
- **Compositions**: `full-stack-team`, `platform-team`
- **Prompt chains**: `feature-delivery`, `incident-response`

### Context (`context/`)

17 AI-optimized context files: `project`, `stack`, `architecture`, `conventions`, `decisions`, `documentation`, `git`, `glossary`, `naming`, `performance`, `security`, `style_guide`, `coding_rules`, **`personas`** (index of all personas), **`HISTORY`** (kit change history), and **`AUTO_USAGE`** (automatic usage of skills/personas — OpenCode checks and uses the relevant assets on its own, informing you with a short notice). The `scripts/persona-scaffold.sh` script creates a new persona with context and logs it to the history automatically.

### Plugins

The kit has a **plugin system** with hooks (see [docs/PLUGIN_GUIDE.md](./docs/PLUGIN_GUIDE.md)):

```bash
# Install a plugin
./core/plugin/installer.sh asset-linter

# Validate and load plugins
./core/plugin/loader.sh

# List registered hooks
./core/plugin/hooks.sh --list

# Create a new plugin
source core/plugin/sdk.sh
sdk_init_plugin my-validator plugins/community/my-validator
```

### Core (`core/`)

| Module | What it does |
|--------|--------------|
| `registry` | Registry and asset metadata/index generation (with JSON Schema) |
| `discovery` | Search, filters, recommendation, and related assets |
| `resolver` | Asset dependency resolution + lockfile |
| `version` | Semver versioning + compatibility matrix |
| `plugin` | Plugin system with hooks (install/load/remove) |
| `marketplace` | Asset publishing, search, and rating |
| `security` | Secret scanning, dependency audit, access control |
| `quality` | Validation, report, and quality dashboard |

### Web marketplace

The kit includes a static web interface (`marketplace-web/`) to discover and search skills, agents, prompts, and templates.

---

## Directory structure

```
opencode-engineering-kit/
├── assets/              # All reusable assets
│   ├── skills/          # 183 skills in 42 categories (SKILL.md)
│   ├── agents/          # 107 personas by category
│   ├── prompts/         # 10 reusable prompts
│   ├── templates/       # 11 templates
│   ├── commands/        # 7 documented commands
│   ├── playbooks/       # 3 multi-step flows
│   ├── recipes/         # 2 complete solutions
│   ├── bundles/         # 2 ready packs
│   ├── compositions/    # 2 agent teams
│   └── prompt-chains/   # 2 prompt chains
├── context/             # 17 AI context files (includes personas + HISTORY + AUTO_USAGE)
├── core/                # Kit infrastructure
│   ├── registry/        # Registry + schema + indexes
│   ├── discovery/       # Search and discovery
│   ├── resolver/        # Dependencies + lockfile
│   ├── version/         # Semver + compatibility
│   ├── plugin/          # Plugins and hooks
│   ├── marketplace/     # Marketplace CLI
│   ├── security/        # Security scans
│   └── quality/         # Quality gates + dashboard
├── cli/                 # npm CLI (npx opencode-engineering-kit)
├── plugins/             # Example plugins (community, enterprise)
├── marketplace-web/     # Marketplace web interface
├── scripts/             # bootstrap, test, deploy, monitor, persona-scaffold, dashboards
├── tests/               # 26 automated test suites
├── docs/                # Documentation (EN + PT)
├── examples/            # Usage examples
├── install.sh           # Global install
├── uninstall.sh         # Removal
└── update.sh            # Update
```

---

## Quick start

```bash
# View a skill
cat assets/skills/devops/docker-best-practices/SKILL.md

# Copy a skill to your project
cp -r assets/skills/devops/docker-best-practices/ /your/project/

# View an agent persona
cat assets/agents/devops/devops-engineer/devops-engineer.md

# Create a new domain persona with context and history
./scripts/persona-scaffold.sh construction mestre-de-obras "Construction management"

# Create a project from a template
cp -r assets/templates/new-project/ /your/new-project/

# Search assets by term
./core/discovery/search.sh "docker"

# Validate all assets
./core/quality/validate.sh
```

---

## Quality and tests

The project uses automated **quality gates** (Markdown/YAML/Shell lint, format and content validation) with CI via GitHub Actions.

```bash
# Run all 26 shell test suites
./scripts/test.sh

# Run the CLI tests (26 node:test cases)
cd cli && npm test

# Run the quality gates
./core/quality/validate.sh

# View the quality report
cat core/quality/quality-report.json
```

---

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](./CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md).

Contribution types: new skill, new agent, new template, improvement, bug fix.

## Roadmap

See [ROADMAP.md](./ROADMAP.md) and [docs/ROADMAP_V3.md](./docs/ROADMAP_V3.md). The v3.0 architecture evolution is in [docs/ARCHITECTURE_EVOLUTION.md](./docs/ARCHITECTURE_EVOLUTION.md).

## Security

See [SECURITY.md](./SECURITY.md) for policies and how to report vulnerabilities.

## Documentation

**English:** [User Guide](./docs/USER_GUIDE.md) · [Quick Reference](./docs/QUICK_REFERENCE.md) · [API Reference](./docs/API_REFERENCE.md) · [Plugin Guide](./docs/PLUGIN_GUIDE.md)

**Portuguese:** [Guia do Usuário](./docs/GUIA_USUARIO.md) · [Cartão de Referência](./docs/CARTAO_REFERENCIA.md)

**Planning:** [Audit & PR Plan](./docs/AUDIT_AND_PR_PLAN.md) · [Roadmap](./ROADMAP.md) · [Architecture Evolution](./docs/ARCHITECTURE_EVOLUTION.md) · [Session handoff](./docs/SESSION_HANDOFF.md) · [npm publishing playbook](./docs/NPM_PUBLISH_PLAYBOOK.md)

## License

MIT — see [LICENSE](./LICENSE).

## Contact

- **Issues:** [GitHub Issues](https://github.com/devtiagoabreu/opencode-engineering-kit/issues)
- **Discussions:** [GitHub Discussions](https://github.com/devtiagoabreu/opencode-engineering-kit/discussions)

## Acknowledgments

- [OpenCode](https://opencode.ai) for the platform
- [Shokunin](https://github.com/EliasOulkadi/shokunin) for inspiration
- [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill) for inspiration
- Everyone who contributes to the project
