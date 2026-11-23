---
maturity: beta
name: {{retrieval_name}}
description: {{what_was_retrieved_and_why}}
version: {{version}}
author: {{author}}
category: project
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
---

# {{retrieval_name}} — Retrieval Ledger

## Usage

Fill this ledger while running `scientific-data-retrieval`. Attach it to the final answer so another person can repeat the lookup and see its limits.

## Retrieval contract

| Field | Value |
|---|---|
| Entity | {{entity}} |
| Identifiers | {{identifiers}} |
| Constraints | {{constraints}} |
| Server-side filters | {{server_filters}} |
| Local filters | {{local_filters}} |
| Required output | {{output_fields}} |
| Scope | {{targeted_or_exhaustive}} |
| Confirmation threshold | {{threshold}} |

## Sources

| Source | Why authoritative | Access mode |
|---|---|---|
| {{source_1}} | {{reason_1}} | {{public/registered/licensed}} |
| {{source_2}} | {{reason_2}} | {{public/registered/licensed}} |

## Calls

| Endpoint | Parameters | Date | Pages/batches |
|---|---|---|---|
| {{endpoint_1}} | {{params_1}} | {{date_1}} | {{pages_1}} |
| {{endpoint_2}} | {{params_2}} | {{date_2}} | {{pages_2}} |

## Count reconciliation

- Expected total: {{expected_total}}
- Retrieved total: {{retrieved_total}}
- Local filters removed: {{filtered_count}}
- Final total: {{final_total}}
- Reason for any mismatch: {{mismatch_reason}}

## Identifier conversions

| From | To | Method | Verification |
|---|---|---|---|
| {{from_1}} | {{to_1}} | {{method_1}} | {{verification_1}} |

## Warnings

- {{warning_1}}
- {{warning_2}}

## Result

{{concise_result}}

Raw payload quoted: {{yes_or_no}}
Payload labeled as untrusted third-party data: {{yes_or_no}}
