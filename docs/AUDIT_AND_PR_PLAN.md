# Audit & PR Plan

**Date:** 2026-11-21  
**Scope:** Static audit of `opencode-engineering-kit` + benchmark against top reference repos cloned locally in `references/` (gitignored).  
**Status:** Proposed first cut for execution.

## Executive Summary

The kit has a solid technical base: a working CLI install/lifecycle, `.opencode/` asset layout, `opencode.json` merge behavior, core modules for registry/discovery/resolver/plugin/marketplace/security/quality, shell and CLI tests, and CI workflows.

The main gap versus top repos is not asset quantity. It is **trust, curation, product UX, and ecosystem alignment**.

**Strategic direction:** compete on *curated, trustworthy, domain-rich assets + safe 5-minute install* for OpenCode projects, not on being the biggest catalog or the most complex harness.

## Audit Method

- Inspected key files: `README.md`, `README_EN.md`, `PROJECT_SPEC.md`, `cli/package.json`, `cli/README.md`, `cli/src/*.js`, `core/**`, `scripts/**`, `tests/**`, `.github/workflows/*`, `core/registry/schema/*`, `core/registry/manifest.json`.
- Reviewed local reference clones in `references/` (shallow, gitignored): `anthropics-skills`, `obra-superpowers`, `affaan-ecc`, `shokunin`, `opencode-ultimate-skills`.
- Did **not** run the full test suite or quality gates in this audit pass. Before PR-01 implementation lands, run: `./scripts/test.sh`, `cd cli && npm test`, `./core/quality/validate.sh`.

## Current State Snapshot

Observed from repository files/manifest:

| Area | Observed state |
|---|---:|
| Skills | 150 |
| Agents | 103 |
| Prompts | 10 |
| Templates | 4 |
| Playbooks | 3 |
| Context files | 17 |
| CLI commands | `install`, `status`, `start`, `stop`, `list`, `search`, `doctor`, `upgrade`, `export` |
| Test suites | 25 shell + 3 CLI |

## Benchmark

