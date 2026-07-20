# Architecture Evolution v3.0

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Executive Summary

The OpenCode Engineering Kit must evolve from a collection of markdown files into a **world-class Engineering Platform** capable of supporting thousands of reusable AI assets. This document proposes the architectural evolution required to achieve that goal.

**Current State:** v0.1.0 — Early scaffolding (~15% complete)
**Target State:** v3.0.0 — Production-ready Engineering Platform

---

## Current Architecture Assessment

### Strengths

- Clear component taxonomy (Skills, Agents, Prompts, Templates, Commands, Context)
- Well-defined SKILL.md format with YAML frontmatter
- Multi-platform compatibility strategy
- Thorough PROJECT_SPEC.md (1632 lines)

### Weaknesses

- No separation between core infrastructure and content
- No registry or discovery system
- No dependency management
- No plugin architecture
- Massive content duplication
- Bilingual chaos (Portuguese/English mix)
- No automated quality gates
- No marketplace preparation

---

## Proposed Architecture Principles

### 1. Separation of Concerns

Core infrastructure must be clearly separated from content assets.

### 2. Registry-First Design

Every asset must be registered, discoverable, and versioned.

### 3. Dependency Awareness

Assets must declare dependencies. The system must resolve them.

### 4. Plugin Ready

External packages must be installable without modifying core.

### 5. Marketplace Prepared

Architecture must support future asset marketplace.

### 6. Schema Validated

All assets must conform to published schemas.

### 7. API Driven

All operations must be scriptable and automatable.

---

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    OpenCode Engineering Kit                  │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    CORE LAYER                       │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐           │   │
│  │  │ Registry │ │ Discovery│ │ Resolver │           │   │
│  │  └──────────┘ └──────────┘ └──────────┘           │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐           │   │
│  │  │ Schema   │ │ Version  │ │ Plugin   │           │   │
│  │  │ Validator│ │ Manager  │ │ Loader   │           │   │
│  │  └──────────┘ └──────────┘ └──────────┘           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                   ASSET LAYER                       │   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐      │   │
│  │  │ Skills │ │ Agents │ │Prompts │ │Templates│     │   │
│  │  └────────┘ └────────┘ └────────┘ └────────┘      │   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐      │   │
│  │  │Commands│ │Playbooks│ │Recipes│ │Examples│      │   │
│  │  └────────┘ └────────┘ └────────┘ └────────┘      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  TOOLING LAYER                      │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐           │   │
│  │  │Installer │ │ Updater  │ │ Migrator │           │   │
│  │  └──────────┘ └──────────┘ └──────────┘           │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐           │   │
│  │  │Validator │ │Generator │ │ Tester   │           │   │
│  │  └──────────┘ └──────────┘ └──────────┘           │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## Component Responsibilities

### Core Layer

| Component | Responsibility |
|-----------|---------------|
| Registry | Maintains index of all assets with metadata |
| Discovery | Enables search by category, tags, framework, etc. |
| Resolver | Resolves dependencies between assets |
| Schema Validator | Validates assets against published schemas |
| Version Manager | Manages semantic versioning for all assets |
| Plugin Loader | Loads external packages from community/enterprise |

### Asset Layer

| Component | Responsibility |
|-----------|---------------|
| Skills | Reusable instructions for AI coding tasks |
| Agents | Persona definitions for specialized AI roles |
| Prompts | Reusable prompt templates |
| Templates | Project and component templates |
| Commands | Custom commands for AI assistants |
| Playbooks | Multi-step workflows combining assets |
| Recipes | Complete solutions for specific use cases |
| Examples | Working code examples |

### Tooling Layer

| Component | Responsibility |
|-----------|---------------|
| Installer | Installs assets and dependencies |
| Updater | Updates assets to latest versions |
| Migrator | Migrates between schema versions |
| Validator | Validates assets and configurations |
| Generator | Generates indexes, catalogs, documentation |
| Tester | Runs tests and quality checks |

---

## Data Flow

```
User Request
    │
    ▼
┌─────────────┐
│  Discovery  │ ──► Search assets by criteria
└─────────────┘
    │
    ▼
┌─────────────┐
│  Registry   │ ──► Find matching assets
└─────────────┘
    │
    ▼
┌─────────────┐
│  Resolver   │ ──► Resolve dependencies
└─────────────┘
    │
    ▼
┌─────────────┐
│  Validator  │ ──► Validate all assets
└─────────────┘
    │
    ▼
┌─────────────┐
│  Installer  │ ──► Install assets
└─────────────┘
    │
    ▼
  Ready to Use
```

---

## Migration Strategy

The migration will be incremental, following these phases:

### Phase 1: Foundation (v0.2.0)

- Standardize language to English
- Fix all broken references
- Deduplicate context files
- Add schema validation
- Create registry MVP

### Phase 2: Infrastructure (v0.3.0)

- Implement discovery system
- Add dependency management
- Create plugin architecture
- Add pre-commit hooks
- Populate documentation

### Phase 3: Scale (v1.0.0)

- Implement marketplace preparation
- Add 50+ skills
- Add 20+ agents
- Complete automation
- Enterprise features

---

## Success Criteria

| Metric | Current | Target |
|--------|---------|--------|
| Architecture Score | 5/10 | 9/10 |
| Completeness | 15% | 80% |
| Consistency | 3/10 | 9/10 |
| Test Coverage | 40% | 90% |
| Documentation | 3/10 | 8/10 |
| Scalability | 4/10 | 9/10 |

---

## Next Steps

1. Review this proposal with stakeholders
2. Approve or modify architecture
3. Create detailed specifications for each component
4. Begin Phase 1 migration
