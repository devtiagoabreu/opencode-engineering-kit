---
maturity: beta
name: harness-review
description: Review an agent harness for tool permissions, context delivery, verification gates, evals, observability and deletion candidates.
version: 0.1.0
author: devtiagoabreu
tags: [harness, review, quality, agents]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
usage: /harness-review [path_or_component]
---

# /harness-review

## Usage

```text
/harness-review [path_or_component]
```

## Description

Runs a pre-ship review of an agent harness. Inspect instructions, tools, context delivery, permission classes, verification gates, eval coverage and observability. Produce a checklist with evidence and name at least one component that can be removed.

Use `harness-engineering-patterns` as the reference and the `harness-checklist` template for the output.

## Arguments

| Argument | Required | Description | Default |
|---|---|---|---|
| path_or_component | No | File, directory or harness component to review | Current project |

## Examples

```bash
/harness-review
/harness-review .opencode/
/harness-review plugins/my-harness
```

## Notes

- A gate that cannot run is a finding, not a pass.
- Every restricted tool must state its exact scope and approval rule.
- The review is incomplete without a deletion candidate and an owner for each remaining risk.
