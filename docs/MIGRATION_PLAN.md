# Migration Plan

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Overview

This document describes the incremental migration from the current structure (v0.1.0) to the new architecture (v3.0). Each iteration is designed to keep the repository functional.

---

## Migration Principles

1. **No Big Bang** — Migrate incrementally
2. **Always Functional** — Repository works after each step
3. **Tested** — Run tests after each change
4. **Documented** — Update docs after each change
5. **Reversible** — Each step has a rollback strategy

---

## Phase 1: Foundation (v0.1.1)

### Iteration 1.1: Language Standardization

**Objective:** Translate all content to English

**Files to modify:**

- `skills/devops/docker-best-practices/SKILL.md`
- `skills/code-review/code-review-checklist/SKILL.md`
- `skills/testing/python-testing/SKILL.md`
- `skills/backend/api-design/SKILL.md`
- `agents/devops-engineer.md`
- `agents/backend-developer.md`
- `agents/frontend-developer.md`
- `prompts/code-review/code-review-checklist.md`
- `prompts/debugging/debug-analysis.md`
- `prompts/architecture/system-design.md`
- `commands/review.md`
- `commands/test.md`
- `commands/lint.md`
- `context/glossary.md`
- `context/documentation.md`
- `context/coding_rules.md`
- `context/performance.md`
- `templates/skill/SKILL.md`
- `templates/agent/agent.md`
- `templates/prompt/prompt.md`
- `templates/new-project/README.md`
- `scripts/create-docs.sh`
- `scripts/uninstall.sh`
- `scripts/update.sh`
- `CODE_OF_CONDUCT.md`

**Effort:** 4-6 hours  
**Risk:** Low  
**Rollback:** Git revert  
**Acceptance criteria:**

- All files in English
- Tests pass
- No Portuguese content remains

---

### Iteration 1.2: File Naming Fix

**Objective:** Rename files with underscores to kebab-case

**Files to rename:**

- `context/coding_rules.md` → `context/coding-rules.md`
- `context/style_guide.md` → `context/style-guide.md`

**Files to update:**

- All references to these files
- `scripts/bootstrap.sh`
- Tests

**Effort:** 1-2 hours  
**Risk:** Low  
**Rollback:** Git revert  
**Acceptance criteria:**

- Files renamed
- All references updated
- Tests pass

---

### Iteration 1.3: Version Alignment

**Objective:** Align all versions to 0.1.0

**Files to modify:**

- `agents/devops-engineer.md` (version: 1.0.0 → 0.1.0)
- `agents/backend-developer.md` (version: 1.0.0 → 0.1.0)
- `agents/frontend-developer.md` (version: 1.0.0 → 0.1.0)
- All SKILL.md files (version: 1.0.0 → 0.1.0)
- All prompt files (version: 1.0.0 → 0.1.0)

**Effort:** 30 minutes  
**Risk:** Low  
**Rollback:** Git revert  
**Acceptance criteria:**

- All components at version 0.1.0
- PROJECT_SPEC.md matches

---

### Iteration 1.4: Context Deduplication

**Objective:** Merge duplicated context files

**Current state:**

- `conventions.md` (144 lines)
- `naming.md` (115 lines)
- `style_guide.md` (180 lines)
- `coding_rules.md` (125 lines)

**Proposed state:**

- `conventions.md` (merged, ~200 lines)

**Effort:** 2-3 hours  
**Risk:** Medium  
**Rollback:** Git revert  
**Acceptance criteria:**

- Single conventions file
- No duplicated content
- All references updated
- Tests pass

---

### Iteration 1.5: Fix Broken References

**Objective:** Fix all broken cross-references

**Files to fix:**

- `agents/devops-engineer.md` (references non-existent skills)
- `prompts/code-review/code-review-checklist.md` (verify reference)

**Effort:** 1 hour  
**Risk:** Low  
**Rollback:** Git revert  
**Acceptance criteria:**

- All references point to existing files
- Cross-reference validator passes

---

### Iteration 1.6: Bootstrap Alignment

**Objective:** Fix bootstrap.sh to match actual structure

**Changes:**

- Update skill categories
- Update agent list
- Update template list
- Fix shebang to `#!/bin/bash`
- Add `set -euo pipefail`

**Effort:** 1-2 hours  
**Risk:** Low  
**Rollback:** Git revert  
**Acceptance criteria:**

- Bootstrap creates correct structure
- All tests pass

---

## Phase 2: Infrastructure (v0.2.0)

### Iteration 2.1: Create Core Directory

**Objective:** Create core/ directory structure

**Directories to create:**

- `core/registry/`
- `core/discovery/`
- `core/resolver/`
- `core/validator/`
- `core/version/`
- `core/plugin/`

**Effort:** 1 hour  
**Risk:** Low  
**Rollback:** Remove directory  
**Acceptance criteria:**

- Directory structure exists
- README in each directory

---

### Iteration 2.2: Create JSON Schemas

**Objective:** Define schemas for all asset types

**Files to create:**

- `core/registry/schema/skill.schema.json`
- `core/registry/schema/agent.schema.json`
- `core/registry/schema/prompt.schema.json`
- `core/registry/schema/template.schema.json`
- `core/registry/schema/command.schema.json`
- `core/registry/schema/playbook.schema.json`
- `core/registry/schema/recipe.schema.json`

**Effort:** 4-6 hours  
**Risk:** Medium  
**Rollback:** Remove files  
**Acceptance criteria:**

- All schemas valid JSON
- Schemas validate existing assets
- Documentation complete

---

### Iteration 2.3: Create Registry MVP

**Objective:** Implement basic registry system

**Files to create:**

