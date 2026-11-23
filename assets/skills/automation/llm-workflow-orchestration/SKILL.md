---
provenance:
  source: Dify
  source_url: https://github.com/langgenius/dify
  license: Dify Open Source License (Apache-2.0 with additional conditions; ideas only, no source vendored)
  verified: 2026-11-23
maturity: beta
name: llm-workflow-orchestration
description: Design explainable LLM workflows with typed nodes, human review points, failure branches, versioned definitions and traceable runs.
category: automation
version: 0.1.0
author: devtiagoabreu
tags: [workflow, orchestration, rag, human-in-the-loop, observability, agents]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - a workflow runtime or a versioned orchestration definition
provides:
  - A node taxonomy for LLM applications
  - Reliability and review-gate patterns
  - A RAG pipeline stage checklist
security:
  risk_level: low
  permissions:
    - filesystem
  audited: true
difficulty: advanced
---

# LLM Workflow Orchestration

## Overview

A model call is one node. Reliability comes from the graph around it: classification, retrieval, branching, tools, human review and typed failure paths. Keep that graph visible and versioned so a run can be explained after the fact.

## Prerequisites

- A way to describe the workflow as data (YAML/JSON or versioned code).
- A trace sink for node inputs, outputs and decisions.
- Defined ownership for each external tool.

## Usage Instructions

### 1. Use a small node vocabulary

| Group | Nodes |
|---|---|
| Start | user message, API call, schedule, webhook, upload |
| Reason | model call, classifier, field extraction, knowledge retrieval |
| Control | condition, iteration, loop, merge |
| Act | approved API, HTTP request, sandboxed code, tool |
| Review | human approval, edit, comment, timeout |

If a step does not fit, question the step before adding a new node type.

### 2. Put the handoffs in the definition

Record what each node receives, what it produces, and which branch it can take. Avoid hidden state passed between unrelated nodes. A reviewer should be able to follow the same path the run took.

### 3. Add review where the cost is real

Pause before actions that touch money, permissions, publishing or personal data. The review node must support approve, edit, reject and timeout. Timeouts should fail closed, not silently continue.

### 4. Design failure paths explicitly

LLM, HTTP, code and tool nodes should return typed error metadata. Choose per node whether to stop, return a default, or route to recovery. Never treat an empty model response as success without a check.

### 5. Treat the workflow definition as a release artifact

Version it, export or store a portable definition, and support restoring a published version. Moving a workflow between environments should be a promotion of the same definition, not a rebuild.

### 6. Trace to a real observability stack

Each run should expose node outputs, variables, path, latency, token usage and the originating request. Export traces to your existing tooling and keep a correlation ID in the user-facing result.

### 7. Build RAG as a pipeline, not a prompt

Stages: ingest, extract, clean, chunk, index, retrieve, rerank, test retrieval quality, then connect to the workflow. Evaluate retrieval before blaming the model.

### 8. Decouple integrations as plugins

Model providers, tools and data sources should be installable units with explicit contracts. If a plugin calls back into the platform, authenticate the callback and keep it stateless so any instance can serve it.

## Examples

### Example 1: Workflow skeleton

```yaml
start: support_message
nodes:
  - classify: intent
  - retrieve: knowledge_base, top_k=5
  - branch:
      if: confidence < 0.6
      then: human_review
      else: draft_reply
  - review: human_review, timeout=24h, default=escalate
  - act: send_reply, require_approval=true
trace: enabled
```

### Example 2: Failure contract

```yaml
node: http_order_lookup
on_timeout: route:recovery_queue
on_5xx: retry:2 then route:human_review
on_invalid_schema: stop with typed_error
```

## References

- [Dify](https://github.com/langgenius/dify)
- [Dify workflow concepts](https://docs.dify.ai/en/guides/workflow/README)
- Kit companions: `rag-llm`, `harness-engineering-patterns`, `n8n-workflow-automation`
