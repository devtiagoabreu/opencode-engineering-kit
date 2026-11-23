---
provenance:
  source: OpenViking
  source_url: https://github.com/volcengine/OpenViking
  license: AGPL-3.0 (ideas only; no source text or code vendored)
  verified: 2026-11-23
maturity: beta
name: context-filesystem-memory
description: Organize inspectable agent context as a virtual filesystem with layered summaries, scoped retrieval, durable rules and session commit workflows.
category: ai
version: 0.1.0
author: devtiagoabreu
tags: [memory, context, retrieval, filesystem, rules, sessions]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - a writable local directory or context API
provides:
  - A portable context URI and directory layout
  - Three-level summaries for cheap filtering before full reads
  - A scoped retrieval order and session commit ritual
security:
  risk_level: low
  permissions:
    - filesystem
  audited: true
difficulty: intermediate
---

# Context Filesystem Memory

## Overview

Treat everything an agent knows as an inspectable context tree instead of an opaque embedding store. Scopes are visible, addresses are stable, and every directory carries a short summary so an agent can decide whether to open it.

This skill describes a portable pattern. It does not require a specific database and does not copy the upstream implementation.

## Prerequisites

- A workspace directory where context can be stored, or an API that exposes equivalent paths.
- A convention for stable IDs that survives renames.
- Agreement on which material is private, shared or session-scoped.

## Usage Instructions

### 1. Use a stable context URI

Address context as `ctx://<scope>/<owner>/<slug>`. Keep a short alias such as `~` for the current project or user.

| Scope | Contains | Lifetime |
|---|---|---|
| `resources` | Documents, code extracts, external references | Until source changes |
| `memory` | Decisions, preferences, lessons | Long-lived, versioned |
| `skills` | Reusable procedures | Long-lived, reviewed |
| `rules` | Conditional obligations and prohibitions | Until superseded |
| `sessions` | Conversation archives and summaries | Archived after commit |

### 2. Write three summary levels

- **L0 abstract:** one sentence for filtering a directory listing.
- **L1 overview:** a short map of subtopics and how to navigate them.
- **L2 original:** the full content, opened only when needed.

An agent should read L0 for many directories, L1 for a few, and L2 for the one that matters.

```yaml
# SUMMARY.md
id: ctx://memory/team/api-conventions
l0: "Team decisions about API versioning and error envelopes."
l1: "Covers versioning, pagination and error codes; see sessions for origin."
updated: 2026-11-23
```

### 3. Retrieve in narrowing steps

1. Choose a scope; do not search the whole tree by default.
2. `find` by name or ID when the target is known.
3. `search` by meaning or keyword with a session-aware plan.
4. `grep` exact strings for identifiers.
5. Read L2 only after L0/L1 justify the cost.

Stop when the context budget is spent and report what remained unread.

### 4. Compile rules separately from memory

A rule is a durable conditional obligation: "when condition C holds, do or avoid action A." Give it priority over ordinary memory, a lifecycle state, and an explicit recall condition. Do not treat a preference as a rule just because it was remembered twice.

### 5. Commit sessions

A session has three phases: create, interact, commit. On commit, archive the transcript, write an L1 summary asynchronously, and extract only candidate memories. Never feed injected recall context back into capture; that creates echo chambers.

### 6. Apply boundaries and hygiene

Use typed principals and least-privilege scopes; filter access at retrieval time, not only at display time. Periodically dedupe, merge, split or compact entries while preserving their schemas and provenance.

## Examples

### Example 1: Directory layout

```text
context/
  resources/
    architecture/
      SUMMARY.md
      event-bus.md
  memory/
    project-alpha/
      SUMMARY.md
      decision-0042.md
  rules/
    approved/require-tests.md
  sessions/
    2026-11-23-alpha/
      transcript.md
      SUMMARY.md
```

### Example 2: Retrieval checklist

```text
Scope: memory/project-alpha
Need: why pagination was cursor-based
Order: SUMMARY.md -> decision-0042.md -> linked session summary
Budget: 800 tokens; stop after two L2 reads
```

## References

- [OpenViking](https://github.com/volcengine/OpenViking)
- [OpenViking concepts](https://github.com/volcengine/OpenViking/tree/main/docs/en/concepts)
- Kit memory companion: `session-memory`
