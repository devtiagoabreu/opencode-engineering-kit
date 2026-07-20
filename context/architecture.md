---
name: architecture-context
description: Architecture context for OpenCode Engineering Kit
type: architecture
version: 0.1.0
author: OpenCode Community
---

# Architecture Context

## Overview

OpenCode Engineering Kit follows a modular architecture based on markdown components. Each component is independent and can be used alone or in combination.

## Architectural Principles

### 1. Simplicity

- Simple, readable markdown files
- No complex external dependencies
- Easy to understand and modify

### 2. Modularity

- Independent components
- Flexible composition
- Maximum reuse

### 3. Composition

- Skills combine agents, prompts, and templates
- Context can be used anywhere
- Commands orchestrate flows

### 4. Portability

- Works on any operating system
- No platform dependencies
- Standard format (markdown + YAML)

### 5. Extensibility

- Easy to add new components
- Template for each type
- Clear contribution process

## Components

```text
┌─────────────────────────────────────────────────┐
│                OpenCode Engineering Kit          │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐           │
│  │ Skills  │ │ Agents  │ │Prompts  │           │
│  └────┬────┘ └────┬────┘ └────┬────┘           │
│       │           │           │                 │
│  ┌────┴────┐ ┌────┴────┐ ┌────┴────┐           │
│  │Templates│ │Commands │ │Context  │           │
│  └─────────┘ └─────────┘ └─────────┘           │
└─────────────────────────────────────────────────┘
```

## Flows

### Installation Flow

```text
User → Clone Repo → Run bootstrap.sh →
Copy Skills/Agents/Prompts → Configure OpenCode →
Use resources
```

### Usage Flow

```text
User → OpenCode → Load Skills → Select Skill →
Execute Agent → Use Prompts → Apply Templates →
Generate Code → Review → Commit
```

### Contribution Flow

```text
Contributor → Fork → Feature Branch → Implement →
Test → Document → Submit PR → Code Review → Merge
```

## References

- [Decisions](./decisions.md) - Architecture Decision Records
- [Stack](./stack.md) - Tech stack details
- [Project](./project.md) - Project overview