| Repo | Signal | Adopt | Avoid copying |
|---|---:|---|---|
| [anthropics/skills](https://github.com/anthropics/skills) | ~198k★ | Agent Skills standard alignment, clean metadata, curated set, clear examples | Too minimal for this kit's domain breadth |
| [obra/superpowers](https://github.com/obra/superpowers) | ~323k★ | Composable workflow skills, disciplined activation, behavior/eval mindset | Narrow catalog; not a drop-in asset library |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | ~308k★ | Guided setup, doctor/repair/update, manifests/ownership, security scan, release discipline | Harness complexity before core trust/UX is stable |
| [EliasOulkadi/shokunin](https://github.com/EliasOulkadi/shokunin) | ~112★ | Simple install, cross-runtime story, local-first narrative | Memory/runtime scope that may not belong in core |
| [Adhamxon/opencode-ultimate-skills](https://github.com/Adhamxon/opencode-ultimate-skills) | ~1★ | Fast OpenCode `.opencode/` drop-in UX | Volume without maturity/trust signals |

Local reference snapshot:

| Repo | `SKILL.md` files | Agent `.md` files in `agents/` dirs | Approx. size |
|---|---:|---:|---:|
| `affaan-ecc` | 1089 | 311 | 62.6 MB |
| `anthropics-skills` | 20 | 3 | 11.5 MB |
| `obra-superpowers` | 15 | 0 | 1.5 MB |
| `opencode-ultimate-skills` | 384 | 9 | 10.2 MB |
| `shokunin` | 62 | 0 | 54.2 MB |

## Strengths

- **Real install path:** `cli/src/install.js` installs into project `.opencode/` or global config, copies asset groups, flattens agents, merges `opencode.json` (`skills.paths`, `instructions`), and supports `--dry-run`, `--force`, `--verbose`, `--global`, `--only`.
- **Lifecycle controls:** `cli/src/manage.js` provides `status/start/stop`, detects project/global scope, and rewires config without deleting files.
- **Existing product commands:** CLI already exposes `list`, `search`, `doctor`, `upgrade`, `export`; the product surface is larger than the README currently communicates.
- **Core infrastructure:** `core/` contains registry, discovery, resolver, version, plugin, marketplace, security, quality, and validator modules.
- **Trust/schema signals:** skill schema includes `provenance`, `security`, `pointer`, `vault`; doctor checks schema, allowlist, index freshness, lockfile, skill scan, vault consistency, and optional tests.
- **CI baseline:** `.github/workflows/ci.yml` runs lint, shell tests, CLI tests, typecheck, quality gates, and basic frontmatter/size checks.

## Gaps and Risks

### P0 — Trust and UX

- **Diffuse positioning:** kit spans catalog, core platform, marketplace, and plugin system. The happy path is unclear.
- **README/CLI drift:** README emphasizes install/status/start/stop but omits existing `list/search/doctor/upgrade/export`.
- **Curation/maturity invisible:** large asset count without stable/beta/experimental signal, curated default set, or quality cues in install/search flows.
- **Supply-chain trust incomplete:** skill scan exists, but install flow needs clearer audit/verify/lock/provenance policy and user-facing reports.
- **No profile-based install:** `--only` selects asset types, not use-case profiles; increases context noise and onboarding friction.

### P1 — Standard and Distribution

- **Agent Skills alignment not explicit:** custom schema is useful, but Agent Skills compatibility/progressive-disclosure validation should be first-class and documented.
- **Limited distribution story:** no documented/tested path for skills ecosystem/plugin channels where appropriate.
- **CLI product gaps:** doctor should cover target drift/conflicts/hashes; missing `diff`, `add/remove/pin`, `verify`, and snapshot/rollback UX.
- **Windows portability risk:** install depends on `tar` behavior; CI is Ubuntu-only.

### P1 — Engineering Quality

- **CI validation shallow:** frontmatter/size checks do not fully validate schema, duplicates, broken links, encoding, manifest/index drift, or provenance policy.
- **Documentation quality debt:** generated/older docs show encoding artifacts in some environments; UTF-8 hygiene needs an explicit check.
- **Release workflow outdated:** uses older GitHub Actions and lacks npm publish/checksum/changelog discipline.
- **Count/source-of-truth drift:** README, manifest, and tests can diverge; counts should be generated.

### P2 — Scale and Community

- **Core/marketplace/plugin ahead of adoption:** mark maturity and keep the default path simple.
- **Contribution friction:** needs skill/agent issue/PR templates, review rubric, and acceptance policy.
- **Local observability missing:** no command/report for context-size impact, conflicts, duplicates, stale assets.

## PR Plan

| PR | Goal | Main scope | Acceptance criteria | Risk |
|---|---|---|---|---|
| **PR-01 Audit baseline & docs truth** | Make current state honest and navigable | README/CLI docs, encoding hygiene, generated counts/badges, command docs, trust/curation section, audit doc | Docs match CLI; counts generated; UTF-8 clean; clear happy path | Low |
| **PR-02 Schema & asset validation CI** | Make quality verifiable | Schema validation for skills/agents/prompts/templates/commands, duplicate/name/link/encoding checks, manifest/index drift checks | CI fails on invalid asset/drift; actionable report | Medium |
| **PR-03 CLI doctor/product UX** | Improve operational trust | Expand `doctor`; add `verify`/`diff`; better JSON/human output; drift/conflict/hash detection | Doctor catches common drift; stable JSON; tests cover scenarios | Medium |
| **PR-04 Profiles & curated sets** | Reduce context noise | `--profile/--preset`, curated stable default, profile manifests/docs/tests | Profile install selects expected subset; dry-run shows selection | Medium |
| **PR-05 Trust & security baseline** | Supply-chain confidence | Provenance/maturity policy, install audit report, stronger skill scan/allowlist governance, checksums/lock | Risky assets blocked or explicitly acknowledged; auditable reports | Med/High |
| **PR-06 Agent Skills compatibility & distribution** | Ecosystem alignment | Agent Skills compat validation/export, skills ecosystem guidance/integration where appropriate | OpenCode path intact; ecosystem path documented/tested | Medium |
| **PR-07 Release & packaging discipline** | Reliable releases | Update actions, changelog, npm publish gate, checksums, semver/tag policy | Reproducible tagged release; verifiable package | Medium |
| **PR-08 Curation & content quality program** | Raise perceived quality | Curated top set, review rubric, contribution templates, asset maturity/deprecation | New assets follow rubric; curated set visible; maturity signaled | Low/Med |

## Recommended Order

1. **PR-01 + PR-02** — truth and guardrails.
2. **PR-03 + PR-04** — product UX and adoption.
3. **PR-05** — trust before scale.
4. **PR-06 + PR-07** — ecosystem and releases.
5. **PR-08** — continuous curation.

## Progress (updated 2026-11-21)

### PR-01 - Audit baseline & docs truth
- [x] README/CLI docs document existing CLI commands.
- [x] 5-minute quick start added.
- [x] Trust model / install safely section added.
- [x] Core vs Optional/Experimental section added.
- [x] Link to this audit added from README.
- [ ] Fix encoding hygiene in docs; enforce UTF-8 in CI.
- [ ] Generate asset counts from manifest/filesystem; remove manual drift.

### PR-02 - Schema & asset validation CI
- [x] `scripts/validate_assets.py` validates asset schemas/frontmatter and manifest drift.
- [x] CI runs validation with `--check-manifest`.
- [ ] Deeper checks: broken internal links, duplicates, provenance/maturity policy.

### PR-03 - CLI doctor/product UX
- [x] `doctor --target/--global` wiring checks.
- [x] Install manifest v2 with file hashes; drift detection for modified/missing/extra.
- [x] Structured recommendations in doctor JSON/human output.
- [x] Stable `doctor --json` contract documented (checks[].code, recommendations[]) and covered by CLI tests.
- [ ] Full remediation flow polish (guided fix/apply mode).

### PR-04 - Profiles & curated sets
- [x] `--profile` presets for curated install selection.
- [x] Profiles filter skills/agents/commands/context.
- [x] Profile matrix documented.
- [x] `upgrade` reuses manifest profile/only when flags omitted; tests cover explicit override and global scope.
- [ ] Default curated install UX and profile-aware upgrade messaging.

### Remaining high-value gaps
- [ ] PR-05 trust baseline: provenance/maturity visible in list/search/install, stronger risk policy.
- [ ] PR-07 release discipline: changelog, publish gate, checksums, updated actions.
- [ ] Windows/CI portability smoke and bash-independent quality path.

## Definition of Done for This Direction

- **5 min to value:** install, list, search, and run one real workflow.
- **Trust by default:** schema + scan + provenance + lock + doctor.
- **Curated first:** curated default profile; full catalog opt-in.
- **Ecosystem-ready:** Agent Skills compatible, clear docs, reproducible releases.
