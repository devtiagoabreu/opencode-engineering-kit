# New Directory Structure

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Current Structure (Problems)

```
opencode-engineering-kit/
├── agents/              # Flat files, hard to scale
├── commands/            # 3 files, no structure
├── context/             # 13 files, massive duplication
├── docs/                # EMPTY
├── examples/            # EMPTY
├── assets/              # EMPTY
├── prompts/             # 3 files in 3 categories
├── scripts/             # 4 scripts
├── skills/              # 5 skills, 18 category dirs (13 empty)
├── templates/           # 4 templates
├── tests/               # 8 test scripts
├── .github/             # CI/CD workflows
└── [root files]         # README, SPEC, etc.
```

**Problems:**
- No separation between core and content
- Empty directories create confusion
- No registry or index
- No plugin support
- No marketplace preparation

---

## Proposed Structure (v3.0)

```
opencode-engineering-kit/
│
├── core/                          # Core infrastructure
│   ├── registry/                  # Asset registry
│   │   ├── schema/               # JSON schemas
│   │   │   ├── skill.schema.json
│   │   │   ├── agent.schema.json
│   │   │   ├── prompt.schema.json
│   │   │   ├── template.schema.json
│   │   │   ├── command.schema.json
│   │   │   ├── playbook.schema.json
│   │   │   └── recipe.schema.json
│   │   ├── index/                # Generated indexes
│   │   │   ├── skills.json
│   │   │   ├── agents.json
│   │   │   ├── prompts.json
│   │   │   ├── templates.json
│   │   │   └── commands.json
│   │   └── README.md
│   ├── discovery/                 # Search and discovery
│   │   ├── search.sh
│   │   ├── filter.sh
│   │   └── README.md
│   ├── resolver/                  # Dependency resolution
│   │   ├── resolve.sh
│   │   ├── graph.sh
│   │   └── README.md
│   ├── validator/                 # Schema validation
│   │   ├── validate.sh
│   │   ├── schemas/
│   │   └── README.md
│   ├── version/                   # Version management
│   │   ├── bump.sh
│   │   ├── check.sh
│   │   └── README.md
│   └── plugin/                    # Plugin system
│       ├── loader.sh
│       ├── installer.sh
│       └── README.md
│
├── assets/                        # All reusable assets
│   ├── skills/                    # Skills by category
│   │   ├── devops/
│   │   │   ├── docker-best-practices/
│   │   │   │   ├── SKILL.md
│   │   │   │   ├── metadata.json
│   │   │   │   └── examples/
│   │   │   └── kubernetes-deployment/
│   │   ├── backend/
│   │   ├── frontend/
│   │   ├── testing/
│   │   ├── security/
│   │   ├── git/
│   │   └── code-quality/
│   │
│   ├── agents/                    # Agents by category
│   │   ├── devops/
│   │   │   ├── devops-engineer.md
│   │   │   └── metadata.json
│   │   ├── backend/
│   │   ├── frontend/
│   │   ├── security/
│   │   └── qa/
│   │
│   ├── prompts/                   # Prompts by category
│   │   ├── code-review/
│   │   ├── debugging/
│   │   ├── architecture/
│   │   └── security/
│   │
│   ├── templates/                 # Templates by type
│   │   ├── project/
│   │   │   ├── new-project/
│   │   │   └── opencode-config/
│   │   ├── skill/
│   │   ├── agent/
│   │   ├── prompt/
│   │   └── command/
│   │
│   ├── commands/                  # Commands
│   │   ├── review.md
│   │   ├── test.md
│   │   └── lint.md
│   │
│   ├── playbooks/                 # Multi-step workflows
│   │   ├── setup-new-project/
│   │   ├── code-review-flow/
│   │   └── security-audit/
│   │
│   └── recipes/                   # Complete solutions
│       ├── react-app/
│       ├── node-api/
│       └── python-cli/
│
├── examples/                      # Working examples
│   ├── basic/
│   │   ├── using-skill/
│   │   └── using-agent/
│   ├── advanced/
│   │   ├── custom-skill/
│   │   └── composing-agents/
│   └── real-world/
│       ├── startup-project/
│       └── enterprise-project/
│
├── tooling/                       # Developer tools
│   ├── scripts/
│   │   ├── bootstrap.sh
│   │   ├── install.sh
│   │   ├── update.sh
│   │   ├── uninstall.sh
│   │   ├── test.sh
│   │   ├── validate.sh
│   │   ├── generate-index.sh
│   │   └── migrate.sh
│   └── hooks/
│       ├── pre-commit
│       └── pre-push
│
├── tests/                         # Test suite
│   ├── unit/
│   │   ├── test-skill-format.sh
│   │   ├── test-agent-format.sh
│   │   ├── test-prompt-format.sh
│   │   └── test-template-format.sh
│   ├── integration/
│   │   ├── test-dependency-resolution.sh
│   │   ├── test-installation.sh
│   │   └── test-discovery.sh
│   ├── e2e/
│   │   └── test-full-workflow.sh
│   └── fixtures/
│       ├── valid-skill/
│       ├── invalid-skill/
│       └── ...
│
├── docs/                          # Documentation
│   ├── getting-started.md
│   ├── installation.md
│   ├── usage.md
│   ├── architecture.md
│   ├── contributing.md
│   ├── api.md
│   ├── tutorials/
│   │   ├── creating-skill.md
│   │   ├── creating-agent.md
│   │   └── creating-template.md
│   ├── references/
│   │   ├── skill-reference.md
│   │   ├── agent-reference.md
│   │   └── command-reference.md
│   └── decisions/
│       ├── ADR-001-skill-format.md
│       ├── ADR-002-category-organization.md
│       └── ...
│
├── standards/                     # Standards and conventions
│   ├── naming.md
│   ├── formatting.md
│   ├── security.md
│   └── quality.md
│
├── context/                       # Project context (slim)
│   ├── project.md
│   ├── architecture.md
│   └── glossary.md
│
├── plugins/                       # External plugins (future)
│   ├── community/
│   ├── enterprise/
│   └── README.md
│
├── .github/                       # GitHub configuration
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── release.yml
│   │   └── validate.yml
│   ├── ISSUE_TEMPLATE/
│   ├── PULL_REQUEST_TEMPLATE/
│   ├── CODEOWNERS
│   └── FUNDING.yml
│
├── [root config files]
│   ├── .gitignore
│   ├── .editorconfig
│   ├── .markdownlint.json
│   ├── .yamllint.yml
│   ├── .shellcheckrc
│   ├── CHANGELOG.md
│   ├── CONTRIBUTING.md
│   ├── LICENSE
│   ├── PROJECT_SPEC.md
│   ├── README.md
│   └── ROADMAP.md
│
└── [metadata files]
    ├── registry.json              # Auto-generated asset index
    ├── dependencies.json          # Dependency graph
    └── versions.json              # Version tracking
```

