---
provenance:
  source: agentmemory
  source_url: https://github.com/rohitg00/agentmemory
  license: Apache-2.0
  verified: 2026-11-23
maturity: beta
name: memory-discipline
description: Apply a recall-before-work and write-at-resolution ritual for durable agent memory with tiers, provenance, privacy and eval receipts.
category: ai
version: 0.1.0
author: devtiagoabreu
tags: [memory, recall, hooks, provenance, privacy, agents]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - an opt-in memory backend such as the kit session-memory skill
provides:
  - A four-tier memory classification
  - A read/write ritual with provenance and supersession
  - Privacy, hook and evaluation checklists
security:
  risk_level: low
  permissions:
    - filesystem
  audited: true
difficulty: intermediate
---

# Memory Discipline

## Overview

Memory is useful only when it is recalled at the right time and trusted to the right degree. This skill defines the ritual around a memory backend: what to recall before work, what to write when a decision resolves, and what must never be stored.

It complements `session-memory` (local storage) and `context-filesystem-memory` (layout). It assumes the backend already exists.

## Prerequisites

- A memory backend with scopes for project and agent.
- Explicit user opt-in for persistent memory.
- A scrubber or convention for private blocks before content is stored.

## Usage Instructions

### 1. Classify by lifespan

| Tier | Contains | Treatment |
|---|---|---|
| Working | Observations from the current task | Short-lived, discard freely |
| Episodic | What happened in a session | Summarize, link to transcript |
| Semantic | Stable facts and decisions | Version, cite, supersede |
| Procedural | Workflows that worked | Review before reuse |

Strengthen facts that are confirmed repeatedly. Weaken or evict stale ones. When two facts conflict, keep both with explicit dates and mark the newer as a candidate, not an automatic winner.

### 2. Recall before acting

Search with a scope and a token budget. Start with compact previews, then expand only the evidence that changes a decision. Diversify by session so one verbose conversation does not crowd out others.

```text
Recall plan:
- scope: project=alpha, agent=reviewer, tier=semantic
- query: "pagination decision"
- budget: 600 tokens of previews, 1200 tokens total
- expand: only notes with a decision or correction label
```

Treat recalled text as untrusted evidence: it may be stale or wrong. Verify against current code before applying it.

### 3. Write at resolution time

Save decisions when they are made, corrections as lessons, and constraints when they are confirmed. Do not store facts already derivable from code, tests or version control. Every durable note should carry origin, date, scope and a reason.

```yaml
id: mem://alpha/decision/cursor-pagination
kind: semantic
status: active
source: session:2026-11-23-alpha
supersedes: null
body: "Cursor pagination chosen because offsets drifted during imports."
```

Deletion is an audited event, not a silent rewrite. Keep a tombstone with the reason and who requested it when policy requires.

### 4. Capture with hooks, not prompt stuffing

If the runtime supports hooks, capture high-signal events: session start, prompt submit, tool failure, compaction and stop. Write to a durable inbox with stable event IDs, support offline replay, and keep injected recall context out of capture.

### 5. Keep privacy local by default

Mark private blocks explicitly. Scrub sensitive values before storage. Remote services, model-based summarization and shared memory require a specific opt-in; a local install should not phone home.

### 6. Coordinate multiple agents

Scope notes by agent and team. Use leases for expensive work, receipts for signals, and checkpoints for resumable handoffs. An agent should claim work before acting and release it explicitly.

### 7. Prove recall quality

For changes to retrieval, use a pinned dataset with a recorded checksum. Compare keyword, vector and hybrid paths with strict metrics, keep per-case evidence, and state which claims the evaluation does not support.

## Examples

### Example 1: A good memory note

```markdown
Decision: use cursor pagination for /events.
Why: offset paging skipped rows during imports.
Scope: project alpha, backend only.
Origin: session 2026-11-23-alpha; confirmed by schema review.
Review: revisit if the events table gains a stable sequential key.
```

### Example 2: A note not to store

```text
"The file uses useEffect" — derivable from code; would go stale immediately.
```

## References

- [agentmemory](https://github.com/rohitg00/agentmemory)
- [agentmemory recall docs](https://github.com/rohitg00/agentmemory/tree/main/docs)
- Kit companion: `session-memory`