- `core/registry/generate.sh`
- `core/registry/index/skills.json`
- `core/registry/index/agents.json`
- `core/registry/index/prompts.json`
- `core/registry/index/templates.json`
- `core/registry/index/commands.json`

**Effort:** 4-6 hours  
**Risk:** Medium  
**Rollback:** Remove files  
**Acceptance criteria:**

- Registry generates correct indexes
- Indexes contain all assets
- Indexes are valid JSON

---

### Iteration 2.4: Create Validator

**Objective:** Implement schema validation

**Files to create:**

- `core/validator/validate.sh`
- `core/validator/validate-all.sh`

**Effort:** 3-4 hours  
**Risk:** Medium  
**Rollback:** Remove files  
**Acceptance criteria:**

- Validator catches invalid frontmatter
- Validator catches missing required fields
- Validator runs in CI

---

### Iteration 2.5: Add Pre-commit Hooks

**Objective:** Add local validation before commit

**Files to create:**

- `tooling/hooks/pre-commit`
- `tooling/hooks/pre-push`

**Files to modify:**

- `CONTRIBUTING.md` (add hook installation instructions)

**Effort:** 2-3 hours  
**Risk:** Low  
**Rollback:** Remove files  
**Acceptance criteria:**

- Hooks run automatically
- Hooks catch common errors
- Documentation updated

---

### Iteration 2.6: Create Assets Directory

**Objective:** Move content to assets/ directory

**Directories to create:**

- `assets/skills/`
- `assets/agents/`
- `assets/prompts/`
- `assets/templates/`
- `assets/commands/`
- `assets/playbooks/`
- `assets/recipes/`

**Files to move:**

- `skills/` → `assets/skills/`
- `agents/` → `assets/agents/`
- `prompts/` → `assets/prompts/`
- `templates/` → `assets/templates/`
- `commands/` → `assets/commands/`

**Effort:** 2-3 hours  
**Risk:** High  
**Rollback:** Move files back  
**Acceptance criteria:**

- All files moved
- All references updated
- All tests pass
- CI passes

---

## Phase 3: Scale (v1.0.0)

### Iteration 3.1: Add 20 Skills

**Objective:** Create 20 new skills

**Categories to populate:**

- devops (5 skills)
- backend (5 skills)
- frontend (5 skills)
- testing (3 skills)
- security (2 skills)

**Effort:** 20-30 hours  
**Risk:** Medium  
**Rollback:** Remove files  
**Acceptance criteria:**

- All skills pass validation
- All skills have examples
- Documentation complete

---

### Iteration 3.2: Add 10 Agents

**Objective:** Create 10 new agents

**Agents to create:**

- fullstack-developer
- mobile-developer
- security-engineer
- qa-engineer
- data-engineer
- ml-engineer
- technical-writer
- product-manager
- ui-designer
- site-reliability-engineer

**Effort:** 10-15 hours  
**Risk:** Medium  
**Rollback:** Remove files  
**Acceptance criteria:**

- All agents pass validation
- All agents have examples
- Documentation complete

---

### Iteration 3.3: Add Discovery System

**Objective:** Implement search and filtering

**Files to create:**

- `core/discovery/search.sh`
- `core/discovery/filter.sh`
- `core/discovery/index.sh`

**Effort:** 6-8 hours  
**Risk:** Medium  
**Rollback:** Remove files  
**Acceptance criteria:**

- Search by category works
- Search by tags works
- Search by framework works
- Documentation complete

---

### Iteration 3.4: Add Dependency Resolution

**Objective:** Implement dependency management

**Files to create:**

- `core/resolver/resolve.sh`
- `core/resolver/graph.sh`
- `core/resolver/validate.sh`

**Effort:** 8-10 hours  
**Risk:** High  
**Rollback:** Remove files  
**Acceptance criteria:**

- Dependencies declared in metadata
- Dependencies resolved correctly
- Circular dependencies detected
- Documentation complete

---

### Iteration 3.5: Add Plugin System

**Objective:** Implement plugin architecture

**Files to create:**

- `core/plugin/loader.sh`
- `core/plugin/installer.sh`
- `core/plugin/uninstaller.sh`

**Directories to create:**

- `plugins/community/`
- `plugins/enterprise/`

**Effort:** 8-10 hours  
**Risk:** High  
**Rollback:** Remove files  
**Acceptance criteria:**

- External plugins loadable
- Plugin metadata validated
- Plugin conflicts detected
- Documentation complete

---

### Iteration 3.6: Add Marketplace Preparation

**Objective:** Prepare architecture for future marketplace

**Files to create:**

- `core/marketplace/README.md`
- `core/marketplace/install.sh`
- `core/marketplace/search.sh`

**Effort:** 4-6 hours  
**Risk:** Low  
**Rollback:** Remove files  
**Acceptance criteria:**

- Installation by name works
- Search by criteria works
- Version resolution works
- Documentation complete

---

## Effort Summary

| Phase | Iterations | Total Effort |
|-------|------------|--------------|
| Phase 1 | 6 | 10-15 hours |
| Phase 2 | 6 | 15-20 hours |
| Phase 3 | 6 | 55-75 hours |
| **Total** | **18** | **80-110 hours** |

---

## Risk Summary

| Phase | Risk Level | Mitigation |
|-------|------------|------------|
| Phase 1 | Low | Git revert |
| Phase 2 | Medium | Incremental, tested |
| Phase 3 | High | Feature flags, rollback |

---

## Success Criteria

| Metric | Before | After |
|--------|--------|-------|
| Architecture Score | 5/10 | 9/10 |
| Completeness | 15% | 80% |
| Consistency | 3/10 | 9/10 |
| Test Coverage | 40% | 90% |
| Documentation | 3/10 | 8/10 |
| Scalability | 4/10 | 9/10 |
