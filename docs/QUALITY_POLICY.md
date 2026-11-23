# Asset Quality Policy

**Status:** Active (enforced in CI since 2026-11-23)  
**Scope:** all files under `assets/` validated by `scripts/validate_assets.py`.  
**Machine-readable policy:** [`core/registry/policy/asset-policy.json`](../core/registry/policy/asset-policy.json)  
**Schemas:** [`core/registry/schema/`](../core/registry/schema/)

This document makes the previously implicit asset rules explicit. The JSON Schemas define the frontmatter contract; the policy file defines curation and link rules; the validator enforces both.

## 1. Frontmatter contract

Every asset must parse as UTF-8 YAML frontmatter and match its kind's schema:

| Kind | Schema | Required frontmatter |
|---|---|---|
| Skills | `skill.schema.json` | `name`, `description`, `category`, `version`, `author`, `compatible`, `maturity` |
| Agents | `agent.schema.json` | `name`, `description`, `version`, `author`, `compatible`, `personas`, `maturity` |
| Prompts | `prompt.schema.json` | `name`, `description`, `category`, `version`, `author`, `compatible`, `maturity` |
| Commands | `command.schema.json` | `name`, `description`, `version`, `author`, `compatible`, `maturity` |
| Templates | `template.schema.json` | `name`, `description`, `category`, `version`, `author`, `compatible`, `maturity` |

`name` must match the file/folder convention, descriptions must be at least 10 characters, duplicate names and duplicate normalized content are reported. Templates containing `{{placeholder}}` tokens, or without frontmatter, are reported as warnings and skipped by schema validation by design.

## 2. Maturity

`maturity` is a required enum on every asset:

| Value | Meaning | How it is assigned |
|---|---|---|
| `stable` | Curated default; safe to recommend and install in a focused profile. | Asset is listed in [`profiles/core.json`](../profiles/core.json) (explicitly or by curated category) **and** passes the quality gates. |
| `beta` | Usable, but not yet promoted by curation review. Conservative default for new assets. | Everything not curated into the core profile. |
| `experimental` | Proof of concept; may change or be removed. | Explicitly declared by an asset author with a review date in the PR description. |
| `deprecated` | Superseded; do not use for new work. | Explicitly declared, with a replacement named in the asset body. |

Rules:

- The policy `maturity.allowed` list and every schema `maturity.enum` must match. The validator fails on drift.
- `beta` is the documented fallback for uncurated assets, but the field itself is **not** optional: a missing `maturity` is a schema error.
- Promoting an asset to `stable` requires updating the core profile and the asset frontmatter in the same PR. Promotion is a curation decision, not a size or recency signal.
- The CLI surfaces maturity in `list`/`search`/`install` output in a later PR (PR-05); the frontmatter signal is established here.

The current distribution can be inspected with:

```bash
grep -R '^maturity:' assets --include='SKILL.md' --include='*.md' | sort | uniq -c
```

## 3. Provenance

Skills and agents must declare a `provenance` mapping:

```yaml
provenance:
  source: OpenCode Engineering Kit (community)
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-08-15
```

Rules:

- `source` is required (`provenance.require_source`).
- `verified`, when present, must be a `YYYY-MM-DD` date string. YAML dates are normalized by the validator.
- `source_url` and `license` are optional in the schema but recommended whenever the material is derived from an external source.
- Missing or malformed provenance is a warning by default and an error under `--strict-policy` / `--strict-provenance`.

## 4. Relative links and aspirational references

All relative Markdown links in assets must resolve to a file in the repository. There are no implicit exemptions by path prefix.

A small set of links points to an external "Vision Platform" decision-record set that is not bundled here. These are **aspirational references** and must be declared one by one in `asset-policy.json` under `links.aspirational`:

```json
{
  "path": "assets/skills/<category>/<asset>/SKILL.md",
  "target": "docs/architecture/<record>.md",
  "reason": "External decision record; not bundled in this repository.",
  "review_by": "2026-12-31"
}
```

Rules:

- `path`, `target` and `reason` are mandatory; duplicates are rejected.
- A declared reference produces a warning naming its `review_by` date, not an error.
- An undeclared broken link is an error, including anything under `docs/architecture/`.
- A declared reference that no longer appears in its asset produces an `unused aspirational link entry` warning, so the allowlist cannot rot.
- Prefer replacing an aspirational reference with a real in-repo document or an external HTTPS URL, then remove the allowlist entry. Each entry carries a `review_by` date for that cleanup.

## 5. Validator and CI

```bash
# Local, full check (same as CI)
python scripts/validate_assets.py --root . --check-manifest --check-links --strict-policy

# Machine-readable report
python scripts/validate_assets.py --root . --check-links --json
```

| Flag | Effect |
|---|---|
| `--check-manifest` | Cross-check asset counts and the discovery index against `core/registry/manifest.json`. |
| `--check-links` | Validate relative Markdown links against the policy allowlist. |
| `--strict-policy` | Promote provenance/maturity warnings to errors. Used by CI. |
| `--strict-provenance` | Backwards-compatible alias for the provenance part of `--strict-policy`. |

The JSON report includes `ok`, `counts`, `policy` (`schema_version`, `maturity_default`, `aspirational_links_used`), `errors` and `warnings`. CI runs the strict command above, so any policy drift fails the build with an actionable message.

## 6. Adding or changing an asset

1. Copy the matching template and fill in every required frontmatter key, including `maturity`.
2. Add `provenance` for skills and agents; use a `YYYY-MM-DD` verification date.
3. Keep links local or declare an aspirational reference with a reason and review date.
4. Run the validator command from section 5, then `./scripts/test.sh`.
5. To request `stable`, add the asset to `profiles/core.json` (or its curated category) in the same PR and explain the curation rationale.
