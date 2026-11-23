---
provenance:
  source: Awesome Harness Engineering
  source_url: https://github.com/ai-boost/awesome-harness-engineering
  license: CC0-1.0
  verified: 2026-11-23
maturity: beta
name: harness-engineering-patterns
description: Design reliable AI agent harnesses with explicit permissions, verification gates, context delivery, evals and bounded orchestration.
category: architecture
version: 0.1.0
author: devtiagoabreu
tags: [harness, agents, permissions, evals, context, orchestration]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - an agent runtime that exposes tools and instructions
provides:
  - A concrete permission contract for agent tools
  - Verification gates that block premature completion
  - A layered eval strategy and bounded orchestration checklist
security:
  risk_level: none
  permissions: []
  audited: true
difficulty: advanced
---

# Harness Engineering Patterns

## Overview

A *harness* is the wrapper around a model: instructions, tools, context, permissions, verification and observability. Use this skill when designing or reviewing that wrapper, not for a one-off code edit.

The guiding rule is that reliability comes from explicit boundaries and evidence, not from hoping the model behaves. Every capability should have an owner, a boundary, a gate and a way to remove it later.

## Prerequisites

- An agent runtime where tools can be allowed, restricted or denied.
- A place to keep durable instructions (for example `AGENTS.md` or project context).
- Commands that can be run as verification gates.

## Usage Instructions

### 1. Write a tool-permission contract

Classify every tool before the agent can call it:

| Class | Meaning | Example |
|---|---|---|
| Allowed | Safe, reversible, no approval needed | Read files, list directories, run tests |
| Restricted | Ask first; include scope and reason | Network writes, package install, git push |
| Not allowed | Hard stop; no override in a prompt | Production deletes, unrelated secrets |

Escalation is a first-class outcome: when a tool is restricted, the agent states the exact action and waits. When a tool is denied, the agent stops and proposes a safer alternative.

### 2. Deliver context by navigation, not stuffing

Do not paste everything into the prompt. Choose one delivery mode per fact:

- **Pin** the few rules that always apply.
- **Retrieve** scoped evidence only when a task needs it.
- **Page** long material instead of loading it whole.
- **Compact** old sessions into summaries with stable IDs.
- **Isolate** speculative or untrusted material away from decisions.

Set hard read caps, record where each fact came from, and make eviction reversible by keeping a pointer to the original source.

### 3. Define verification gates

Every milestone ends with named checks, not a narrative claim. A gate has a command, an expected result and an evidence artifact.

```yaml
gates:
  - name: schemas
    command: python scripts/validate_assets.py --root .
    evidence: validator JSON report
  - name: tests
    command: npm test --prefix cli
    evidence: test output summary
```

Do not mark work complete while a gate is red. If a gate cannot run, report that explicitly instead of treating silence as success.

### 4. Build an eval ladder

Use the cheapest reliable check first:

1. Deterministic checks: schema, hashes, formatting, link resolution.
2. Trace assertions: tool order, permission decisions, budget limits.
3. Task outcome checks: does the final artifact satisfy the request?
4. Rubric or model judges: only where human judgment is genuinely needed.

Separate capability evals (can the harness do this at all?) from regression evals (did a change break it?). Repeat trials for nondeterministic paths and publish variance, not a single lucky run.

### 5. Bound orchestration

For multi-agent or long-running work, put the workflow in versioned code or YAML. Give each handoff a typed payload, an owner and an audit entry. Add loop, time and spend caps; a stopped agent should leave a resumable plan, not a mystery.

### 6. Review for deletion

Before handoff, ask what can be removed: an unused tool, a duplicated rule, a stale summary, a gate that never fails. A smaller harness is usually more reliable than a larger one.

## Examples

### Example 1: Minimal permission block

```markdown
## Tool permissions

Allowed: read files, search local code, run unit tests.
Restricted: install packages, write outside the workspace, call external APIs.
Not allowed: delete production data, change unrelated repositories.
```

### Example 2: Completion contract

```text
A task is done only when:
- the requested artifact exists,
- every declared gate passed,
- unresolved assumptions are listed,
- the next safe action is named.
```

## References

- [Awesome Harness Engineering](https://github.com/ai-boost/awesome-harness-engineering)
- [Agent craft resources](https://agentcraft.dev/)
- Kit policy: `docs/QUALITY_POLICY.md`
