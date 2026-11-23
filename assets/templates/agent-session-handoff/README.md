---
maturity: beta
name: {{session_name}}
description: {{one_line_summary_of_work_in_progress}}
version: {{version}}
author: {{author}}
category: project
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
---

# {{session_name}} — Session Handoff

## Usage

Use this template when work must continue in another session or agent. Keep it short enough to be read fully; link to transcripts instead of pasting them.

## State

- Goal: {{goal}}
- Status: {{not_started/in_progress/blocked/done}}
- Last verified gate: {{gate_name}} — {{pass_or_fail}}
- Next safe action: {{next_action}}

## Decisions

| Decision | Reason | Source | Supersedes |
|---|---|---|---|
| {{decision_1}} | {{reason_1}} | {{source_1}} | {{supersedes_1}} |
| {{decision_2}} | {{reason_2}} | {{source_2}} | {{supersedes_2}} |

## Corrections learned

- {{correction_1}}
- {{correction_2}}

## Constraints and permissions

- Allowed: {{allowed_actions}}
- Ask first: {{restricted_actions}}
- Not allowed: {{denied_actions}}

## Open questions

- {{question_1}}
- {{question_2}}

## Artifacts

| Artifact | Location | Checksum or version |
|---|---|---|
| {{artifact_1}} | {{path_1}} | {{checksum_1}} |
| {{artifact_2}} | {{path_2}} | {{checksum_2}} |

## Memory candidates

Only promote a candidate after it is confirmed; do not copy the whole transcript into memory.

- {{candidate_fact_1}}
- {{candidate_fact_2}}

## Privacy review

- Private blocks marked: {{yes_or_no}}
- Sensitive values removed: {{yes_or_no}}
- Shared scope approved: {{yes_or_no}}
