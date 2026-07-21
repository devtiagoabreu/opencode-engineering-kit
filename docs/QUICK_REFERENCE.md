# Quick Reference Card

> One-page reference for using the OpenCode Engineering Kit

---

## Installation

```bash
git clone https://github.com/opencode-ai/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

---

## Common Commands

### Discovery

```bash
# Search for assets
./core/discovery/search.sh "docker"

# Filter by category
./core/discovery/filter.sh --category=devops

# Filter by compatibility
./core/discovery/filter.sh --compatible=opencode

# Generate index
./core/discovery/index.sh
```

### Validation

```bash
# Validate all assets
./core/validator/validate-all.sh

# Validate specific asset
./core/validator/validate.sh skills/devops/docker-best-practices
```

### Testing

```bash
# Run all tests
./scripts/test.sh

# Run specific test category
./tests/skills/test-skill-content.sh
./tests/agents/test-agent-content.sh
./tests/discovery/test-discovery-system.sh
./tests/security/test-security.sh
./tests/performance/test-performance.sh
```

### Security

```bash
# Dependency audit
./core/security/dependency-audit.sh

# Secret scanning
./core/security/secret-scan.sh

# Vulnerability scanning
./core/security/vulnerability-scan.sh

# Access control check
./core/security/access-control.sh

# Audit logging
./core/security/audit-log.sh
```

### Marketplace

```bash
# Search marketplace
./core/marketplace/search.sh "docker"

# Install asset
./core/marketplace/install.sh skill docker-best-practices

# Open web interface
open marketplace-web/index.html
```

### Dependency Resolution

```bash
# Resolve dependencies
./core/resolver/resolve.sh skills/devops/docker-best-practices

# Generate dependency graph
./core/resolver/graph.sh

# Validate dependencies
./core/resolver/validate.sh
```

### Plugin System

```bash
# Load plugins
./core/plugin/loader.sh

# Install plugin
./core/plugin/installer.sh my-plugin

# Uninstall plugin
./core/plugin/uninstaller.sh my-plugin
```

---

## Directory Structure

```
opencode-engineering-kit/
├── skills/              # Skills organized by category
│   ├── devops/
│   ├── backend/
│   ├── frontend/
│   ├── testing/
│   └── security/
├── agents/              # Agents with personas
├── prompts/             # Reusable prompts
├── templates/           # Project templates
├── commands/            # Custom commands
├── playbooks/           # Step-by-step workflows
├── recipes/             # Complete project setups
├── context/             # Project context
├── core/                # Core infrastructure
│   ├── registry/        # Asset registry
│   ├── discovery/       # Asset discovery
│   ├── resolver/        # Dependency resolution
│   ├── validator/       # Schema validation
│   ├── version/         # Versioning system
│   ├── plugin/          # Plugin system
│   ├── marketplace/     # Marketplace
│   ├── security/        # Security tools
│   └── quality/         # Quality gates
├── marketplace-web/     # Marketplace web interface
├── tests/               # Tests
├── scripts/             # Automation scripts
└── docs/                # Documentation
```

---

## Skill Structure

```
skill-name/
├── SKILL.md            # Main skill documentation
├── metadata.json       # Skill metadata
├── README.md           # Additional documentation
└── examples/           # Usage examples
```

---

## Agent Structure

```yaml
---
name: agent-name
description: Agent description
version: 0.1.0
author: Author Name
tags: [tag1, tag2]
compatible:
  - opencode
  - claude-code
  - cursor
skills:
  - skill1
  - skill2
personas:
  - Persona 1
  - Persona 2
---

# Agent Name

## Persona
...

## Capabilities
...

## Context
...

## Usage Examples
...
```

---

## Creating New Assets

### Create a Skill

1. Copy the skill template:

```bash
cp -r templates/skill skills/category/new-skill
```

2. Edit `SKILL.md` with your content

3. Run validation:

```bash
./core/validator/validate.sh skills/category/new-skill
```

### Create an Agent

1. Copy the agent template:

```bash
cp templates/agent/agent.md agents/new-agent.md
```

2. Edit the agent file with your content

3. Run validation:

```bash
./core/validator/validate.sh agents/new-agent.md
```

---

## Quality Gates

All assets must pass:

- **Schema validation** - Valid metadata
- **Content validation** - Required sections
- **Linting** - Markdown standards
- **Testing** - Automated tests

Run quality checks:

```bash
./core/quality/validate.sh
```

---

## Support

- **GitHub Issues**: https://github.com/opencode-ai/opencode-engineering-kit/issues
- **Documentation**: See `docs/` directory
- **Examples**: See `examples/` directory