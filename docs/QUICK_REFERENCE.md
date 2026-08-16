# Quick Reference Card

> One-page reference for using the OpenCode Engineering Kit

---

## Installation

```bash
# Into an existing project (recommended)
npx opencode-engineering-kit install

# Global install
curl -fsSL https://raw.githubusercontent.com/devtiagoabreu/opencode-engineering-kit/main/install.sh | bash

# Clone the repository
git clone https://github.com/devtiagoabreu/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

---

## Automatic Usage

Once installed into a project, OpenCode **checks and uses on its own** the relevant skill/persona (wired via `context/AUTO_USAGE.md` → `opencode.json > instructions`). No commands — just a short notice of what was used.

- `Implement Next.js endpoint` → skill `nextjs-development`
- `Slow query` → persona `postgresql-dba`
- `C# API` → skill `csharp-best-practices` + persona `csharp-developer`
- `Review PR` → persona `qa-engineer`
- Disable: remove `.opencode/context/auto_usage.md` from `instructions` and restart

---

## CLI

```bash
npx opencode-engineering-kit install                  # install into current project
npx opencode-engineering-kit install --global         # install globally (~/.config/opencode/)
npx opencode-engineering-kit install --only skills    # skills only
npx opencode-engineering-kit status                   # where installed + enabled state
npx opencode-engineering-kit start                    # re-enable the kit
npx opencode-engineering-kit stop                     # disable (keeps files)
npx opencode-engineering-kit list --type skills       # list skills
npx opencode-engineering-kit search "docker"          # search assets
npx opencode-engineering-kit doctor                   # check kit integrity
npx opencode-engineering-kit upgrade                  # re-install with --force
npx opencode-engineering-kit export claude            # export for Claude Code
npx opencode-engineering-kit export cursor            # export for Cursor
npx opencode-engineering-kit export opencode          # export native OpenCode
```

---

## Discovery

```bash
./core/discovery/search.sh "docker"                    # search by keyword
./core/discovery/filter.sh --category=devops           # filter by category
./core/discovery/filter.sh --compatible=opencode       # filter by compatibility
./core/discovery/related.sh docker-best-practices      # related assets
./core/discovery/recommend.sh                          # recommendations
./core/discovery/index.sh                              # generate index
```

### SkillPointer / Vault

```bash
./core/discovery/pointer.sh resolve repo-to-llm        # full content (on demand)
./core/discovery/pointer.sh vault repo-to-llm          # meta + tokens (JSON)
./core/discovery/pointer.sh tokens <file>              # token estimate
./core/discovery/pointer.sh list                       # list vault entries
./core/discovery/pointer.sh list --pointer             # list pointer skills
./core/discovery/pointer.sh is-pointer repo-to-llm     # is pointer? (true/false)
```

---

## Validation and Quality

```bash
./core/validator/validate-all.sh                       # validate all assets
./core/validator/validate.sh assets                     # validate a directory (skills/ + agents/)
./core/quality/validate.sh                             # quality gates
./scripts/typecheck.sh                                 # type checks
```

---

## Testing

```bash
./scripts/test.sh                                      # run all tests
./tests/skills/test-skill-content.sh                   # skill content tests
./tests/agents/test-agent-content.sh                   # agent content tests
./tests/discovery/test-pointer.sh                      # SkillPointer/vault tests
./tests/security/test-skill-scan.sh                    # security scan tests
```

---

## Security

```bash
./core/security/skill-scan.sh                          # skill content scan (PASS/WARN/FAIL)
./core/security/dependency-audit.sh                    # dependency audit
./core/security/secret-scan.sh                         # secret scanning
./core/security/vulnerability-scan.sh                  # vulnerability scanning
./core/security/access-control.sh                      # access control check
./core/security/audit-log.sh                           # audit logging
```

---

## Marketplace

```bash
./core/marketplace/search.sh "docker"                  # search marketplace
./core/marketplace/install.sh skill docker-best-practices
./core/marketplace/rate.sh add --asset <name> --reviewer <user> --rating <1-5>
./core/marketplace/publish.sh --type skill --path ./assets/skills/my-skill
open marketplace-web/index.html                        # web interface
```

---

## Dependency Resolution

