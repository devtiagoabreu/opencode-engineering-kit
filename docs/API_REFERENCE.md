# API Reference

Reference for the scripts and core modules of the OpenCode Engineering Kit. All scripts run from the repository root and accept `--help`/usage text on misuse.

## Core Modules

### `core/registry/` — Registry

| Command | Description |
|---------|-------------|
| `generate.sh` | Rebuild indexes under `core/registry/index/*.txt` |
| `generate-metadata.sh` | Regenerate `metadata.json` files for assets |

### `core/discovery/` — Discovery

| Command | Description |
|---------|-------------|
| `search.sh <term>` | Keyword search across skills, agents, prompts, templates |
| `filter.sh --category=<c>` | Filter assets by category |
| `related.sh <asset>` | Find related assets sharing tags/category |
| `recommend.sh --type=<t> [--limit=N]` | Recommend assets by type and popularity |
| `index.sh` | Build the search index |
| `pointer.sh resolve <skill>` | Load full vault skill content on demand |
| `pointer.sh vault <skill>` | Show vault meta + token estimate (JSON) |
| `pointer.sh tokens <file>` | Estimate token count of a file |
| `pointer.sh list [--pointer]` | List vault entries / pointer skills |
| `pointer.sh is-pointer <skill>` | Check if a skill is a pointer (`true`/`false`) |

### `core/resolver/` — Dependency Resolution

| Command | Description |
|---------|-------------|
| `parser.sh` | Parse and validate all declared dependencies |
| `resolve.sh <asset-dir>` | Resolve dependencies for one asset |
| `lock.sh` | Generate `lockfile.json`; verify each dependency resolves and mark `dependencies_resolved` in metadata |
| `graph.sh` | Render the dependency graph |
| `validate.sh` | Validate dependency declarations |

### `core/version/` — Versioning

| Command | Description |
|---------|-------------|
| `check.sh` | Verify all asset versions are valid SemVer |
| `bump.sh <patch\|minor\|major>` | Bump a version across assets |
| `compatibility.sh` | Generate `compatibility-matrix.json` from metadata |

### `core/quality/` — Quality

| Command | Description |
|---------|-------------|
| `validate.sh` | Run all quality gates (schema, lint, tests, docs) |
| `ai-review.sh [--asset <path>] [--output <file>] [--json]` | Heuristic + optional LLM asset review, writes scores/grades |
| `dashboard.sh [--output <file>] [--html <file>] [--with-tests] [--stdout-only]` | Aggregate quality report (JSON + HTML) |

### `core/plugin/` — Plugin System

| Command | Description |
|---------|-------------|
| `loader.sh [--check]` | Discover, validate, and load plugins |
| `installer.sh <name\|path\|url>` | Install a plugin |
| `uninstaller.sh <name>` | Remove a plugin |
| `hooks.sh <hook> \| --list \| --describe <hook>` | Dispatch hook handlers or inspect them |
| `sdk.sh` | Plugin SDK (log helpers, manifest validation, scaffolding) |

### `core/marketplace/` — Marketplace

| Command | Description |
|---------|-------------|
| `search.sh <term>` | Search assets locally |
| `install.sh <type> <name>` | Install an asset |
| `publish.sh --type <t> --path <dir> [--publisher <id>]` | Publish an asset to the registry |
| `publish.sh --list` / `--remove <name>` | Manage published assets |
| `publisher.sh create\|verify\|list\|remove` | Manage publisher accounts |
| `rate.sh add\|list\|summary` | Ratings and reviews |

### `core/security/` — Security

| Command | Description |
|---------|-------------|
| `secret-scan.sh` | Scan repo for exposed secrets |
| `dependency-audit.sh` | Audit dependencies for known vulnerabilities |
| `vulnerability-scan.sh` | Static scan for common vulnerability patterns |
| `access-control.sh` | Permission checks |
| `audit-log.sh` | Write audit log entries |

### `core/validator/` — Validation

| Command | Description |
|---------|-------------|
| `validate.sh <asset-dir>` | Validate a single asset |
| `validate-all.sh` | Validate every asset |

## Top-Level Scripts (`scripts/`)

| Command | Description |
|---------|-------------|
| `bootstrap.sh` | First-time setup and directory scaffolding |
| `test.sh` | Run every test file under `tests/` |
| `typecheck.sh` | Static checks: JSON validity, index presence, bash syntax, duplicate names |
| `monitor.sh` | Health check: disk, git, assets, lockfile, reports |
| `backup.sh [--output <dir>]` | Timestamped archive of the kit (keeps 10) |
| `deploy.sh [--tag <v>]` | Full release pipeline: typecheck → tests → gates → lockfile → registry → dashboard → archive |
| `create-docs.sh` | Regenerate docs artifacts |

## Python Helpers

| Script | Purpose |
|--------|---------|
| `scripts/quality_review.py --root <dir> [--asset <p>] [--output <f>] [--json]` | AI-assisted review engine |
| `scripts/quality_dashboard.py --root <dir> [--output <f>] [--html <f>] [--with-tests]` | Dashboard generator |
| `scripts/marketplace_publishers.py <add\|verify\|list\|remove>` | Publisher registry data ops |
| `scripts/marketplace_assets.py <add\|list\|remove>` | Published-assets registry data ops |
| `scripts/marketplace_reviews.py <add\|list\|summary>` | Review/rating data ops |

## Environment Variables

| Variable | Used by |
|----------|---------|
| `OPENCODE_AI_ENDPOINT` | `ai-review.sh` — LLM endpoint for AI summary |
| `OPENCODE_AI_API_KEY` | `ai-review.sh` — auth token |
| `OPENCODE_AI_MODEL` | `ai-review.sh` — model name (default `default`) |
