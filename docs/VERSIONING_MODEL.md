# Versioning Model Specification

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Overview

The Versioning Model defines how assets are versioned, ensuring compatibility, predictability, and clear upgrade paths.

---

## Design Principles

1. **Semantic Versioning** — Follow SemVer 2.0.0
2. **Clear Contracts** — Version changes indicate breaking changes
3. **Compatibility Matrix** — Explicit platform compatibility
4. **Predictable Upgrades** — Minor/patch upgrades safe
5. **Deprecation Policy** — Clear deprecation timeline

---

## Semantic Versioning

### Format

```
MAJOR.MINOR.PATCH

MAJOR — Breaking changes
MINOR — New features (backward compatible)
PATCH — Bug fixes (backward compatible)
```

### Examples

| Version | Change Type | Example |
|---------|-------------|---------|
| 1.0.0 → 1.0.1 | Patch | Fix typo in SKILL.md |
| 1.0.0 → 1.1.0 | Minor | Add new examples |
| 1.0.0 → 2.0.0 | Major | Change skill structure |

### Pre-release Versions

```
1.0.0-alpha.1    — Alpha release
1.0.0-beta.1     — Beta release
1.0.0-rc.1       — Release candidate
```

---

## Version Constraints

### In Metadata

```yaml
---
name: docker-best-practices
version: 1.2.3
dependencies:
  requires:
    - name: git
      version: ">=2.0.0"        # Minimum version
    - name: node
      version: "^18.0.0"        # Compatible with 18.x.x
    - name: python
      version: "~3.9.0"         # Approximately 3.9.x
---
```

### Constraint Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Exact | `=1.0.0` |
| `>=` | Greater or equal | `>=1.0.0` |
| `<=` | Less or equal | `<=2.0.0` |
| `>` | Greater than | `>1.0.0` |
| `<` | Less than | `<2.0.0` |
| `^` | Compatible with | `^1.0.0` (>=1.0.0 <2.0.0) |
| `~` | Approximately | `~1.0.0` (>=1.0.0 <1.1.0) |
| `*` | Any version | `*` |

---

## Compatibility Matrix

### Platform Compatibility

```yaml
---
name: docker-best-practices
version: 1.0.0
compatible:
  platforms:
    - name: opencode
      version: ">=0.1.0"
    - name: claude-code
      version: ">=1.0.0"
    - name: cursor
      version: ">=0.1.0"
    - name: copilot
      version: ">=1.0.0"
---
```

### Framework Compatibility

```yaml
---
name: react-testing
version: 1.0.0
compatible:
  frameworks:
    - name: react
      version: ">=18.0.0"
    - name: next
      version: ">=13.0.0"
---
```

### Language Compatibility

```yaml
---
name: python-api
version: 1.0.0
compatible:
  languages:
    - name: python
      version: ">=3.8.0"
---
```

---

## Version Lifecycle

### States

```
┌─────────────────────────────────────────────────┐
│  Development → Alpha → Beta → Stable → Deprecated │
└─────────────────────────────────────────────────┘
```

| State | Description | Support |
|-------|-------------|---------|
| Development | Active development | None |
| Alpha | Testing phase | Bug fixes only |
| Beta | Feature complete | Bug fixes |
| Stable | Production ready | Full support |
| Deprecated | End of life | Security only |

### Deprecation Policy

| Version | Deprecation Notice | Removal |
|---------|-------------------|---------|
| Minor | 6 months notice | Next major |
| Major | 12 months notice | Next major |

---

## Upgrade Paths

### Safe Upgrades

```
Patch Upgrade (1.0.0 → 1.0.1)
  ✓ Always safe
  ✓ No breaking changes
  ✓ Drop-in replacement

Minor Upgrade (1.0.0 → 1.1.0)
  ✓ Safe for consumers
  ✓ New features added
  ✓ Backward compatible
```

### Major Upgrades

```
Major Upgrade (1.0.0 → 2.0.0)
  ⚠ May have breaking changes
  ⚠ Review changelog
  ⚠ Test before upgrading
```

### Upgrade Commands

```bash
# Check for updates
./core/versioning/check.sh

# Show upgrade path
./core/versioning/upgrade-path.sh skill-a

# Upgrade to latest
./core/versioning/upgrade.sh skill-a

# Upgrade to specific version
./core/versioning/upgrade.sh skill-a@2.0.0
```

---

## Changelog Format

### Structure

```markdown
# Changelog

## [2.0.0] - 2026-07-19

### Changed
- Changed skill structure (BREAKING)
- Updated examples

### Added
- Added new validation rules
- Added dependency support

### Deprecated
- Deprecated old format

### Removed
- Removed legacy compatibility

### Fixed
- Fixed typo in examples

### Security
- Updated vulnerable dependency
```

### Change Types

| Type | Description | Version Impact |
|------|-------------|----------------|
| Added | New feature | Minor |
| Changed | Change in behavior | Minor/Major |
| Deprecated | Soon to be removed | Minor |
| Removed | Feature removed | Major |
| Fixed | Bug fix | Patch |
| Security | Security fix | Patch |

---

## Version Locking

### Lock File

```json
{
  "version": "1.0.0",
  "locked": {
    "skill-a": "1.2.3",
    "skill-b": "2.0.1",
    "skill-c": "1.0.0"
  }
}
```

### Lock Commands

```bash
# Lock all versions
./core/versioning/lock.sh

# Lock specific asset
./core/versioning/lock.sh skill-a

# Unlock all
./core/versioning/unlock.sh

# Verify lock file
./core/versioning/verify.sh
```

---

## Version Tagging

### Git Tags

```bash
# Tag a release
git tag -a v1.0.0 -m "Release 1.0.0"

# Push tags
git push origin v1.0.0
```

### Tag Format

```
v1.0.0          — Stable release
v1.0.0-beta.1   — Beta release
v1.0.0-rc.1     — Release candidate
```

---

## Future Enhancements

1. **Automated Versioning** — Auto-bump versions
2. **Version Constraints UI** — Visual constraint editor
3. **Compatibility Testing** — Auto-test compatibility
4. **Version Analytics** — Track version usage
5. **Rollback Support** — Easy rollback to previous version
