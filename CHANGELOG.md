# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

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
