# OpenCode Engineering Kit

> Skills, Agents, Commands, Prompts, Templates, and Context for the OpenCode ecosystem.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/opencode-ai/opencode-engineering-kit)
[![OpenCode](https://img.shields.io/badge/OpenCode-compatible-brightgreen.svg)](https://opencode.ai)
[![CI](https://github.com/opencode-ai/opencode-engineering-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/opencode-ai/opencode-engineering-kit/actions/workflows/ci.yml)

## Overview

**OpenCode Engineering Kit** is an open source library providing reusable resources to accelerate productivity with OpenCode. Inspired by projects like [Shokunin](https://github.com/hirefrank/shokunin) and [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill), it offers:

- **Skills** organized by category
- **Agents** with configured personas
- **Templates** for new projects and configurations
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
├── core/            # Core infrastructure
│   ├── registry/    # Asset registry
│   └── quality/     # Quality gates
├── docs/            # Documentation
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
| `devops` | Docker | Infrastructure and deployment |
| `backend` | API Design | Backend development |
| `frontend` | - | Frontend development |
| `testing` | Python Testing | Software testing |
| `security` | - | Security |
| `git` | Git Workflow | Git operations |
| `code-quality` | Code Review | Code quality |

## Available Agents

| Agent | Description |
|-------|-------------|
| `devops-engineer` | Infrastructure and CI/CD |
| `frontend-developer` | UI/UX and frontend |
| `backend-developer` | APIs and backend |

## Quality Gates

This project uses automated quality gates:

- **Linting**: Markdown, YAML, ShellCheck
- **Testing**: Content and format validation
- **CI/CD**: GitHub Actions pipeline

Run quality checks locally:

```bash
# Run all tests
./scripts/test.sh

# Run quality gates
./core/quality/validate.sh
```

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

### Architecture Evolution

See [docs/ARCHITECTURE_EVOLUTION.md](./docs/ARCHITECTURE_EVOLUTION.md) for the v3.0 architecture plan.

## Security

See [SECURITY.md](./SECURITY.md) for security policies and reporting.

## Documentation

### English
- [User Guide](./docs/USER_GUIDE.md) - Complete guide for using the kit
- [Quick Reference](./docs/QUICK_REFERENCE.md) - One-page reference card

### Português
- [Guia do Usuário](./docs/GUIA_USUARIO.md) - Guia completo para usar o kit
- [Cartão de Referência](./docs/CARTAO_REFERENCIA.md) - Referência rápida

## License

This project is licensed under the MIT License — see the [LICENSE](./LICENSE) file for details.

## Contact

- **Issues:** [GitHub Issues](https://github.com/opencode-ai/opencode-engineering-kit/issues)
- **Discussions:** [GitHub Discussions](https://github.com/opencode-ai/opencode-engineering-kit/discussions)

## Acknowledgments

- [OpenCode](https://opencode.ai) for the platform
- [Shokunin](https://github.com/hirefrank/shokunin) for inspiration
- [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill) for inspiration
- All contributors who help improve this project