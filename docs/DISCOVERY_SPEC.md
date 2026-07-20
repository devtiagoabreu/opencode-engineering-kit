# Discovery Specification

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Overview

The Discovery system enables users to find the right assets for their needs. It provides search, filtering, and recommendation capabilities across all registered assets.

---

## Design Principles

1. **Fast** — Search results in <100ms
2. **Flexible** — Multiple search criteria combinable
3. **Accurate** — Relevant results first
4. **Explainable** — Show why results match
5. **Extensible** — Support new search dimensions

---

## Search Dimensions

| Dimension | Description | Example Values |
|-----------|-------------|----------------|
| Category | Asset category | devops, backend, frontend |
| Tags | Searchable keywords | docker, react, testing |
| Framework | Related frameworks | react, vue, express, flask |
| Language | Programming languages | javascript, python, go |
| Difficulty | Skill level | beginner, intermediate, advanced |
| Compatibility | Platform support | opencode, claude-code, cursor |
| Author | Asset author | opencode-community |
| Version | Asset version | 0.1.0, ^1.0.0 |
| Status | Asset status | stable, beta, deprecated |
| Dependencies | Required assets | requires-docker, requires-git |

---

## Search API

### Command Line

```bash
# Basic search
./core/discovery/search.sh "docker"

# Search by category
./core/discovery/search.sh --category devops

# Search by tag
./core/discovery/search.sh --tag docker

# Search by framework
./core/discovery/search.sh --framework react

# Search by language
./core/discovery/search.sh --language python

# Search by difficulty
./core/discovery/search.sh --difficulty beginner

# Combine criteria
./core/discovery/search.sh --category devops --tag docker --difficulty intermediate

# Search with pagination
./core/discovery/search.sh --category devops --limit 10 --offset 0

# Sort results
./core/discovery/search.sh --category devops --sort name
./core/discovery/search.sh --category devops --sort version
./core/discovery/search.sh --category devops --sort popularity
```

### Output Format

```json
{
  "query": {
    "category": "devops",
    "tag": "docker"
  },
  "total": 5,
  "limit": 10,
  "offset": 0,
  "results": [
    {
      "name": "docker-best-practices",
      "category": "devops",
      "version": "0.1.0",
      "description": "Best practices for Docker containers",
      "tags": ["docker", "containers", "devops"],
      "difficulty": "intermediate",
      "compatible": ["opencode", "claude-code", "cursor"],
      "path": "assets/skills/devops/docker-best-practices/SKILL.md",
      "score": 0.95,
      "reasons": ["matches category", "matches tag"]
    }
  ],
  "facets": {
    "categories": {
      "devops": 10,
      "backend": 15,
      "frontend": 12
    },
    "difficulties": {
      "beginner": 20,
      "intermediate": 25,
      "advanced": 15
    }
  }
}
```

---

## Search Algorithm

### Scoring

Each result receives a score based on:

1. **Exact match** — 1.0 points
2. **Partial match** — 0.5 points
3. **Tag match** — 0.3 points per matching tag
4. **Category match** — 0.2 points
5. **Popularity boost** — 0.1 points per 100 uses

### Ranking

Results are ranked by:

1. Score (descending)
2. Version (newest first)
3. Name (alphabetical)

---

## Faceted Search

Facets provide metadata about search results:

```json
{
  "facets": {
    "categories": {
      "devops": 10,
      "backend": 15,
      "frontend": 12
    },
    "tags": {
      "docker": 5,
      "kubernetes": 3,
      "react": 8
    },
    "difficulties": {
      "beginner": 20,
      "intermediate": 25,
      "advanced": 15
    },
    "compatibility": {
      "opencode": 50,
      "claude-code": 45,
      "cursor": 40
    }
  }
}
```

---

## Recommendation Engine

### Related Assets

When viewing an asset, suggest related assets:

```bash
# Get related assets
./core/discovery/related.sh --asset docker-best-practices

# Output
{
  "asset": "docker-best-practices",
  "related": [
    {
      "name": "kubernetes-deployment",
      "reason": "same category, common pairing"
    },
    {
      "name": "ci-cd-pipeline",
      "reason": "shared tags"
    }
  ]
}
```

### Popular Assets

```bash
# Get popular assets
./core/discovery/popular.sh --limit 10

# Get popular by category
./core/discovery/popular.sh --category devops --limit 5
```

### Recently Updated

```bash
# Get recently updated
./core/discovery/recent.sh --limit 10
```

---

## Search Index

The search index is generated from the registry:

```bash
# Generate search index
./core/discovery/index.sh

# Index structure
core/discovery/index/
├── full-text.json      # Full-text search index
├── tags.json          # Tag index
├── categories.json    # Category index
├── frameworks.json    # Framework index
└── popularity.json    # Popularity index
```

---

## CLI Integration

### Interactive Mode

```bash
# Start interactive search
./core/discovery/interactive.sh

# Output
OpenCode Engineering Kit - Asset Discovery

Search: docker
Category (devops/backend/frontend/testing/security): devops
Tags (comma-separated): containers
Difficulty (beginner/intermediate/advanced): intermediate

Results:
1. docker-best-practices (0.95)
2. docker-compose-setup (0.82)
3. docker-security (0.78)

Select asset (1-3): 1
```

### AI Integration

```bash
# AI-assisted search
./core/discovery/ai-search.sh "I need to set up a Docker container for a Python API"

# Output
Based on your request, I recommend:

1. docker-best-practices
   - Learn Docker best practices
   - Intermediate difficulty
   - Compatible with OpenCode

2. api-design
   - Design RESTful APIs
   - Backend category
   - Python examples

Would you like to install these?
```

---

## Performance

### Index Size

| Index | Expected Size | Build Time |
|-------|---------------|------------|
| full-text.json | ~100KB | ~5s |
| tags.json | ~10KB | ~1s |
| categories.json | ~5KB | ~1s |
| frameworks.json | ~5KB | ~1s |
| popularity.json | ~10KB | ~1s |

### Search Performance

| Operation | Target | Current |
|-----------|--------|---------|
| Simple search | <50ms | N/A |
| Complex search | <100ms | N/A |
| Faceted search | <150ms | N/A |
| Index rebuild | <30s | N/A |

---

## Future Enhancements

1. **Full-text search** — Search within asset content
2. **Semantic search** — Understand natural language queries
3. **Usage analytics** — Track what assets are used
4. **Personalized recommendations** — Based on user history
5. **Collaborative filtering** — "Users who used X also used Y"
6. **Search API** — REST endpoint for external tools
7. **Web UI** — Browser-based search interface
