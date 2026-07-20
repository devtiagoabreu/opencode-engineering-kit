# Marketplace Specification

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Overview

The Marketplace enables publishing, discovery, and installation of community-contributed assets (Skills, Agents, Prompts, Templates, Plugins) for the OpenCode Engineering Kit.

---

## Design Principles

1. **Open** — Anyone can publish
2. **Trusted** — Verified publishers
3. **Quality** — Automated quality checks
4. **Discoverable** — Easy to find assets
5. **Fair** — No paywalls for core functionality

---

## Marketplace Architecture

```
marketplace/
├── registry/                 # Asset registry
│   ├── assets.json          # All assets
│   ├── publishers.json      # Verified publishers
│   └── categories.json      # Category definitions
├── api/                      # REST API
│   ├── search/              # Search endpoint
│   ├── publish/             # Publish endpoint
│   └── stats/               # Statistics endpoint
├── web/                      # Web interface
│   ├── index.html           # Homepage
│   ├── asset.html           # Asset page
│   └── search.html          # Search page
└── README.md
```

---

## Asset Publishing

### Publisher Account

```bash
# Create publisher account
./marketplace/publisher/create.sh --name "John Doe" --email "john@example.com"

# Verify publisher
./marketplace/publisher/verify.sh --publisher "john-doe" --token "abc123"
```

### Publish Asset

```bash
# Publish skill
./marketplace/publish.sh --type skill --path ./assets/skills/my-skill

# Publish with metadata
./marketplace/publish.sh \
  --type skill \
  --path ./assets/skills/my-skill \
  --name "my-awesome-skill" \
  --description "An awesome skill" \
  --tags "awesome,skill,devops" \
  --category devops
```

### Publish Workflow

```
1. Author creates asset
   └─ Develop locally

2. Author validates asset
   └─ Run validation tests

3. Author submits to marketplace
   └─ Publish command

4. Automated checks
   └─ Schema validation
   └─ Content review
   └─ Security scan

5. Review (optional)
   └─ Human review for verified status

6. Publication
   └─ Asset available in marketplace
```

### Publish Manifest

```yaml
# marketplace.yml
name: my-awesome-skill
version: 1.0.0
description: An awesome skill for Docker
category: devops
tags:
  - docker
  - containers
  - devops
author: john-doe
license: MIT
compatible:
  - opencode
  - claude-code
  - cursor
repository: https://github.com/john-doe/my-skill
```

---

## Asset Categories

| Category | Description | Examples |
|----------|-------------|----------|
| devops | DevOps tools | Docker, K8s, CI/CD |
| backend | Backend development | APIs, databases, auth |
| frontend | Frontend development | React, Vue, CSS |
| testing | Testing frameworks | Unit, integration, e2e |
| security | Security practices | OWASP, scanning |
| code-quality | Code quality | Linting, formatting |
| documentation | Documentation | Docs, diagrams |
| data | Data engineering | ETL, pipelines |
| mobile | Mobile development | iOS, Android |
| ai-ml | AI/ML | Models, training |

---

## Asset Quality Levels

| Level | Description | Requirements |
|-------|-------------|--------------|
| Community | Basic quality | Schema validation |
| Verified | Higher quality | + Tests, docs |
| Featured | Excellent quality | + Review, examples |

### Quality Requirements

| Level | Schema | Tests | Docs | Examples | Review |
|-------|--------|-------|------|----------|--------|
| Community | ✅ | ❌ | ❌ | ❌ | ❌ |
| Verified | ✅ | ✅ | ✅ | ❌ | ❌ |
| Featured | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## Search & Discovery

### Search API

```bash
# Search by keyword
GET /api/search?q=docker

# Search by category
GET /api/search?category=devops

# Search by tags
GET /api/search?tags=docker,containers

# Search by author
GET /api/search?author=john-doe

# Search with filters
GET /api/search?q=api&category=backend&difficulty=intermediate&compatible=opencode
```

### Search Results

