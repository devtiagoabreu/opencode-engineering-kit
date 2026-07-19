# Dependency Model Specification

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Overview

The Dependency Model manages relationships between assets, enabling dependency resolution, conflict detection, and installation ordering.

---

## Design Principles

1. **Declarative** — Dependencies declared in metadata
2. **Resolvable** — Automatic dependency resolution
3. **Conflict-free** — Detect and resolve conflicts
4. **Minimal** — Prefer fewer dependencies
5. **Pinned** — Pin versions for reproducibility

---

## Dependency Types

| Type | Description | Example |
|------|-------------|---------|
| requires | Must have | requires: docker |
| recommends | Nice to have | recommends: docker-compose |
| conflicts | Cannot coexist | conflicts: docker-legacy |
| provides | Alternative | provides: container-runtime |
| peer | Must match version | peer: react@18.x |

---

## Dependency Declaration

### Skill Dependencies

```yaml
# SKILL.md frontmatter
---
name: docker-best-practices
version: 1.0.0
dependencies:
  requires:
    - name: docker
      version: ">=20.0.0"
    - name: git
      version: ">=2.0.0"
  recommends:
    - name: docker-compose
      version: ">=2.0.0"
  conflicts:
    - name: docker-legacy
      version: "*"
---
```

### Agent Dependencies

```yaml
# AGENT.md frontmatter
---
name: devops-engineer
version: 1.0.0
dependencies:
  requires:
    - name: docker-best-practices
      version: ">=1.0.0"
    - name: kubernetes-deployment
      version: ">=1.0.0"
  skills:
    - docker-best-practices
    - kubernetes-deployment
---
```

### Prompt Dependencies

```yaml
# PROMPT.md frontmatter
---
name: code-review
version: 1.0.0
dependencies:
  requires:
    - name: code-quality
      version: ">=1.0.0"
---
```

---

## Version Constraints

### Constraint Syntax

| Constraint | Description | Example |
|------------|-------------|---------|
| exact | Exact version | 1.0.0 |
| minimum | Minimum version | >=1.0.0 |
| maximum | Maximum version | <=2.0.0 |
| range | Version range | >=1.0.0 <2.0.0 |
| caret | Compatible with | ^1.0.0 |
| tilde | Approximately | ~1.0.0 |

### Constraint Examples

```yaml
dependencies:
  requires:
    - name: docker
      version: ">=20.0.0"        # Docker 20.0.0 or higher
    
    - name: git
      version: "^2.0.0"          # Git 2.x.x (compatible)
    
    - name: node
      version: "~18.0.0"         # Node 18.0.x (patch updates)
    
    - name: python
      version: ">=3.8.0 <4.0.0"  # Python 3.8 to 3.x
```

---

## Dependency Resolution

### Resolution Algorithm

```
1. Parse all dependency declarations
2. Build dependency graph
3. Detect cycles
4. Detect conflicts
5. Resolve versions
6. Generate installation order
7. Execute installation
```

### Resolution Example

```
Input:
  - skill-a requires skill-b@^1.0.0
  - skill-b requires skill-c@>=2.0.0
  - skill-c requires skill-d@1.0.0

Resolution:
  1. skill-d@1.0.0 (no dependencies)
  2. skill-c@2.0.0 (depends on skill-d)
  3. skill-b@1.0.0 (depends on skill-c)
  4. skill-a (depends on skill-b)

Output:
  [skill-d@1.0.0, skill-c@2.0.0, skill-b@1.0.0, skill-a]
```

### Conflict Detection

```
Conflict Types:

1. Version Conflict
   skill-a requires skill-c@^1.0.0
   skill-b requires skill-c@^2.0.0
   → Cannot resolve (major version mismatch)

2. Direct Conflict
   skill-a requires skill-b
   skill-a conflicts: skill-b
   → Cannot install (explicit conflict)

3. Circular Dependency
   skill-a requires skill-b
   skill-b requires skill-c
   skill-c requires skill-a
   → Cannot resolve (cycle detected)
```

---

## Dependency Graph

### Graph Structure

```json
{
  "nodes": [
    {
      "name": "skill-a",
      "version": "1.0.0",
      "type": "skill"
    },
    {
      "name": "skill-b",
      "version": "1.2.0",
      "type": "skill"
    }
  ],
  "edges": [
    {
      "from": "skill-a",
      "to": "skill-b",
      "type": "requires",
      "version": "^1.0.0"
    }
  ]
}
```

### Graph Visualization

```
skill-a
  ├── requires skill-b@^1.0.0
  │     └── requires skill-c@>=2.0.0
  │           └── requires skill-d@1.0.0
  └── recommends skill-e@~1.0.0
```

---

## Dependency Management CLI

### List Dependencies

```bash
# List all dependencies
./core/deps/list.sh skill-a

# List only direct dependencies
./core/deps/list.sh skill-a --direct

# List only missing dependencies
./core/deps/list.sh skill-a --missing

# Show dependency tree
./core/deps/tree.sh skill-a
```

### Resolve Dependencies

```bash
# Resolve dependencies
./core/deps/resolve.sh skill-a

# Dry run (show what would be installed)
./core/deps/resolve.sh skill-a --dry-run

# Verbose output
./core/deps/resolve.sh skill-a --verbose
```

### Install Dependencies

```bash
# Install all dependencies
./core/deps/install.sh skill-a

# Install only missing dependencies
./core/deps/install.sh skill-a --missing

# Force reinstall
./core/deps/install.sh skill-a --force
```

### Check Conflicts

```bash
# Check for conflicts
./core/deps/check.sh

# Check specific asset
./core/deps/check.sh skill-a

# Check all assets
./core/deps/check.sh --all
```

---

## Lock File

### Structure

```json
{
  "version": "1.0.0",
  "generated": "2026-07-19T00:00:00Z",
  "dependencies": {
    "skill-a": {
      "version": "1.0.0",
      "resolved": "https://registry.example.com/skill-a@1.0.0",
      "integrity": "sha256-abc123...",
      "dependencies": {
        "skill-b": {
          "version": "1.2.0",
          "resolved": "https://registry.example.com/skill-b@1.2.0",
          "integrity": "sha256-def456..."
        }
      }
    }
  }
}
```

### Lock File Commands

```bash
# Generate lock file
./core/deps/lock.sh

# Verify lock file
./core/deps/verify.sh

# Update lock file
./core/deps/update.sh
```

---

## Dependency Caching

### Cache Structure

```
.cache/
├── dependencies/
│   ├── skill-a@1.0.0/
│   │   └── ...
│   └── skill-b@1.2.0/
│       └── ...
└── metadata/
    └── registry.json
```

### Cache Commands

```bash
# List cached dependencies
./core/deps/cache.sh list

# Clear cache
./core/deps/cache.sh clear

# Verify cache integrity
./core/deps/cache.sh verify
```

---

## Future Enhancements

1. **Dependency Injection** — Runtime dependency injection
2. **Optional Dependencies** — Enable/disable optional deps
3. **Peer Dependencies** — Shared dependencies
4. **Dependency Updates** — Auto-update notifications
5. **Dependency Audit** — Security audit of dependencies
6. **Dependency Visualization** — Web-based graph viewer
7. **Dependency Analytics** — Usage statistics