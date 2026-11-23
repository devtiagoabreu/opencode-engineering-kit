---
maturity: beta
name: {{meter_name}}
description: {{what_usage_is_billed_and_for_which_product}}
version: {{version}}
author: {{author}}
category: project
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
---

# {{meter_name}} — Meter Specification

## Usage

Fill this before a pricing change reaches production. It forces the event contract, aggregation and reconciliation rules into one reviewable place.

## Event contract

| Field | Value |
|---|---|
| Event name | {{event_name}} |
| Occurs when | {{occurrence_condition}} |
| Customer key | {{external_customer_id}} |
| Quantity field | {{quantity_field}} |
| Quantity unit | {{unit}} |
| Cost metadata | {{cost_field_or_none}} |
| Forbidden fields | {{forbidden_properties}} |

## Meter

| Setting | Value |
|---|---|
| Filter | {{filter_expression}} |
| Aggregation | {{count/sum/average/min/max}} |
| Period | {{billing_period}} |
| Separate meter cycle | {{yes_or_no}} |
| Cap | {{cap_or_none}} |
| Credits granted | {{credit_units_or_none}} |

## Pricing

| Dimension | Model | Tiers |
|---|---|---|
| Base | {{fixed/free/pay_what_you_want}} | {{base_amount}} |
| {{meter_name}} | {{unit/volume/graduated}} | {{tiers}} |

Worked example: {{units}} units produce a charge of {{expected_charge}} because {{calculation}}.

## Idempotency and reconciliation

- Idempotency key: {{key_source}}
- Duplicate policy: {{drop_or_overwrite}}
- Expected events per period: {{expected_count}}
- Accepted events per period: {{accepted_count}}
- Reconciliation owner: {{owner}}
- Webhook verification: {{method}}
- Replay procedure: {{replay_steps}}

## Customer communication

- Meter visible in portal: {{yes_or_no}}
- Cap disclosed: {{yes_or_no}}
- Price change grandfathered: {{yes_or_no}}
- Support runbook: {{support_doc}}

## Sign-off

- Finance owner: {{finance_approver}}
- Engineering owner: {{engineering_approver}}
- Effective date: {{effective_date}}
