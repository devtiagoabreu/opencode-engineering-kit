# Registry Specification

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Overview

The Registry is the central catalog of all assets in the OpenCode Engineering Kit. It enables discovery, validation, and management of Skills, Agents, Prompts, Templates, Commands, Playbooks, and Recipes.

---

## Design Principles

1. **Single Source of Truth** — Registry is the authoritative index
2. **Auto-Generated** — Indexes generated from metadata, not manually maintained
3. **Validated** — All entries validated against schemas
4. **Queryable** — Supports search by multiple criteria
5. **Versioned** — Registry version tracks schema changes

---

## Registry Structure

```
core/registry/
├── schema/                    # JSON Schemas
│   ├── skill.schema.json
│   ├── agent.schema.json
│   ├── prompt.schema.json
│   ├── template.schema.json
│   ├── command.schema.json
│   ├── playbook.schema.json
│   └── recipe.schema.json
├── index/                     # Generated indexes
│   ├── skills.json
│   ├── agents.json
│   ├── prompts.json
│   ├── templates.json
│   ├── commands.json
│   ├── playbooks.json
│   └── recipes.json
├── generate.sh                # Index generator
├── validate.sh                # Schema validator
└── README.md
```

---

## Asset Schema

### Skill Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Skill",
  "description": "Schema for OpenCode Engineering Kit Skills",
  "type": "object",
  "required": ["name", "description", "category", "version", "author", "compatible"],
  "properties": {
    "name": {
      "type": "string",
      "pattern": "^[a-z0-9-]+$",
      "description": "Unique skill identifier"
    },
    "description": {
      "type": "string",
      "minLength": 10,
      "maxLength": 200,
      "description": "Brief description of the skill"
    },
    "category": {
      "type": "string",
      "enum": ["devops", "backend", "frontend", "testing", "security", "git", "code-quality", "database", "mobile", "documentation"],
      "description": "Skill category"
    },
    "version": {
      "type": "string",
      "pattern": "^[0-9]+\\.[0-9]+\\.[0-9]+$",
      "description": "Semantic version"
    },
    "author": {
      "type": "string",
      "description": "Skill author"
    },
    "tags": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "Searchable tags"
    },
    "compatible": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["opencode", "claude-code", "cursor", "copilot"]
      },
      "description": "Compatible platforms"
    },
    "requires": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "Prerequisites"
    },
    "provides": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "What this skill provides"
    },
    "dependencies": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "version": {
            "type": "string"
          }
        }
      },
      "description": "Other skills this depends on"
    },
    "difficulty": {
      "type": "string",
      "enum": ["beginner", "intermediate", "advanced"],
      "description": "Skill difficulty level"
    },
    "frameworks": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "Related frameworks"
    },
    "languages": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "Related programming languages"
    }
  }
}
```

### Agent Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Agent",
  "description": "Schema for OpenCode Engineering Kit Agents",
  "type": "object",
  "required": ["name", "description", "version", "author", "compatible", "personas"],
  "properties": {
    "name": {
      "type": "string",
      "pattern": "^[a-z0-9-]+$"
    },
    "description": {
      "type": "string",
      "minLength": 10,
      "maxLength": 200
    },
    "version": {
      "type": "string",
      "pattern": "^[0-9]+\\.[0-9]+\\.[0-9]+$"
    },
    "author": {
      "type": "string"
    },
    "tags": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "compatible": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["opencode", "claude-code", "cursor", "copilot"]
      }
    },
    "skills": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "Skills this agent can use"
    },
    "personas": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "Agent personas"
    },
    "dependencies": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "version": {
            "type": "string"
          }
        }
      }
    }
  }
}
```

### Prompt Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Prompt",
  "description": "Schema for OpenCode Engineering Kit Prompts",
  "type": "object",
  "required": ["name", "description", "category", "version", "author", "compatible"],
  "properties": {
    "name": {
      "type": "string",
      "pattern": "^[a-z0-9-]+$"
    },
    "description": {
      "type": "string",
      "minLength": 10,
      "maxLength": 200
    },
    "category": {
      "type": "string",
      "enum": ["code-review", "debugging", "architecture", "security", "performance", "documentation", "testing"]
    },
    "version": {
      "type": "string",
      "pattern": "^[0-9]+\\.[0-9]+\\.[0-9]+$"
    },
    "author": {
      "type": "string"
    },
    "tags": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "compatible": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["opencode", "claude-code", "cursor", "copilot"]
      }
    },
    "variables": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "description": {
            "type": "string"
          },
          "required": {
            "type": "boolean"
          }
        }
      }
    },
    "dependencies": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "version": {
            "type": "string"
          }
        }
      }
    }
  }
}
```

---

## Index Format

### skills.json

```json
{
  "version": "1.0.0",
  "generated": "2026-07-19T00:00:00Z",
  "count": 50,
  "assets": [
    {
      "name": "docker-best-practices",
      "category": "devops",
      "version": "0.1.0",
      "path": "assets/skills/devops/docker-best-practices/SKILL.md",
      "tags": ["docker", "containers", "devops"],
      "difficulty": "intermediate",
      "compatible": ["opencode", "claude-code", "cursor"]
    }
  ],
  "by_category": {
    "devops": ["docker-best-practices", "kubernetes-deployment"],
    "backend": ["api-design", "database-optimization"]
  },
  "by_tag": {
    "docker": ["docker-best-practices"],
    "kubernetes": ["kubernetes-deployment"]
  }
}
```

---

## Registry Operations

### Generate Index

```bash
# Generate all indexes
./core/registry/generate.sh

# Generate specific index
./core/registry/generate.sh --type skills
./core/registry/generate.sh --type agents
```

### Validate Assets

```bash
# Validate all assets
./core/registry/validate.sh

# Validate specific asset type
./core/registry/validate.sh --type skills
./core/registry/validate.sh --type agents

# Validate specific asset
./core/registry/validate.sh --path assets/skills/devops/docker-best-practices
```

### Query Registry

```bash
# Search by category
./core/discovery/search.sh --category devops

# Search by tag
./core/discovery/search.sh --tag docker

# Search by framework
./core/discovery/search.sh --framework react

# Search by difficulty
./core/discovery/search.sh --difficulty beginner
```

---

## Metadata Storage

Each asset must include a `metadata.json` file alongside its main file:

```json
{
  "schema_version": "1.0.0",
  "generated_at": "2026-07-19T00:00:00Z",
  "validated_at": "2026-07-19T00:00:00Z",
  "validation_passed": true,
  "warnings": [],
  "dependencies_resolved": true
}
```

---

## CI/CD Integration

### GitHub Actions Workflow

```yaml
name: Validate Registry

on:
  push:
    paths:
      - 'assets/**'
      - 'core/registry/**'
  pull_request:
    paths:
      - 'assets/**'
      - 'core/registry/**'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Validate all assets
        run: ./core/registry/validate.sh
      - name: Generate indexes
        run: ./core/registry/generate.sh
      - name: Check for changes
        run: git diff --exit-code core/registry/index/
```

---

## Future Enhancements

1. **REST API** — HTTP interface for registry queries
2. **Graph Database** — Store dependency relationships
3. **Full-Text Search** — Search within asset content
4. **Analytics** — Track asset usage and popularity
5. **Recommendations** — Suggest related assets