```bash
./core/resolver/resolve.sh assets/skills/devops/docker-best-practices
./core/resolver/graph.sh                               # dependency graph
./core/resolver/validate.sh                            # validate dependencies
./core/resolver/lock.sh                                # generate lockfile
```

---

## Plugins

```bash
./core/plugin/loader.sh                                # load plugins
./core/plugin/installer.sh asset-linter                # install plugin
./core/plugin/uninstaller.sh my-plugin                 # uninstall plugin
./core/plugin/hooks.sh --list                          # list hooks
source core/plugin/sdk.sh                              # SDK for creating plugins
```

---

## Session Memory

```bash
export KIT_MEMORY=1
python3 context/memory/memory.py init                  # init memory (SQLite)
python3 context/memory/memory.py --help                # save/search/healthcheck
```

---

## Directory Structure

```
opencode-engineering-kit/
├── assets/              # All reusable resources
│   ├── skills/          # 150 skills in 42 categories (SKILL.md)
│   ├── agents/          # 103 personas in 38 categories
│   ├── prompts/         # 10 reusable prompts
│   ├── templates/       # 16 templates
│   ├── commands/        # 4 documented commands
│   ├── playbooks/       # 3 multi-step workflows
│   ├── recipes/         # 2 complete solutions
│   ├── bundles/         # 2 ready-made packages
│   ├── compositions/    # 2 agent teams
│   ├── prompt-chains/   # 2 prompt chains
│   └── vault/           # Curated on-demand content
├── context/             # AI context (project, stack, personas...)
├── core/                # Kit infrastructure
│   ├── registry/        # Registry + schema + manifest
│   ├── discovery/       # Search, filters, pointer (vault)
│   ├── resolver/        # Dependencies + lockfile
│   ├── version/         # Semver + compatibility
│   ├── plugin/          # Plugins and hooks
│   ├── marketplace/     # Marketplace CLI
│   ├── security/        # Security scans
│   ├── quality/         # Quality gates + dashboard
│   └── validator/       # Asset validation
├── cli/                 # npm CLI (npx opencode-engineering-kit)
├── plugins/             # Example plugins
├── marketplace-web/     # Marketplace web interface
├── scripts/             # bootstrap, test, deploy, monitor...
├── tests/               # 25 test suites
├── docs/                # Documentation (EN + PT)
├── install.sh           # Global installation
├── uninstall.sh         # Removal
└── update.sh            # Update
```

---

## Skill Structure

```
assets/skills/<category>/<skill-name>/
├── SKILL.md            # Main skill documentation (YAML frontmatter)
└── metadata.json       # Generated metadata
```

Pointer skills (`pointer: true`) point to `assets/vault/<category>/<skill>/` with `content.md` + `meta.json`.

---

## Agent Structure

```
assets/agents/<category>/<agent-name>/
├── <agent-name>.md     # Persona (YAML frontmatter + content)
└── metadata.json       # Generated metadata
```

---

## Creating New Assets

### Create a Skill

1. Copy the skill template:

    ```bash
    cp -r assets/templates/skill assets/skills/category/new-skill
    ```

2. Edit `SKILL.md` with your content (include the `provenance` block with `source_url`)

3. Run validation:

    ```bash
    ./core/validator/validate-all.sh
    ./core/quality/validate.sh
    ./scripts/test.sh
    ```

### Create an Agent

1. Use the scaffolder:

    ```bash
    ./scripts/persona-scaffold.sh construction master-builder "Construction management"
    ```

2. Edit the persona file and record it in the history

3. Run validation:

    ```bash
    ./core/validator/validate-all.sh
    ```

---

## Quality Gates

All assets must pass:

- **Schema validation** — valid metadata (JSON Schema)
- **Content validation** — required sections
- **Security scan** — `core/security/skill-scan.sh` (PASS/WARN/FAIL)
- **Provenance** — `provenance` block with `source`, `source_url`, `license`, `verified`
- **Testing** — automated tests (`./scripts/test.sh`)
- **Linting** — Markdown/YAML/Shell

---

## Support

- **GitHub Issues**: <https://github.com/devtiagoabreu/opencode-engineering-kit/issues>
- **Documentation**: See `docs/` directory
- **Examples**: See `examples/` directory
