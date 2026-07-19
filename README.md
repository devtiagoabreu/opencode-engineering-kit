# OpenCode Engineering Kit

> Skills, Agents, Commands, Prompts, Templates, and Context for the OpenCode ecosystem.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/opencode-ai/opencode-engineering-kit)
[![OpenCode](https://img.shields.io/badge/OpenCode-compatible-brightgreen.svg)](https://opencode.ai)

## Overview

**OpenCode Engineering Kit** is an open source library providing reusable resources to accelerate productivity with OpenCode. Inspired by projects like [Shokunin](https://github.com/hirefrank/shokunin) and [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill), it offers:

- **50+ Skills** organized by category
- **13 Agents** with configured personas
- **30+ Templates** for new projects and configurations
- **Reusable Prompts** for common tasks
- **Custom Commands** for daily use
- **Complete Context** on project, stack, and conventions

## Compatibility

| Platform | Status |
|----------|--------|
| OpenCode | Primary |
| Claude Code | Compatible |
| Cursor | Compatible |
| GitHub Copilot | Partial |

## Installation

### Option 1: Direct Clone

```bash
git clone https://github.com/opencode-ai/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

### Option 2: Installation Script

```bash
curl -fsSL https://raw.githubusercontent.com/opencode-ai/opencode-engineering-kit/main/install.sh | bash
```

### Prerequisites

- Git 2.0+
- Bash 4.0+
- OpenCode (recommended)

## Structure

```
opencode-engineering-kit/
├── skills/          # Skills organized by category
├── agents/          # Agents with personas
├── templates/       # Project templates
├── prompts/         # Reusable prompts
├── commands/        # Custom commands
├── context/         # Project context
├── scripts/         # Automation scripts
├── docs/            # Documentation
├── examples/        # Usage examples
└── tests/           # Tests
```

## Quick Start

### Using a Skill

```bash
# Navigate to the desired skill
cat skills/devops/docker-best-practices/SKILL.md

# Or copy to your project
cp -r skills/devops/docker-best-practices/ /your/project/
```

### Using an Agent

```bash
# View the agent persona
cat agents/devops-engineer.md
```

### Using Templates

```bash
# Create a new project
cp -r templates/new-project/ /your/new-project/
cd /your/new-project/
# Customize the variables
```

## Available Skills

| Category | Skills | Description |
|----------|--------|-------------|
| `devops` | Docker, Kubernetes, CI/CD | Infrastructure and deployment |
| `frontend` | React, Vue, CSS | Frontend development |
| `backend` | API, Database, Python | Backend development |
| `testing` | Unit, Integration, E2E | Software testing |
| `security` | OWASP, Auditing | Security |
| `git` | Workflow, Branching | Git operations |
| `documentation` | README, API Docs | Documentation |

## Available Agents

| Agent | Description |
|-------|-------------|
| `devops-engineer` | Infrastructure and CI/CD |
| `frontend-developer` | UI/UX and frontend |
| `backend-developer` | APIs and backend |
| `fullstack-developer` | Frontend + Backend |
| `mobile-developer` | iOS and Android |
| `security-engineer` | Security |
| `qa-engineer` | Testing and quality |

## Contributing

Contributions are welcome! Read our [CONTRIBUTING.md](./CONTRIBUTING.md) for a complete guide.

### Contribution Types

1. **New Skill** — Create a skill for a new task
2. **New Agent** — Define a new persona
3. **New Template** — Create a template for new projects
4. **Improvement** — Suggest improvements to existing components
5. **Bug Report** — Report issues found

## Roadmap

See [ROADMAP.md](./ROADMAP.md) for roadmap details.

### Planned Milestones

- **v0.1.0** — Structure and bootstrap
- **v0.2.0** — Core skills and agents
- **v0.3.0** — Templates and prompts
- **v1.0.0** — Stable release

## License

This project is licensed under the MIT License — see the [LICENSE](./LICENSE) file for details.

## Contact

- **Issues:** [GitHub Issues](https://github.com/opencode-ai/opencode-engineering-kit/issues)
- **Discussions:** [GitHub Discussions](https://github.com/opencode-ai/opencode-engineering-kit/discussions)
- **Email:** OpenCode Community

## Acknowledgments

- [OpenCode](https://opencode.ai) for the platform
- [Shokunin](https://github.com/hirefrank/shokunin) for inspiration
- [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill) for inspiration
- All contributors who help improve this project