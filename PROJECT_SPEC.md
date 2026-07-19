# PROJECT_SPEC.md — OpenCode Engineering Kit

> **Version:** 0.1.0 | **Date:** 2026-07-18 | **Status:** Draft
>
> This document is the **single source of truth** for all project implementation.
> Any implementation must strictly follow this document.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Objectives](#2-objectives)
3. [Non-Objectives](#3-non-objectives)
4. [Scope](#4-scope)
5. [Architecture](#5-architecture)
6. [Components](#6-components)
7. [Directory Structure](#7-directory-structure)
8. [Style Guide](#8-style-guide)
9. [Versioning](#9-versioning)
10. [Development Workflow](#10-development-workflow)
11. [Quality Criteria](#11-quality-criteria)
12. [Testing](#12-testing)
13. [Security](#13-security)
14. [Compatibility](#14-compatibility)
15. [Dependencies](#15-dependencies)
16. [Licensing](#16-licensing)
17. [Roadmap](#17-roadmap)
18. [Glossary](#18-glossary)
19. [Appendix A: Skill Examples](#appendix-a-skill-examples)
20. [Appendix B: Agent Examples](#appendix-b-agent-examples)

---

## 1. Overview

### 1.1 What is OpenCode Engineering Kit

OpenCode Engineering Kit is an open source library providing Skills, Agents, Commands, Prompts, Templates, and Context for the OpenCode ecosystem. Inspired by [Shokunin](https://github.com/hirefrank/shokunin) and [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill), it focuses on providing reusable, high-quality resources for AI-assisted development.

### 1.2 Problem It Solves

Developers using OpenCode (or similar AI coding tools) constantly recreate configurations, prompts, and workflows from scratch. The Engineering Kit provides a standardized, reusable set of resources that accelerate productivity and ensure consistency across projects.

### 1.3 Target Audience

- Developers using OpenCode as IDE/AI assistant
- Teams wanting to share configurations and workflows
- Contributors wanting to expand the OpenCode ecosystem
- Users migrating from Claude Code or Cursor to OpenCode

### 1.4 Supported Platforms

| Platform | Support Level | Notes |
|----------|--------------|-------|
| OpenCode | **Primary** | Native format, full support |
| Claude Code | **Compatible** | Via CLAUDE.md |
| Cursor | **Compatible** | Via .cursor/rules/ |
| GitHub Copilot | **Partial** | Via .github/copilot-instructions.md |

### 1.5 License

MIT License — see [LICENSE](./LICENSE).

### 1.6 Project Values

- **Simplicity:** Simple markdown files, no complex dependencies
- **Compatibility:** Work across multiple AI platforms
- **Community:** Open source, contributions welcome
- **Quality:** Tests, code review, complete documentation
- **Security:** No exposure of secrets or sensitive keys
- **AI-Agnostic:** Design for portability across AI tools, not lock-in to one platform

---

## 2. Objectives

### 2.1 Primary Objectives

1. **Provide ready-to-use Skills** for common software development tasks
2. **Offer configured Agents** with specific personas for development roles
3. **Provide Templates** for new projects and configurations
4. **Create reusable Prompts** for efficient AI interactions
5. **Maintain compatibility** with OpenCode, Claude Code, and Cursor
6. **Establish standards** for organization and naming

### 2.2 Secondary Objectives

1. Create an active contributor community
2. Keep documentation always updated
3. Provide installation and configuration scripts
4. Create practical usage examples
5. Integrate with CI/CD for automatic validation

### 2.3 Success Metrics

| Metric | Target | Timeline |
|--------|--------|----------|
| Skills available | 50+ | 6 months |
| Agents available | 20+ | 6 months |
| Templates available | 30+ | 6 months |
| Active contributors | 10+ | 12 months |
| GitHub stars | 100+ | 12 months |
| Skills used in real projects | 10+ | 12 months |

---

## 3. Non-Objectives

The project does **not** intend to:

1. **Replace OpenCode** — it's a complement, not a fork
2. **Provide model hosting** — uses existing APIs
3. **Be an IDE** — it's a resource repository for IDEs
4. **Support all languages equally** — focuses on general use
5. **Maintain backward compatibility** with old OpenCode versions
6. **Provide commercial support** — it's a community project
7. **Include training data** — only prompts and configurations
8. **Manage API keys** — users must manage their own credentials
9. **Be a complete AI agent framework** — it's a resource collection, not an agent runtime

---

## 4. Scope

### 4.1 In Scope

- **Skills** (50+): DevOps, Frontend, Backend, Mobile, Data, Security, etc.
- **Agents** (13 personas): DevOps Engineer, Frontend Developer, Backend Developer, etc.
- **Templates** (12+): New project, configuration, workflow, etc.
- **Prompts** (10 categories): Code Review, Debugging, Architecture, etc.
- **Commands** (vários): Useful commands for daily work
- **Context** (8 files): Project context, stack, decisions, etc.
- **Scripts**: Bootstrap, installation, update
- **Documentation**: Usage guide, examples, contributing

### 4.2 Out of Scope

- Language models (LLMs)
- Hosting infrastructure
- IDEs or code editors
- Build or deploy tools
- LLM performance testing
- Model benchmarking

### 4.3 System Boundaries

```
┌─────────────────────────────────────────────────┐
│                OpenCode Engineering Kit          │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐           │
│  │ Skills  │ │ Agents  │ │Prompts  │           │
│  └────┬────┘ └────┬────┘ └────┬────┘           │
│       │           │           │                 │
│  ┌────┴────┐ ┌────┴────┐ ┌────┴────┐           │
│  │Templates│ │Commands │ │Context  │           │
│  └─────────┘ └─────────┘ └─────────┘           │
│                                                 │
│  ┌─────────────────────────────────────────┐   │
│  │            Scripts & Docs               │   │
│  └─────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────┐
│          External Platforms                     │
│  ┌─────────┐ ┌─────────────┐ ┌──────────────┐  │
│  │OpenCode │ │ Claude Code │ │    Cursor    │  │
│  └─────────┘ └─────────────┘ └──────────────┘  │
└─────────────────────────────────────────────────┘
```

---

## 5. Architecture

### 5.1 Architectural Principles

1. **Simplicity:** Each component is a simple markdown file
2. **Modularity:** Components are independent and reusable
3. **Composition:** Skills can combine agents, prompts, and templates
4. **Portability:** Work on any operating system
5. **Extensibility:** Easy to add new components
6. **AI-Agnostic:** Design for portability, not lock-in to one AI tool

### 5.2 Architectural Decisions

#### AD-001: SKILL.md Format

**Status:** Approved

**Decision:** Skills use markdown format with YAML frontmatter.

**Rationale:**
- Markdown is readable by humans and machines
- YAML frontmatter enables structured metadata
- Compatible with OpenCode, Claude Code, and Cursor
- Easy to version and review

**Consequences:**
- YAML parser required for metadata
- 500-line limit per SKILL.md (justified: keeps skills focused and scannable)
- Standard format for all skills

#### AD-002: Category Organization

**Status:** Approved

**Decision:** Skills are organized in directories by category.

**Rationale:**
- Facilitates navigation and discovery
- Groups related skills
- Categories are expandable (see AD-002b)
- Follows Shokunin pattern

**Consequences:**
- Directory structure is fixed
- Categories are pre-defined in bootstrap
- New category requires bootstrap update

#### AD-002b: Expandable Categories

**Status:** Approved

**Decision:** New categories can be added by creating a new directory under `skills/`. No bootstrap update required for new categories.

**Rationale:**
- Avoids rigidity of fixed categories
- Allows organic growth
- Maintains discoverability

**Consequences:**
- Categories must follow naming conventions
- New categories should be documented in README

#### AD-003: Agents as .md Files

**Status:** Approved

**Decision:** Agents are markdown files with personas.

**Rationale:**
- Consistent with Skills format
- Easy to edit and maintain
- Can include usage examples
- Compatible with OpenCode

**Consequences:**
- 200-line limit per agent (justified: agents should be focused personas)
- Persona defined in content
- Skills referenced in frontmatter

#### AD-004: Context as Separate Files

**Status:** Approved

**Decision:** Context consists of independent .md files.

**Rationale:**
- Enables partial updates
- Facilitates caching per section
- Can be combined dynamically
- Separation of concerns

**Consequences:**
- Multiple files to manage
- Composition mechanism required
- Each file has defined scope

#### AD-005: Scripts in Bash

**Status:** Approved

**Decision:** Installation and configuration scripts in Bash.

**Rationale:**
- Available on all Unix systems
- Easy to understand and modify
- No external dependencies
- Can be read and audited

**Consequences:**
- Doesn't work natively on Windows (requires WSL)
- Error handling required
- Must be tested on multiple distributions

### 5.3 Component Relationships

**Skills vs Agents vs Prompts — What's the difference?**

| Component | Purpose | Content | Analogy |
|-----------|---------|---------|---------|
| **Skill** | Guide for a specific task | Instructions, examples, references | A recipe |
| **Agent** | Persona for a role | Capabilities, context, style | A character |
| **Prompt** | Instructions for AI | Context, task, criteria | A question |

**Key insight:** Skills are task-oriented, Agents are role-oriented, Prompts are interaction-oriented. They can be used independently or combined.

### 5.4 Data Flow

```
User → OpenCode → Loads Skills → Selects Skill →
Executes Agent → Uses Prompts → Applies Templates →
Generates Code → Reviews → Commits
```

### 5.5 Installation Flow

```
User → Clone Repo → Run bootstrap.sh →
Copies Skills/Agents/Prompts → Configures OpenCode →
Uses resources
```

---

## 6. Components

### 6.1 Skills

A **Skill** is a set of instructions, context, and references that enable AI to execute a specific task in an autonomous and reproducible way.

**Key difference from a Prompt:** A skill is a comprehensive guide (instructions + examples + references). A prompt is a focused instruction set for a single interaction.

#### Format

```markdown
---
name: skill-name
description: Clear description (1-1024 characters)
category: devops
version: 1.0.0
author: Author Name
tags: [docker, containerization, devops]
compatible:
  - opencode
  - claude-code
  - cursor
requires: []
provides: []
---

# Skill Name

## Overview

Detailed description of what the skill does and why it's useful.

## Prerequisites

- Requirement 1
- Requirement 2

## Instructions

### Step 1: Description

Detailed instructions...

### Step 2: Description

Detailed instructions...

## Examples

### Example 1: Title

```language
example
```

## References

- [Link 1](url)
- [Link 2](url)

## Notes

- Important note
- Special caution
```

#### Rules

1. **Name:** `^[a-z0-9]+(-[a-z0-9]+)*$` (kebab-case, no spaces)
2. **Description:** 1-1024 characters, must clearly describe the function
3. **Max size:** 500 lines per SKILL.md (keeps skills focused and scannable)
4. **Category:** Must belong to one of the defined categories
5. **Versioning:** Follow semver (MAJOR.MINOR.PATCH)
6. **Compatibility:** Explicitly declare supported platforms
7. **Examples:** Every skill must have at least 1 practical example
8. **References:** Include links to relevant documentation

#### Categories

| Category | Description | Example |
|----------|-------------|---------|
| `code-quality` | Code analysis and improvement | Linting, formatting, code smells |
| `code-review` | Code review | PR reviews, best practices |
| `collaboration` | Teamwork | Pair programming, mob programming |
| `database` | Database operations | SQL, migrations, optimization |
| `debugging` | Debugging and diagnostics | Error analysis, profiling |
| `devops` | Infrastructure and deploy | CI/CD, containers, monitoring |
| `documentation` | Documentation generation | README, API docs, wikis |
| `frontend` | Frontend development | UI, CSS, JavaScript frameworks |
| `git` | Git operations | Branching, merging, rebasing |
| `mobile` | Mobile development | iOS, Android, React Native |
| `backend` | Backend development | APIs, services, microservices |
| `testing` | Software testing | Unit, integration, e2e |
| `security` | Software security | OWASP, vulnerabilities, auditing |

**Adding new categories:** Create a new directory under `skills/` following the naming convention. Document in README.

### 6.2 Agents

An **Agent** is a persona configured with specific skills, context, and communication style for a particular development role.

**Key difference from a Skill:** A skill teaches how to do something. An agent embodies who does it and how they think.

#### Format

```markdown
---
name: agent-name
description: Agent persona description
version: 1.0.0
author: Author Name
tags: [devops, infrastructure]
compatible:
  - opencode
  - claude-code
  - cursor
skills: []
personas: []
---

# Agent Name

## Persona

### Who is this Agent?

Detailed persona description, including:
- Role and responsibilities
- Main skills
- Problem-solving approach
- Communication style

## Capabilities

- Capability 1
- Capability 2
- Capability 3

## Context

### Technical Knowledge

- Technologies mastered
- Tools used
- Best practices followed

### Work Style

- How they approach problems
- How they collaborate with the team
- How they make decisions

## Usage Examples

### Example 1: Title

Example description...

## References

- [Link 1](url)
- [Link 2](url)
```

#### Rules

1. **Max size:** 200 lines (keeps personas focused)
2. **Clear persona:** Must explicitly describe the role
3. **Practical examples:** Include at least 1 usage example
4. **References:** Link related skills and templates
5. **Compatibility:** Declare supported platforms

### 6.3 Prompts

A **Prompt** is a set of instructions and context designed to guide AI to execute a specific task effectively and reproducibly.

**Key difference from a Skill:** A prompt is a focused instruction for a single interaction. A skill is a comprehensive guide with multiple examples and references.

#### Format

```markdown
---
name: prompt-name
description: Prompt description
category: code-review
version: 1.0.0
author: Author Name
tags: [review, quality]
compatible:
  - opencode
  - claude-code
  - cursor
variables: []
---

# Prompt Name

## Objective

What this prompt intends to achieve.

## Instructions

### Context

Context necessary for the AI.

### Task

The specific task the AI should execute.

### Criteria

Success criteria for the task.

## Usage Example

```
[prompt here]
```

## Variations

### Variation 1: Title

[varied prompt]

## References

- [Link 1](url)
```

#### Rules

1. **Max size:** 100 lines (keeps prompts focused)
2. **Clear objective:** Explicitly state the objective
3. **Variables:** Use {{variable}} for placeholders
4. **Examples:** Include complete usage example
5. **Variations:** Provide variations when applicable

### 6.4 Templates

A **Template** is a pre-configured model that serves as a starting point for creating new components, projects, or configurations.

**Key difference from a Skill:** A template is a skeleton to fill in. A skill is a guide to follow.

#### Format

```markdown
---
name: template-name
description: Template description
category: project
version: 1.0.0
author: Author Name
tags: [project, new]
compatible:
  - opencode
  - claude-code
  - cursor
variables: []
---

# Template Name

## Overview

Template description and purpose.

## Usage

### Step 1: Copy Template

```bash
cp -r templates/template-name /path/to/destination
```

### Step 2: Customize

Customization instructions...

## Structure

```
template-name/
├── file1.md
├── file2.md
└── ...
```

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| {{name}} | Project name | my-project |
| {{description}} | Description | My description |

## Example

Customized template example...

## References

- [Link 1](url)
```

### 6.5 Commands

A **Command** is a custom command that can be executed in OpenCode to perform a specific action. Commands are shortcuts for common tasks that save developer time.

**Note:** Commands are markdown documentation of OpenCode's native command functionality. They document how to use existing platform features, not create new ones.

#### Format

```markdown
---
name: command-name
description: Command description
version: 1.0.0
author: Author Name
tags: [utility, automation]
compatible:
  - opencode
  - claude-code
  - cursor
---

# Command Name

## Usage

```bash
/command [arguments]
```

## Description

What this command does.

## Arguments

| Argument | Required | Description | Default |
|----------|----------|-------------|---------|
| arg1 | Yes | Description | - |
| arg2 | No | Description | value |

## Examples

```bash
/command arg1=valor arg2=valor
```

## Notes

- Important notes about the command
```

### 6.6 Context

**Context** is a set of markdown files that provides context about the project, including architecture, conventions, decisions, and other relevant information to help AI understand the project.

**Key difference from Documentation:** Documentation is for humans. Context is structured specifically for AI consumption — concise, factual, and referenceable.

#### Format

```markdown
---
name: context-name
description: Context description
type: project|architecture|conventions|decisions
version: 1.0.0
author: Author Name
---

# Context Name

## Overview

Context description...

## Content

### Section 1

Detailed content...

### Section 2

Detailed content...

## References

- [Link 1](url)
```

#### Rules

1. **Max size:** 200 lines per file (keeps context focused)
2. **Modularity:** Each file covers a specific topic
3. **Updates:** Keep always updated
4. **References:** Link to external sources when necessary
5. **Clarity:** Be clear and concise

---

## 7. Directory Structure

### 7.1 Main Structure

```
opencode-engineering-kit/
├── .github/                    # GitHub configurations
│   ├── ISSUE_TEMPLATE/         # Issue templates
│   ├── PULL_REQUEST_TEMPLATE/  # PR templates
│   ├── workflows/              # GitHub Actions
│   └── FUNDING.yml             # Funding
├── agents/                     # Agents (13 personas)
│   ├── devops-engineer.md
│   ├── frontend-developer.md
│   ├── backend-developer.md
│   ├── fullstack-developer.md
│   ├── mobile-developer.md
│   ├── data-engineer.md
│   ├── ml-engineer.md
│   ├── security-engineer.md
│   ├── qa-engineer.md
│   ├── technical-writer.md
│   ├── product-manager.md
│   ├── ui-designer.md
│   └── site-reliability-engineer.md
├── assets/                     # Static assets
│   ├── images/                 # Images
│   └── icons/                  # Icons
├── commands/                   # OpenCode commands
│   └── (custom commands)
├── context/                    # Project context
│   ├── project.md              # Project overview
│   ├── stack.md                # Tech stack
│   ├── conventions.md          # Code conventions
│   ├── architecture.md         # Architecture
│   ├── decisions.md            # Architectural decisions
│   ├── glossary.md             # Glossary
│   ├── troubleshooting.md      # Troubleshooting
│   └── changelog.md            # Change history
├── docs/                       # Documentation
│   ├── getting-started.md      # Getting started
│   ├── installation.md         # Installation
│   ├── usage.md                # Usage
│   ├── contributing.md         # Contributing
│   └── api.md                  # API/Reference
├── examples/                   # Usage examples
│   ├── basic/                  # Basic examples
│   ├── advanced/               # Advanced examples
│   └── real-world/             # Real-world cases
├── prompts/                    # Reusable prompts
│   ├── code-review/            # Code Review
│   ├── debugging/              # Debugging
│   ├── architecture/           # Architecture
│   ├── testing/                # Testing
│   ├── documentation/          # Documentation
│   ├── refactoring/            # Refactoring
│   ├── security/               # Security
│   ├── performance/            # Performance
│   ├── database/               # Database
│   └── api-design/             # API Design
├── scripts/                    # Auxiliary scripts
│   ├── bootstrap.sh            # Initial setup
│   ├── install.sh              # Installation
│   ├── update.sh               # Update
│   └── uninstall.sh            # Uninstall
├── skills/                     # Skills organized by category
│   ├── code-quality/           # Code quality
│   ├── code-review/            # Code review
│   ├── collaboration/          # Collaboration
│   ├── database/               # Database
│   ├── debugging/              # Debugging
│   ├── devops/                 # DevOps
│   ├── documentation/          # Documentation
│   ├── frontend/               # Frontend
│   ├── git/                    # Git
│   ├── mobile/                 # Mobile
│   ├── backend/                # Backend
│   ├── testing/                # Testing
│   └── security/               # Security
├── templates/                  # Project templates
│   ├── new-project/            # New project
│   ├── opencode-config/        # OpenCode configuration
│   ├── skill/                  # New skill
│   ├── agent/                  # New agent
│   ├── prompt/                 # New prompt
│   ├── command/                # New command
│   ├── context/                # New context
│   ├── workflow/               # CI/CD workflow
│   ├── readme/                 # README
│   ├── contributing/           # CONTRIBUTING
│   ├── changelog/              # CHANGELOG
│   └── license/                # LICENSE
├── tests/                      # Tests
│   ├── skills/                 # Skill tests
│   ├── agents/                 # Agent tests
│   ├── templates/              # Template tests
│   └── scripts/                # Script tests
├── CHANGELOG.md                # Version history
├── CODE_OF_CONDUCT.md          # Code of conduct
├── CONTRIBUTING.md             # Contribution guide
├── LICENSE                     # MIT License
├── PROJECT_SPEC.md             # This document
├── README.md                   # Main documentation
├── ROADMAP.md                  # Project roadmap
├── install.sh                  # Installation script
├── uninstall.sh                # Uninstall script
└── update.sh                   # Update script
```

### 7.2 Directory Conventions

| Directory | Content | Format | Limit |
|-----------|---------|--------|-------|
| `skills/` | Skills organized by category | SKILL.md | 500 lines |
| `agents/` | Agents with personas | .md | 200 lines |
| `templates/` | Project templates | .md | No limit |
| `prompts/` | Reusable prompts | .md | 100 lines |
| `commands/` | OpenCode commands | .md | 50 lines |
| `context/` | Project context | .md | 200 lines |
| `scripts/` | Automation scripts | .sh | No limit |
| `docs/` | Documentation | .md | No limit |
| `examples/` | Usage examples | .md or code | No limit |
| `tests/` | Tests | .sh or .md | No limit |

### 7.3 Organization Rules

1. **One component per file** — each skill, agent, etc. in its own file
2. **Names in kebab-case** — all files use kebab-case
3. **No hidden files** — all files must be visible
4. **README in each directory** — documentation in each main folder
5. **Auto-index** — scripts generate component indices

---

## 8. Style Guide

### 8.1 File Naming

| Type | Format | Example |
|------|--------|---------|
| Skill | kebab-case.md | `docker-best-practices.md` |
| Agent | kebab-case.md | `devops-engineer.md` |
| Template | kebab-case/ | `new-project/` |
| Prompt | kebab-case.md | `code-review-checklist.md` |
| Command | kebab-case.md | `/review` |
| Context | kebab-case.md | `project.md` |
| Script | kebab-case.sh | `bootstrap.sh` |
| Document | kebab-case.md | `getting-started.md` |

### 8.2 Directory Naming

| Type | Format | Example |
|------|--------|---------|
| Category | kebab-case | `code-quality/` |
| Project | kebab-case | `opencode-engineering-kit/` |
| Template | kebab-case | `new-project/` |

### 8.3 Variables

| Context | Format | Example |
|----------|---------|---------|
| YAML | snake_case | `skill_name` |
| Bash | UPPER_SNAKE | `SKILL_NAME` |
| Markdown | {{snake_case}} | `{{skill_name}}` |

### 8.4 Markdown Rules

1. **Lines:** Maximum 80 characters per line
2. **Paragraphs:** Separated by blank line
3. **Lists:** Use '-' for bullets, not '*'
4. **Code:** Always specify language
5. **Links:** Use reference links when possible
6. **Images:** Use descriptive alt text

### 8.5 YAML Rules

1. **Indentation:** 2 spaces
2. **Strings:** Use quotes only when necessary
3. **Lists:** Use flow format for short lists
4. **Comments:** Use to explain complex decisions

### 8.6 Bash Rules

1. **Indentation:** 2 spaces
2. **Variables:** Use ${VAR} for expansion
3. **Strings:** Use double quotes
4. **Shebang:** Always include #!/bin/bash
5. **Errors:** Use set -euo pipefail

### 8.7 Git Conventions

| Convention | Rule | Example |
|------------|------|---------|
| Branch naming | kebab-case | `feature/my-skill` |
| Commit message | Conventional Commits | `feat: add docker skill` |
| PR title | Conventional Commits | `feat: add docker skill` |
| Tags | semver | `v1.0.0` |

### 8.8 Anti-Patterns

| Anti-Pattern | Correct Pattern | Reason |
|--------------|-----------------|--------|
| Hardcoded secrets | Environment variables | Security |
| Duplicated code | Reusable functions | Maintainability |
| Generic names | Descriptive names | Readability |
| Long functions | Small functions | Comprehension |
| Excessive comments | Self-documenting code | Maintainability |

---

## 9. Versioning

### 9.1 Semver

The project uses [Semantic Versioning](https://semver.org/) (SemVer):

```
MAJOR.MINOR.PATCH
```

- **MAJOR:** Incompatible changes with previous versions
- **MINOR:** New compatible features
- **PATCH:** Compatible bug fixes

### 9.2 Examples

| Version | Type | Description |
|---------|------|-------------|
| 0.1.0 | Initial | First release |
| 0.2.0 | Minor | New skills added |
| 0.2.1 | Patch | Bug fix in skill |
| 1.0.0 | Major | Stable release |

### 9.3 Component Versioning

| Component | Versioned with... | Example |
|-----------|-------------------|---------|
| Skills | Project release | v1.0.0 |
| Agents | Project release | v1.0.0 |
| Templates | Project release | v1.0.0 |
| Prompts | Project release | v1.0.0 |
| Context | Project release | v1.0.0 |

### 9.4 Git Tags

```bash
# Create tag
git tag -a v1.0.0 -m "Release 1.0.0"

# Push tags
git push origin v1.0.0
```

---

## 10. Development Workflow

### 10.1 Release Cycle

```
Development → RC → Beta → Stable → Release
     ↓         ↓      ↓       ↓        ↓
  features  testing polish final   public
```

### 10.2 Release Types

| Type | Frequency | Content |
|------|-----------|---------|
| Major | Annual | Breaking changes |
| Minor | Monthly | New features |
| Patch | Weekly | Urgent fixes |
| RC | Pre-release | Final testing |
| Beta | Pre-release | Wide testing |

### 10.3 Branch Structure

```
main
├── develop
│   ├── feature/docker-skill
│   ├── feature/kubernetes-skill
│   └── feature/ci-cd-skill
├── release/v1.0.0
└── hotfix/fix-bootstrap
```

### 10.4 Branch Naming

| Type | Format | Example |
|------|---------|---------|
| Feature | feature/<name> | feature/docker-skill |
| Bugfix | bugfix/<name> | bugfix/fix-bootstrap |
| Hotfix | hotfix/<name> | hotfix/fix-security |
| Release | release/<version> | release/v1.0.0 |
| Docs | docs/<name> | docs/update-readme |

### 10.5 Daily Workflow

```
1. Pull develop
2. Create feature branch
3. Implement feature
4. Test locally
5. Commit changes
6. Push to origin
7. Create PR
8. Wait for review
9. Merge to develop
10. Delete branch
```

### 10.6 Code Review Flow

```
1. Create PR
2. Fill PR template
3. Add reviewers
4. Wait for CI to pass
5. Receive feedback
6. Implement changes
7. Push changes
8. Wait for approval
9. Merge
```

### 10.7 Release Flow

```
1. Update CHANGELOG
2. Update version
3. Create release branch
4. Test RC
5. Approve release
6. Merge to main
7. Create tag
8. Publish release
9. Merge to develop
```

### 10.8 Useful Commands

```bash
# Update develop
git checkout develop
git pull origin develop

# Create feature
git checkout -b feature/my-skill develop

# Commit
git add .
git commit -m "feat: add my-skill"

# Push
git push origin feature/my-skill

# Create PR
gh pr create --base develop --head feature/my-skill

# Merge PR
gh pr merge <pr-number> --squash

# Delete branch
git branch -d feature/my-skill
git push origin --delete feature/my-skill
```

### 10.9 Automation

| Process | Automation | Tool |
|---------|------------|------|
| Linting | Automatic | GitHub Actions |
| Testing | Automatic | GitHub Actions |
| Build | Automatic | GitHub Actions |
| Deploy | Semi-automatic | GitHub Actions + Manual |
| Release | Semi-automatic | Script + Manual |

---

## 11. Quality Criteria

### 11.1 Skill Quality

| Criterion | Metric | Minimum |
|-----------|--------|---------|
| Completeness | All fields filled | 100% |
| Clarity | Instructions understandable | 90% |
| Examples | At least 1 example | 1 |
| References | At least 1 reference | 1 |
| Size | Up to 500 lines | ≤500 |
| Testing | Tested locally | Yes |
| User Value | Solves a real problem | Yes |

### 11.2 Agent Quality

| Criterion | Metric | Minimum |
|-----------|--------|---------|
| Persona | Clear and distinct | Yes |
| Skills | Documented | 3+ |
| Examples | At least 1 | 1 |
| References | Related skills | 1+ |
| Size | Up to 200 lines | ≤200 |

### 11.3 Documentation Quality

| Criterion | Metric | Minimum |
|-----------|--------|---------|
| Coverage | All components documented | 100% |
| Clarity | Easy to understand | 90% |
| Examples | At least 1 per section | 1 |
| Links | All links valid | 100% |
| Updates | Synced with code | 100% |

### 11.4 Code Quality

| Criterion | Metric | Minimum |
|-----------|--------|---------|
| Style | Follows style guide | 100% |
| Functions | Small functions | ≤50 lines |
| Names | Descriptive | 100% |
| Comments | Only necessary | Minimum |
| Tests | Adequate coverage | 80% |

### 11.5 Code Review Checklist

- [ ] Code meets requirements
- [ ] Code is readable and understandable
- [ ] No duplicated code
- [ ] Functions are cohesive and small
- [ ] Names are descriptive
- [ ] Error handling is adequate
- [ ] No hardcoded secrets
- [ ] Tests are present
- [ ] Documentation is updated
- [ ] Performance is adequate

### 11.6 Review Comment Types

| Type | Priority | Example |
|------|----------|---------|
| Blocker | Critical | "This causes production bug" |
| Major | High | "Should use pattern X" |
| Minor | Medium | "Could rename to Y" |
| Nit | Low | "Style: extra space" |
| Suggestion | Low | "Suggestion: use Z" |

---

## 12. Testing

### 12.1 Test Types

| Type | Objective | Tool |
|------|-----------|------|
| Unit | Test isolated components | Bash scripts |
| Integration | Test interactions | Bash scripts |
| Validation | Verify format | Linting tools |
| Manual | Verify usage | Human |

### 12.2 Test Structure

```
tests/
├── skills/           # Skill tests
│   ├── test-skill-format.sh
│   └── test-skill-content.sh
├── agents/           # Agent tests
│   ├── test-agent-format.sh
│   └── test-agent-content.sh
├── templates/        # Template tests
│   ├── test-template-format.sh
│   └── test-template-content.sh
├── scripts/          # Script tests
│   ├── test-bootstrap.sh
│   └── test-install.sh
└── integration/      # Integration tests
    ├── test-full-setup.sh
    └── test-cross-platform.sh
```

### 12.3 Example Test

```bash
#!/bin/bash
# tests/skills/test-skill-format.sh

set -euo pipefail

SKILLS_DIR="skills"
ERRORS=0

echo "=== Testing Skill Format ==="

for skill_dir in "$SKILLS_DIR"/*/; do
    skill_file="$skill_dir/SKILL.md"
    
    if [[ ! -f "$skill_file" ]]; then
        echo "ERROR: $skill_file not found"
        ((ERRORS++))
        continue
    fi
    
    # Check frontmatter
    if ! head -1 "$skill_file" | grep -q "^---"; then
        echo "ERROR: $skill_file missing frontmatter"
        ((ERRORS++))
    fi
    
    # Check name
    if ! grep -q "^name:" "$skill_file"; then
        echo "ERROR: $skill_file missing name field"
        ((ERRORS++))
    fi
    
    # Check size
    lines=$(wc -l < "$skill_file")
    if (( lines > 500 )); then
        echo "ERROR: $skill_file exceeds 500 lines ($lines)"
        ((ERRORS++))
    fi
    
    echo "OK: $skill_file"
done

if (( ERRORS > 0 )); then
    echo "=== $ERRORS errors found ==="
    exit 1
fi

echo "=== All tests passed ==="
exit 0
```

### 12.4 Running Tests

```bash
# Run all tests
./scripts/test.sh

# Run specific tests
./tests/skills/test-skill-format.sh

# Run with verbose
bash -x ./scripts/test.sh
```

### 12.5 Pass Criteria

| Criterion | Minimum |
|-----------|---------|
| All unit tests | 100% |
| Code coverage | 80% |
| No linting errors | 100% |
| Complete documentation | 100% |
| Functional examples | 100% |

---

## 13. Security

### 13.1 Security Principles

1. **Never expose secrets** — API keys, tokens, and passwords must never be committed
2. **Least privilege** — Minimum necessary access
3. **Defense in depth** — Multiple layers of protection
4. **Security by design** — Consider security from the start

### 13.2 Security Rules

| Rule | Priority | Consequence |
|------|----------|-------------|
| No hardcoded secrets | Critical | Immediate rejection |
| Input validation | High | Mandatory review |
| Output sanitization | High | Mandatory review |
| Environment variables | High | Mandatory review |
| Vulnerability documentation | Medium | Review required |

### 13.3 What NEVER to Commit

```bash
# ❌ NEVER DO THIS

# API keys
API_KEY=sk-1234567890

# Passwords
DATABASE_PASSWORD=mysecretpassword

# Tokens
GITHUB_TOKEN=ghp_1234567890

# Certificates
*.pem
*.key

# Sensitive files
.env
.env.local
.env.production
```

### 13.4 .gitignore

```gitignore
# Secrets
.env
.env.*
*.pem
*.key

# Dependencies
node_modules/
venv/
__pycache__/

# Build
dist/
build/
*.log

# IDE
.vscode/
.idea/
*.swp
```

### 13.5 Security Audit

| Area | Frequency | Responsible |
|------|-----------|-------------|
| Dependencies | Weekly | Automated |
| Code | Per PR | Reviewers |
| Configuration | Monthly | Team |
| Logs | Continuous | Monitoring |

### 13.6 Vulnerability Response

```
1. Identify vulnerability
2. Assess severity
3. Create fix
4. Test fix
5. Publish hotfix
6. Notify users
7. Document lesson
```

---

## 14. Compatibility

### 14.1 Supported Platforms

| Platform | Min Version | Status | Notes |
|----------|-------------|--------|-------|
| OpenCode | Latest | ✅ Primary | Native format |
| Claude Code | Latest | ✅ Compatible | Via CLAUDE.md |
| Cursor | Latest | ✅ Compatible | Via .cursor/rules/ |
| GitHub Copilot | Latest | ⚠️ Partial | Via instructions |
| Windsurf | Latest | ⚠️ Partial | Test |

### 14.2 File Formats

| Format | OpenCode | Claude Code | Cursor | Copilot |
|--------|----------|-------------|--------|---------|
| .md | ✅ | ✅ | ✅ | ✅ |
| .mdc | ❌ | ❌ | ✅ | ❌ |
| .yaml | ✅ | ⚠️ | ⚠️ | ❌ |
| .json | ✅ | ⚠️ | ⚠️ | ⚠️ |

### 14.3 Component Mapping

| OpenCode | Claude Code | Cursor | Copilot |
|----------|-------------|--------|---------|
| skills/ | CLAUDE.md | .cursor/rules/ | .github/copilot-instructions.md |
| agents/ | persona | .cursor/rules/ | instructions |
| prompts/ | prompt | .cursor/ | instructions |
| context/ | context | .cursor/rules/ | context |

**Note:** For Claude Code, skills are typically concatenated into a single CLAUDE.md file. For Cursor, they go into .cursor/rules/ directory.

### 14.4 Known Limitations

1. **Copilot:** Doesn't support complex skills
2. **Cursor:** .mdc format is proprietary
3. **Claude Code:** Requires specific CLAUDE.md format
4. **OpenCode:** Is the primary platform, others are secondary

---

## 15. Dependencies

### 15.1 External Dependencies

| Dependency | Version | Type | Required |
|------------|---------|------|----------|
| Git | 2.0+ | Tool | Yes |
| Bash | 4.0+ | Shell | Yes (Unix) |
| curl | Any | Tool | No |
| jq | 1.6+ | Tool | No |

### 15.2 Development Dependencies

| Dependency | Version | Use |
|------------|---------|-----|
| ShellCheck | Latest | Bash linting |
| markdownlint | Latest | Markdown linting |
| yamllint | Latest | YAML linting |

### 15.3 Dependency Management

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get install git bash curl jq

# Install dependencies (macOS)
brew install git bash curl jq

# Install dev dependencies
npm install -g markdownlint-cli
pip install yamllint
```

---

## 16. Licensing

### 16.1 Project License

MIT License — see [LICENSE](./LICENSE).

### 16.2 License Terms

```
MIT License

Copyright (c) 2026 OpenCode Engineering Kit Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### 16.3 Component Licenses

All components use MIT License:

| Component | License | Notes |
|-----------|---------|-------|
| Skills | MIT | Free to use |
| Agents | MIT | Free to use |
| Templates | MIT | Free to use |
| Prompts | MIT | Free to use |
| Documentation | MIT | Free to use |

### 16.4 Attribution

When using this project, please include:

```markdown
Based on OpenCode Engineering Kit (https://github.com/opencode-ai/opencode-engineering-kit)
Licensed under MIT License
```

---

## 17. Roadmap

### 17.1 Phase 1: Foundation (Months 1-2)

| Item | Status | Priority |
|------|--------|----------|
| Directory structure | ✅ Done | High |
| Bootstrap script | ✅ Done | High |
| README.md | ✅ Done | High |
| CONTRIBUTING.md | ✅ Done | High |
| LICENSE | ✅ Done | High |
| PROJECT_SPEC.md | ✅ Done | High |
| GitHub Actions CI | 🔄 In Progress | High |

### 17.2 Phase 2: Core Skills (Months 2-4)

| Item | Status | Priority |
|------|--------|----------|
| docker-best-practices | ⏳ Pending | High |
| kubernetes-deployment | ⏳ Pending | High |
| ci-cd-pipeline | ⏳ Pending | High |
| code-review-checklist | ⏳ Pending | High |
| python-testing | ⏳ Pending | High |
| javascript-testing | ⏳ Pending | High |
| git-workflow | ⏳ Pending | Medium |
| api-design | ⏳ Pending | Medium |

### 17.3 Phase 3: Agents (Months 3-5)

| Item | Status | Priority |
|------|--------|----------|
| devops-engineer | ⏳ Pending | High |
| frontend-developer | ⏳ Pending | High |
| backend-developer | ⏳ Pending | High |
| fullstack-developer | ⏳ Pending | Medium |
| mobile-developer | ⏳ Pending | Medium |
| security-engineer | ⏳ Pending | Medium |

### 17.4 Phase 4: Templates and Prompts (Months 4-6)

| Item | Status | Priority |
|------|--------|----------|
| new-project template | ⏳ Pending | High |
| opencode-config template | ⏳ Pending | High |
| skill template | ⏳ Pending | Medium |
| code-review prompts | ⏳ Pending | Medium |
| debugging prompts | ⏳ Pending | Medium |

### 17.5 Phase 5: Expansion (Months 6-12)

| Item | Status | Priority |
|------|--------|----------|
| More skills (50+) | ⏳ Pending | Medium |
| More agents (20+) | ⏳ Pending | Medium |
| More templates (30+) | ⏳ Pending | Medium |
| CI/CD integration | ⏳ Pending | Low |
| Advanced documentation | ⏳ Pending | Low |

### 17.6 Milestones

| Milestone | Target Date | Description |
|-----------|-------------|-------------|
| v0.1.0 | Month 2 | Structure and bootstrap |
| v0.2.0 | Month 4 | Core skills and agents |
| v0.3.0 | Month 6 | Templates and prompts |
| v1.0.0 | Month 12 | Stable release |

---

## 18. Glossary

### 18.1 Project Terms

| Term | Definition |
|------|------------|
| **Skill** | A guide for executing a specific task |
| **Agent** | A persona configured for a specific role |
| **Template** | A model for creating new components |
| **Prompt** | Instructions designed to guide AI |
| **Command** | Documentation of an OpenCode command |
| **Context** | Files providing project context for AI |
| **Frontmatter** | YAML metadata at the start of markdown files |
| **Kebab-case** | Naming format with hyphens (ex: my-skill) |
| **Snake_case** | Naming format with underscores (ex: my_skill) |
| **PascalCase** | Naming format with capitalized initials (ex: MySkill) |
| **CamelCase** | Naming format with lowercase initial (ex: mySkill) |
| **Semver** | Semantic versioning (MAJOR.MINOR.PATCH) |
| **Conventional Commits** | Commit message pattern |

### 18.2 Technical Terms

| Term | Definition |
|------|------------|
| **LLM** | Large Language Model |
| **AI** | Artificial Intelligence |
| **CI/CD** | Continuous Integration / Continuous Deployment |
| **PR** | Pull Request |
| **CR** | Code Review |
| **SRE** | Site Reliability Engineer |
| **DevOps** | Development Operations |
| **MLOps** | Machine Learning Operations |
| **OWASP** | Open Web Application Security Project |
| **REST** | Representational State Transfer |
| **gRPC** | Google Remote Procedure Call |
| **API** | Application Programming Interface |

### 18.3 Tools

| Tool | Use | Link |
|------|-----|------|
| OpenCode | IDE/AI assistant | opencode.ai |
| Claude Code | AI coding tool | anthropic.com |
| Cursor | AI-powered IDE | cursor.sh |
| GitHub Copilot | AI pair programmer | github.com/features/copilot |
| ShellCheck | Bash linting | shellcheck.net |
| markdownlint | Markdown linting | github.com/igorshubovych/markdownlint-cli |
| yamllint | YAML linting | yamllint.readthedocs.io |

### 18.4 References

| Reference | Description | Link |
|-----------|-------------|------|
| OpenCode Docs | Official documentation | docs.opencode.ai |
| Open Agent Skills Specification | Skills specification | github.com/open-agent-skills |
| Shokunin | 62 skills for AI | github.com/hirefrank/shokunin |
| The Hive Skill | 79 skills for AI | github.com/beingaivanshoo/the-hive-skill |
| Conventional Commits | Commit pattern | conventionalcommits.org |
| Semantic Versioning | Versioning | semver.org |
| MIT License | Project license | opens