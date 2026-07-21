# OpenCode Engineering Kit - User Guide

> Complete guide for using the OpenCode Engineering Kit

---

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Skills](#skills)
5. [Agents](#agents)
6. [Prompts](#prompts)
7. [Templates](#templates)
8. [Commands](#commands)
9. [Playbooks](#playbooks)
10. [Recipes](#recipes)
11. [Discovery System](#discovery-system)
12. [Marketplace](#marketplace)
13. [Security](#security)
14. [Troubleshooting](#troubleshooting)

---

## Introduction

The **OpenCode Engineering Kit** is an open source library providing reusable resources to accelerate productivity with AI-powered coding assistants. It works with:

- **OpenCode** (primary)
- **Claude Code**
- **Cursor**
- **GitHub Copilot** (partial)

### What's Included

- **25 Skills** - Best practices and guides for various technologies
- **13 Agents** - Specialized AI personas for different roles
- **3 Prompts** - Reusable prompt templates
- **4 Templates** - Project and asset templates
- **2 Playbooks** - Step-by-step workflows
- **2 Recipes** - Complete project setups

---

## Installation

### Option 1: Clone Repository

```bash
git clone https://github.com/opencode-ai/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

### Option 2: Download Archive

1. Download the latest release from GitHub
2. Extract the archive
3. Run the bootstrap script:

```bash
./scripts/bootstrap.sh
```

### Prerequisites

- Git 2.0+
- Bash 4.0+
- OpenCode (recommended)

---

## Quick Start

### Using a Skill

1. Navigate to the skills directory:

```bash
cd skills/devops/docker-best-practices
```

2. Read the SKILL.md file:

```bash
cat SKILL.md
```

3. Follow the instructions in the skill

### Using an Agent

1. Navigate to the agents directory:

```bash
cd agents
```

2. Read the agent file:

```bash
cat devops-engineer.md
```

3. Use the agent persona in your conversations

### Using a Template

1. Navigate to the templates directory:

```bash
cd templates/new-project
```

2. Copy the template to your project:

```bash
cp -r * /your/project/
```

3. Customize the files for your needs

---

## Skills

Skills are best practices and guides for specific technologies or tasks.

### Available Skills

#### DevOps
- **docker-best-practices** - Docker and container best practices
- **kubernetes-best-practices** - Kubernetes orchestration
- **ci-cd-pipeline** - CI/CD pipeline design
- **terraform-aws** - Terraform with AWS
- **monitoring-observability** - Monitoring and observability
- **incident-response** - Incident management

#### Backend
- **rest-api-design** - REST API design
- **graphql-api** - GraphQL API design
- **database-design** - Database design
- **caching-strategies** - Caching strategies
- **authentication** - Authentication best practices

#### Frontend
- **react-patterns** - React patterns and architecture
- **css-best-practices** - CSS architecture
- **performance** - Frontend performance
- **accessibility** - Web accessibility
- **state-management** - State management

#### Testing
- **unit-testing** - Unit testing
- **integration-testing** - Integration testing
- **e2e-testing** - End-to-end testing

#### Security
- **owasp-top-10** - OWASP Top 10
- **secure-coding** - Secure coding practices

### How to Use a Skill

1. **Find the skill** you need:

```bash
./core/discovery/search.sh "docker"
```

2. **Read the skill** documentation:

```bash
cat skills/devops/docker-best-practices/SKILL.md
```

3. **Follow the instructions** in the skill

4. **Apply the best practices** to your project

---

## Agents

Agents are specialized AI personas for different roles.

### Available Agents

| Agent | Description |
|-------|-------------|
| **devops-engineer** | Infrastructure and CI/CD specialist |
| **backend-developer** | APIs and backend specialist |
| **frontend-developer** | UI/UX and frontend specialist |
| **fullstack-developer** | Full-stack specialist |
| **mobile-developer** | Mobile development specialist |
| **security-engineer** | Security specialist |
| **qa-engineer** | Quality assurance specialist |
| **data-engineer** | Data pipelines specialist |
| **ml-engineer** | Machine learning specialist |
| **technical-writer** | Documentation specialist |
| **product-manager** | Product management specialist |
| **ui-designer** | UI design specialist |
| **site-reliability-engineer** | SRE specialist |

### How to Use an Agent

1. **Find the agent** you need:

```bash
./core/discovery/search.sh "backend"
```

2. **Read the agent** documentation:

```bash
cat agents/backend-developer.md
```

3. **Use the persona** in your conversations with AI assistants

4. **Apply the expertise** to your project

---

## Prompts

Prompts are reusable templates for common tasks.

### Available Prompts

- **code-review-checklist** - Comprehensive code review checklist
- **debug-analysis** - Debug analysis prompt
- **system-design** - System design prompt

### How to Use a Prompt

1. **Find the prompt** you need:

```bash
./core/discovery/search.sh "code review"
```

2. **Read the prompt**:

```bash
cat prompts/code-review/code-review-checklist.md
```

3. **Copy the prompt** to your clipboard

4. **Paste the prompt** into your AI assistant

---

## Templates

Templates are starting points for new projects and assets.

### Available Templates

- **new-project** - Template for new projects
- **skill** - Template for creating skills
- **agent** - Template for creating agents
- **prompt** - Template for creating prompts

### How to Use a Template

1. **Find the template** you need:

```bash
ls templates/
```

2. **Copy the template** to your project:

```bash
cp -r templates/new-project /your/project/
```

3. **Customize** the files for your needs

---

## Commands

Commands are quick actions for common tasks.

### Available Commands

- **review** - Code review command
- **test** - Run tests command
- **lint** - Run linting command

### How to Use a Command

1. **Find the command** you need:

```bash
ls commands/
```

2. **Read the command** documentation:

```bash
cat commands/review/review.md
```

3. **Execute the command** as described

---

## Playbooks

Playbooks are step-by-step workflows for common tasks.

### Available Playbooks

- **new-project-setup** - Complete project setup guide
- **code-review-process** - Code review process

### How to Use a Playbook

1. **Find the playbook** you need:

```bash
ls playbooks/
```

2. **Read the playbook**:

```bash
cat playbooks/new-project-setup.md
```

3. **Follow the steps** in the playbook

---

## Recipes

Recipes are complete project setups with all necessary components.

### Available Recipes

- **react-project-setup** - React project setup
- **python-project-setup** - Python project setup

### How to Use a Recipe

1. **Find the recipe** you need:

```bash
ls recipes/
```

2. **Read the recipe**:

```bash
cat recipes/react-project-setup.md
```

3. **Follow the steps** to set up your project

---

## Discovery System

The discovery system helps you find assets by keyword, category, or compatibility.

### Search for Assets

```bash
# Search by keyword
./core/discovery/search.sh "docker"

# Search by category
./core/discovery/filter.sh --category=devops

# Search by compatibility
./core/discovery/filter.sh --compatible=opencode
```

### Generate Index

```bash
./core/discovery/index.sh
```

### View Index

```bash
cat core/discovery/index/skills.txt
cat core/discovery/index/agents.txt
```

---

## Marketplace

The marketplace allows you to browse and install assets.

### Browse Assets

1. Open the marketplace web interface:

```bash
open marketplace-web/index.html
```

2. Use the search and filters to find assets

3. Click "Install" to install an asset

### Install Assets via CLI

```bash
# Install a skill
./core/marketplace/install.sh skill docker-best-practices

# Install an agent
./core/marketplace/install.sh agent backend-developer
```

### Search Assets

```bash
./core/marketplace/search.sh "docker"
```

---

## Security

The kit includes security tools for auditing your project.

### Run Security Scans

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

### Security Best Practices

1. **Never commit secrets** - Use environment variables
2. **Run security scans** regularly
3. **Keep dependencies updated**
4. **Follow secure coding practices**

---

## Troubleshooting

### Common Issues

#### Issue: Scripts not executable

**Solution:**

```bash
chmod +x scripts/*.sh
chmod +x core/**/*.sh
chmod +x tests/**/*.sh
```

#### Issue: Discovery system not finding assets

**Solution:**

```bash
# Regenerate the index
./core/discovery/index.sh
```

#### Issue: Tests failing

**Solution:**

```bash
# Run all tests
./scripts/test.sh

# Run specific test
./tests/skills/test-skill-content.sh
```

#### Issue: Validation errors

**Solution:**

```bash
# Run validation
./core/validator/validate-all.sh
```

### Getting Help

- **GitHub Issues**: https://github.com/opencode-ai/opencode-engineering-kit/issues
- **Documentation**: See the `docs/` directory
- **Examples**: See the `examples/` directory

---

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for details.

### Quick Contribution Guide

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

---

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

---

## Acknowledgments

- [OpenCode](https://opencode.ai) for the platform
- [Shokunin](https://github.com/hirefrank/shokunin) for inspiration
- [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill) for inspiration
- All contributors who help improve this project