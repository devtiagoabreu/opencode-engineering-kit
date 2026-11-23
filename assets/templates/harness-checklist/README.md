---
maturity: beta
name: {{harness_name}}
description: {{what_this_harness_does}}
version: {{version}}
author: {{author}}
category: project
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
---

# {{harness_name}} — Harness Review

## Usage

Copy this file to `{{target_path}}`, replace every `{{placeholder}}`, and review it before handoff. A reviewer should be able to answer each item with evidence, not an opinion.

## Scope

- Goal: {{goal}}
- Out of scope: {{out_of_scope}}
- Owner: {{owner}}
- Review date: {{review_date}}

## Instructions

- [ ] The core instruction file is `{{instruction_file}}` and fits in {{instruction_budget}} tokens.
- [ ] Pinned rules are limited to {{pinned_rules}}.
- [ ] Each rule has an owner and a removal condition.

## Tools

| Tool | Class | Scope | Approval |
|---|---|---|---|
| {{tool_1}} | {{allowed/restricted/denied}} | {{scope_1}} | {{approval_1}} |
| {{tool_2}} | {{allowed/restricted/denied}} | {{scope_2}} | {{approval_2}} |

## Context

- [ ] Delivery mode for each fact: {{pin/retrieve/page/compact/isolate}}
- [ ] Hard read cap: {{read_cap}}
- [ ] Source recorded for each important fact: {{source_rule}}

## Verification gates

| Gate | Command | Evidence | Owner |
|---|---|---|---|
| {{gate_1}} | {{command_1}} | {{evidence_1}} | {{owner_1}} |
| {{gate_2}} | {{command_2}} | {{evidence_2}} | {{owner_2}} |

## Evals

- [ ] Deterministic checks cover {{deterministic_scope}}.
- [ ] Trace assertions cover permission decisions and budget limits.
- [ ] Model judges, if any, are limited to {{judge_scope}}.
- [ ] Capability and regression evals are separate.

## Observability

- [ ] Tool calls are logged with scope and decision.
- [ ] Stop and resume leave a recoverable checkpoint.
- [ ] Budget counters exist for loops, time and spend.

## Deletion candidates

- {{candidate_1}}
- {{candidate_2}}

## Sign-off

- [ ] All gates pass.
- [ ] Remaining risks are listed: {{remaining_risks}}
- [ ] Approved by: {{approver}}
