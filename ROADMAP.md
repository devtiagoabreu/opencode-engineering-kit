# Roadmap

Overview of planned development for the OpenCode Engineering Kit.

## Current Version

**v0.1.0** — Content and infrastructure foundation (stable core)

## Delivered (current state)

### Foundation (v0.1.0)

- [x] Directory structure (`assets/`, `core/`, `scripts/`, `tests/`)
- [x] Bootstrap script and skill/agent JSON Schema
- [x] README.md (PT) and README_EN.md (EN)
- [x] CONTRIBUTING.md, LICENSE (MIT), SECURITY.md, CODE_OF_CONDUCT.md, ROADMAP.md
- [x] PROJECT_SPEC.md and live specs in `docs/`
- [x] Linting configs (.markdownlint.json, .yamllint.yml, .shellcheckrc, .editorconfig)
- [x] GitHub Actions CI
- [x] Test runner (`scripts/test.sh`), typecheck and quality gates

### Content (v0.1.0)

- [x] **115 skills** in 40 categories (domain + engineering + methodology-adjacent)
- [x] **93 agent personas** in 38 categories (PT-BR, with "Como ajuda as personas de tecnologia")
- [x] 10 prompts, 16 templates, 3 playbooks, 2 recipes, 3 commands, 2 bundles, 2 compositions, 2 prompt chains
- [x] **Orchestrator agent** (`planner/orquestrador`) that plans, delegates, shows provenance and asks the user
- [x] **Provenance** for all assets (`context/provenance.md`, 208 assets) + `scripts/add-provenance.sh`
- [x] Quality test module (`tests/quality/`) covering 6 dimensions

### Infrastructure (v0.1.0)

- [x] Registry, discovery, resolver (lockfile), validator, versioning, plugin system
- [x] Security modules (access-control, audit-log, dependency-audit, secret-scan, vulnerability-scan)
- [x] Marketplace system (spec + scripts) and marketplace web interface
- [x] CLI (`opencode-engineering-kit`), install.sh / uninstall.sh / update.sh
- [x] Compatibility matrix (opencode, claude-code, cursor, copilot)

## Planned Milestones

### v0.2.0 — Engineering Methodology (Q3 2026)

- [ ] Methodology skills: `brainstorming`, `writing-plans`, `executing-plans`, `tdd`, `git-worktrees`, `two-stage-code-review`, `verification-before-completion`
- [ ] New `methodology` skill category (schema + bootstrap)
- [ ] Auto-trigger of methodology skills via the orchestrator agent and project guidance
- [ ] Behavior evals per skill (trigger + expected output)

### v0.3.0 — Security by Default (Q3 2026)

- [ ] `core/security/skill-scan.sh`: dangerous-pattern scanning of SKILL.md content with explicit allowlist
- [ ] PASS/WARN/FAIL gate integrated into the quality pipeline
- [ ] `risk_level` / `permissions` fields in the skill schema
- [ ] Security policy + incident runbook in SECURITY.md
- [ ] SkillSpector integration documentation

### v0.4.0 — Distribution (Q4 2026)

- [ ] One-line installer (`curl | bash`) with `-y` non-interactive mode
- [ ] Declarative manifest + update.sh drift detection
- [ ] Rich CLI: `install`, `list`, `search`, `doctor`, `upgrade`, `export <harness>`
- [ ] Multi-harness packaging (`.claude/skills/`, `.cursor/rules/`, `CLAUDE.md`, `.codex`)

### v0.5.0 — Memory and Context Efficiency (Q4 2026)

- [ ] Persistent local-first memory (`context/memory/`, SQLite + optional ChromaDB, opt-in)
- [ ] `session-memory` skill + healthcheck
- [ ] SkillPointer mode: indexed catalog without context injection, on-demand loading
- [ ] Token-per-skill metric in the quality dashboard

### v1.0.0 — Stable Release (Q1 2027)

- [ ] Curation policy in CONTRIBUTING (verified, not mass-generated)
- [ ] Official source attribution in provenance (`source_url`)
- [ ] Consolidated documentation set (`docs/`), live roadmap
- [ ] Full CI/CD with all gates green
- [ ] Active community

## Long-Term Vision

### 2027

- Community skills marketplace (published via CLI)
- Multi-language support (content and docs)
- Integration with more AI platforms (native harness packages)

### 2028

- Visual skill editor
- AI-based skill suggestions
- Integration with popular IDEs
- Contributor certifications

## How to Contribute to the Roadmap

1. Open an issue with the `enhancement` tag
2. Discuss the proposal with the community
3. After approval, implement the feature
4. Submit a PR

## Priorities

| Priority | Description |
|----------|-------------|
| High | Core features, security |
| Medium | New features, improvements |
| Low | Nice-to-have, experiments |