```json
{
  "query": "docker",
  "total": 15,
  "results": [
    {
      "name": "docker-best-practices",
      "type": "skill",
      "version": "1.0.0",
      "description": "Best practices for Docker",
      "category": "devops",
      "tags": ["docker", "containers"],
      "author": "john-doe",
      "quality": "verified",
      "downloads": 1250,
      "rating": 4.5,
      "compatible": ["opencode", "claude-code"]
    }
  ]
}
```

---

## Ratings & Reviews

### Rating System

- **5-star rating** — 1 to 5 stars
- **Written review** — Optional text review
- **Verified purchase** — Must have used asset

### Review Example

```json
{
  "asset": "docker-best-practices",
  "reviewer": "jane-doe",
  "rating": 5,
  "title": "Excellent Docker practices",
  "content": "This skill helped me improve my Docker setup significantly.",
  "verified": true,
  "date": "2026-07-19"
}
```

### Review Display

```
⭐⭐⭐⭐⭐ (4.5/5) — 42 reviews

"Excellent Docker practices" — jane-doe ⭐⭐⭐⭐⭐
"This skill helped me improve my Docker setup..."

"Good but needs more examples" — bob-smith ⭐⭐⭐⭐
"Useful content, but I would like more examples..."
```

---

## Asset Statistics

### Download Tracking

```json
{
  "asset": "docker-best-practices",
  "stats": {
    "total_downloads": 1250,
    "monthly_downloads": 250,
    "weekly_downloads": 60,
    "daily_downloads": 10
  }
}
```

### Usage Analytics

```json
{
  "asset": "docker-best-practices",
  "analytics": {
    "unique_users": 500,
    "average_rating": 4.5,
    "satisfaction_score": 0.85,
    "recommendation_rate": 0.92
  }
}
```

---

## Web Interface

### Homepage

```
OpenCode Engineering Kit Marketplace

[Search bar]

Categories:
├── DevOps (25)
├── Backend (30)
├── Frontend (20)
├── Testing (15)
└── More...

Featured Assets:
├── docker-best-practices ⭐4.5
├── api-design-patterns ⭐4.8
└── react-testing-guide ⭐4.6

Recently Added:
├── kubernetes-deployment
├── graphql-setup
└── terraform-modules
```

### Asset Page

```
docker-best-practices
by john-doe | v1.0.0 | Verified

⭐⭐⭐⭐⭐ (4.5) — 42 reviews

Best practices for Docker containers...

Tags: docker, containers, devops

Compatible with: OpenCode, Claude Code, Cursor

[Install] [Source Code] [Report Issue]

## Overview
Learn Docker best practices...

## Installation
```bash
./marketplace/install.sh docker-best-practices
```

## Reviews

...

```

---

## CLI Integration

### Install from Marketplace

```bash
# Search marketplace
./marketplace/search.sh docker

# Install asset
./marketplace/install.sh docker-best-practices

# Install specific version
./marketplace/install.sh docker-best-practices@1.2.0

# Update installed assets
./marketplace/update.sh

# List installed assets
./marketplace/list.sh
```

### AI-Assisted Discovery

```bash
# Natural language search
./marketplace/ai-search.sh "I need to improve my Docker setup"

# Output
Based on your needs, I recommend:

1. docker-best-practices (⭐4.5)
   - Learn Docker best practices
   - Verified quality
   - 1250 downloads

2. docker-compose-setup (⭐4.2)
   - Docker Compose configurations
   - Community quality
   - 800 downloads

Would you like to install these?
```

---

## Future Enhancements

1. **Paid Assets** — Optional paid premium assets
2. **Subscriptions** — Monthly subscription for premium content
3. **Enterprise** — Enterprise marketplace
4. **Integrations** — GitHub, GitLab integration
5. **Analytics Dashboard** — Publisher analytics
6. **Automated Testing** — CI/CD for marketplace
7. **Webhooks** — Publish notifications
8. **API Access** — REST API for external tools