---

## Key Changes from Current Structure

| Current | Proposed | Reason |
|---------|----------|--------|
| `agents/` (flat) | `assets/agents/` (by category) | Scalability |
| `skills/` (18 dirs, 13 empty) | `assets/skills/` (only populated) | Cleanliness |
| `context/` (13 files, duplicated) | `context/` (3 files, deduplicated) | Reduce duplication |
| `docs/` (empty) | `docs/` (populated) | Usability |
| `scripts/` (4) | `tooling/scripts/` (8+) | Organization |
| No `core/` | `core/` (6 subsystems) | Infrastructure |
| No `assets/` | `assets/` (all content) | Separation |
| No `plugins/` | `plugins/` (future) | Extensibility |
| No `standards/` | `standards/` (conventions) | Governance |
| No `examples/` content | `examples/` (3 levels) | Learning |

---

## Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Directories | kebab-case | `code-quality/` |
| Markdown files | kebab-case.md | `docker-best-practices.md` |
| Schema files | dot.schema.json | `skill.schema.json` |
| Index files | plural.json | `skills.json` |
| Scripts | kebab-case.sh | `generate-index.sh` |
| Test files | test-*.sh | `test-skill-format.sh` |

---

## Migration Impact

| Area | Impact | Effort |
|------|--------|--------|
| Move files | High | Medium |
| Update references | High | High |
| Update tests | Medium | Medium |
| Update CI/CD | Medium | Low |
| Update documentation | High | Medium |
| Update scripts | Medium | Medium |

---

## Rollback Strategy

1. Keep backup of current structure
2. Migrate incrementally
3. Test after each step
4. Keep old paths as symlinks temporarily
5. Remove old paths after validation