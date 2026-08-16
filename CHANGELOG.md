# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **Documentation consistency pass**: aligned all counts across README, README_EN and docs — 150 skills/42 categories, 103 agents/38 categories, 4 templates (only content-backed templates are counted), 25 test suites, 37 core scripts; unified the SKILL.md size limit to 600 lines across quality gates, CI, PROJECT_SPEC, context and docs
- **7 new skills for a Computer Vision SaaS (Vision Platform / CVaaS reference)**: `fastapi-development` (async Python REST, Pydantic schemas, DI, OpenAPI-first), `sqlalchemy-alembic` (SQLAlchemy 2.0 async + Alembic, multi-tenant scoping, audit columns, UUID public ids), `onnx-object-detection` (YOLO ONNX export/quantization, letterbox, NMS, ByteTrack tracking, CPU-first), `rtsp-camera-ingestion` (RTSP/ONVIF drivers, reconnection, bounded frame queues, bandwidth planning), `plugin-system` (stable module interface, plugin manager, SDK, event-driven integration keeping business logic out of the Core), `event-driven-architecture` (Event Bus, pub/sub, persistent events, pipeline wiring), `onpremise-deployment` (Docker Compose on customer hardware, CPU-first sizing, resource limits, backup)
- **Author attribution**: all assets now declare `author: devtiagoabreu` (repository owner) instead of `OpenCode Community` across 411 files (skills, agents, prompts, commands, playbooks, recipes, context, provenance script)
- **9 new skills for SaaS route-planning apps (RouteOS reference)**: `multi-tenant-saas` (shared-schema tenantId isolation, tenant resolution, cross-tenant protection), `prisma-orm` (schema/relations/migrations, soft delete, tenant scoping, serverless pooling), `route-optimization` (OpenRouteService/OSRM provider abstraction, geocoding, SVRP), `leaflet-maps` (React Leaflet + OpenStreetMap, markers/polyline, SSR-safe), `shadcn-ui` (copy-in components, theming, DataTable/form patterns), `tanstack-query` (server state, cache invalidation, optimistic updates), `form-validation` (Zod + React Hook Form shared schemas), `rbac-authorization` (permission matrix, server-side enforcement), `vercel-deployment` (serverless limits, env vars, Neon pooling, CI)
- **Ocekit lifecycle via natural language**: new `ocekit-manager` skill (auto-triggered by "instale ocekit", "stop ocekit", "start ocekit", "status ocekit") and `/ocekit` command; CLI gains `install --global` (into `~/.config/opencode/`), `status`, `start` and `stop` commands (toggle `opencode.json` wiring without deleting files), and `--repo` accepts full GitHub/SSH URLs
- **Automatic skill/persona usage** (`context/AUTO_USAGE.md`): the installed kit now registers an `auto_usage` instruction in `opencode.json > instructions`, so OpenCode always checks the installed skills/personas and uses the most productive one automatically (no commands needed), informing the user with a short notice; disabling is a one-line config change
- **Rich CLI** (`cli/`): `install`, `list`, `search`, `doctor`, `upgrade`, `export` commands; one-line installer (`install.sh`) with `-y` auto-confirm and atomic skills/agents/scripts install; drift-aware `update.sh` with rollback safety
- **Declarative manifest** (`core/registry/manifest.json` + `scripts/generate-manifest.sh`) with commit + content hashes for drift detection
- **Multi-harness export** (`cli export --harness`) producing prompts for opencode, claude-code and cursor
- **Persistent local-first memory** (`context/memory/memory.py` + `tools/session-memory` skill): opt-in (`KIT_MEMORY=1`) SQLite FTS5 notes with recency boost and optional ChromaDB vector recall, stored outside the repo
- **SkillPointer mode** (`core/discovery/pointer.sh` + `assets/vault/`): skills become minimal catalog entries (`pointer: true` + `vault:` frontmatter) with full curated content stored in the vault and loaded on demand, avoiding context injection; `pointer.sh` resolves/vaults/lists/token-estimates on demand
- **Vault tooling**: `scripts/generate-vault-meta.sh` produces `meta.json` (sha256, token estimate, bytes) per vault entry; manifest counts `pointer_skills` and `vault_entries` plus a full `vault` array; `pointer`/`vault` fields added to the skill JSON Schema
- **3 curated vault entries**: `repo-to-llm`, `code-knowledge-graph`, `skill-spector` converted to pointer skills with full content in `assets/vault/`
- **Doctor vault check**: `cli doctor` now verifies vault consistency (pointer skills ↔ vault entries, broken links)
- New test module `tests/discovery/test-pointer.sh` covering resolve/vault/tokens/list/is-pointer and manifest counts
- **Official source attribution**: provenance field renamed `url` → `source_url` (schema + `scripts/add-provenance.sh` + all 216 assets backfilled)
- **CI green gates**: shellcheck warnings resolved across scripts (unused vars, SC2155), CI vault file-size check added, README/repository-comparison skill counts corrected to 123
- New test modules for CLI (`cli/test/cli.test.js`) and session memory (`tests/context/test-memory.sh`); CI now runs CLI tests and shellcheck across scripts
- **39 new personas** in 9 new agent categories (education, music, arts, sports, automotive, commercial, languages, ai, planner) plus new personas in existing categories (humanities: politics & law; marketing: political marketing) — PT-BR content with a "Como ajuda as personas de tecnologia" section
- **35 new skills** in 9 new skill categories (education, music, arts, sports, automotive, commercial, languages, humanities, health/nutrition) plus `ai/free-llm-models`
- New `planner/orquestrador` agent that plans, delegates to the right agents, shows tool provenance and asks the user
- New `commercial` and `law` categories added to `bootstrap.sh` and the skill JSON Schema
- **Provenance (provenance)**: `provenance` frontmatter block (source, url, license, verified date) in all assets, `scripts/add-provenance.sh` backfill script and `context/provenance.md` index (208 assets)
- New quality test module `tests/quality/test-asset-quality.sh` covering 6 dimensions (Acessibilidade, Segurança, Intuitividade, UI, Eficiência, Eficácia) for skills and agents
- Fixed pre-existing issues revealed by the new tests (invalid YAML in 4 skills, merged lines in `rag-llm`, nested code fences, http→https upgrades)
- **31 domain personas** in 12 new agent categories (construction, finance, design, marketing, science, humanities, engineering, logistics, web, health, management, cloud) — each with a "Como ajuda as personas de tecnologia" section and PT-BR content
- **20 domain skills** in 11 new skill categories (construction, finance, marketing, science, engineering, logistics, web, management, health, cloud)
- New `context/personas.md` (index of all personas) and `context/HISTORY.md` (change history)
- New `scripts/persona-scaffold.sh` to create personas with context and history
- `README_EN.md` (English translation of the README)
- New agent categories added to `bootstrap.sh` and skill categories to the JSON Schema
- Fixed `compatibility.sh` frontmatter parser (was truncating values like `opencode`→`encode`)
- New skills (LLM context & tooling): `doc-to-markdown` (MarkItDown), `repo-to-llm` (gittomd/llms.txt), `code-knowledge-graph` (Graphify), `context-optimization` (Repomix/token economy), `skill-spector` (NVIDIA SkillSpector)
- New skill category `documentation` (bootstrap.sh + schema)
- .gitignore for security and build artifacts
- Linting configs (.markdownlint.json, .yamllint.yml, .shellcheckrc, .editorconfig)
- Test runner script (scripts/test.sh)
- Agent content tests
- Template content tests
- Install script tests
- Fixed install.sh copy-direction bug (line 69)
- Fixed bootstrap.sh to match actual structure
- Fixed agent frontmatter references to non-existent skills
- Updated all documentation to English
- Version aligned to v0.1.0 across all files

### Changed

- Standardized language to English throughout
- Updated test-skill-content.sh to support both English and Portuguese headers
- Removed empty docs/ files
- Removed orphan directories (nano scripts/, specs/)

### Deprecated

- None yet

### Removed

- Empty docs/ placeholder files
- Orphan directories (nano scripts/, specs/)

### Fixed

- install.sh copy-direction bug (line 69)
- bootstrap.sh structure mismatch with actual files
- Agent frontmatter references to non-existent skills
- Version inconsistency (v2.0.0 vs v0.1.0)

### Security

- Added .gitignore to prevent secrets from being committed

## [0.1.0] - 2026-07-18

### Added

- Initial project structure
- Bootstrap script (scripts/bootstrap.sh)
- Basic documentation (README, CONTRIBUTING, LICENSE)
- PROJECT_SPEC.md with complete specification

---

[Unreleased]: https://github.com/opencode-ai/opencode-engineering-kit/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/opencode-ai/opencode-engineering-kit/releases/tag/v0.1.0
