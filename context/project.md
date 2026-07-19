---
name: project-context
description: General project context for OpenCode Engineering Kit
type: project
version: 1.0.0
author: OpenCode Community
---

# Project Context

## Overview

OpenCode Engineering Kit is an open source library providing Skills, Agents, Commands, Prompts, Templates, and Context for the OpenCode ecosystem.

## Objectives

1. Provide ready-to-use Skills for common tasks
2. Offer configured Agents for specific personas
3. Make Templates available for new projects
4. Create reusable Prompts
5. Maintain compatibility with OpenCode, Claude Code, and Cursor

## Tech Stack

- **Format:** Markdown + YAML
- **Scripts:** Bash
- **CI/CD:** GitHub Actions
- **Documentation:** Markdown
- **Version Control:** Git

## Conventions

- All files use kebab-case
- Skills follow SKILL.md format
- Agents are .md files
- Templates include {{variable}} variables
- Commits follow Conventional Commits

## Architectural Decisions

1. Skills in markdown format (AD-001)
2. Category organization (AD-002)
3. Agents as .md files (AD-003)
4. Context as separate files (AD-004)
5. Bash scripts (AD-005)

## Target Audience

- Developers using OpenCode
- Teams wanting to share configurations
- Contributors wanting to expand the ecosystem
- Users migrating from Claude Code or Cursor

## Project Values

- **Simplicity:** Simple markdown files
- **Compatibility:** Multiple AI platforms
- **Community:** Open source, contributions welcome
- **Quality:** Tests, review, documentation
- **Security:** No exposure of secrets