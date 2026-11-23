---
provenance:
  source: Polar
  source_url: https://github.com/polarsource/polar
  license: Apache-2.0
  verified: 2026-11-23
maturity: beta
name: usage-based-billing
description: Model metered billing as events, meters and prices with credits, subscription state, idempotency and per-customer margin visibility.
category: finance
version: 0.1.0
author: devtiagoabreu
tags: [billing, metering, subscriptions, pricing, webhooks, unit-economics]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - an event source for billable usage
  - a billing provider or an equivalent ledger
provides:
  - An event-to-invoice data model
  - Pricing model selection rules
  - Reconciliation and idempotency gates
security:
  risk_level: low
  permissions:
    - network
  audited: true
difficulty: advanced
---

# Usage-Based Billing

## Overview

Metered billing works when usage events are immutable facts and money is derived from them. Keep three layers separate: events (what happened), meters (how events become a number), and prices (how that number becomes a charge).

This separation lets you change pricing without rewriting instrumentation, and audit an invoice back to the originating events.

## Prerequisites

- A stable customer identifier you control.
- A defined unit for each billable dimension (tokens, seconds, calls, bytes).
- A webhook receiver with signature verification.

## Usage Instructions

### 1. Instrument events at the point of work

```json
{
  "name": "llm.completion",
  "external_customer_id": "cus_4410",
  "metadata": { "model": "claude-sonnet", "tokens": 1840 }
}
```

Include the quantity as a number, never a formatted string. Add cost as separate metadata when you want margin visibility. Do not put secrets, prompts or personal data in event metadata.

### 2. Define meters with a filter and an aggregation

| Aggregation | Meaning |
|---|---|
| count | Number of matching events |
| sum | Total of a numeric field |
| average | Mean of a numeric field |
| min / max | Extreme value in the period |

One event stream can feed several meters. Name meters after the business dimension, not the implementation detail.

### 3. Choose a pricing model deliberately

- **Unit:** fixed rate per unit; simple and predictable.
- **Volume:** one rate for all units based on total; rewards large customers.
- **Graduated:** each tier has its own rate; rewards incremental usage.

Compute a worked example at two volumes before publishing a price. A cap should be explicit in the UI.

### 4. Compose products instead of forking them

A subscription product can combine a base fee, prepaid credits and one or more metered prices. Credits draw down first, then overage is billed. Fixed price changes are typically grandfathered; billing interval and pricing type are structural and usually need a new product.

### 5. Make ingestion idempotent

Retries must not double-bill. Send a stable event or idempotency key, deduplicate at ingestion, and reconcile expected versus accepted counts at the end of each batch. Treat a successful HTTP response as acceptance, not as proof the meter counted it.

### 6. Handle the subscription lifecycle

Track checkout completion, renewal, `past_due`, recovery, plan change, seat change and cancellation. Entitlements follow active or trialing state. Webhooks should be verified, deduplicated by event ID, and replayable into an audit log.

### 7. Report margin, not only revenue

Attach inference cost to events and compute gross margin per customer. A negative-margin account is a product and pricing signal, not a billing bug.

## Examples

### Example 1: Worked price comparison

```text
1400 units, tiers: <=1000 at 0.10, >1000 at 0.08
Volume:    1400 x 0.08 = 112.00
Graduated: 1000 x 0.10 + 400 x 0.08 = 132.00
```

### Example 2: Reconciliation record

```yaml
batch: 2026-11-23-usage
events_sent: 18402
events_accepted: 18402
duplicates_dropped: 7
meter: llm_tokens
expected_units: 33812240
ingested_units: 33812240
webhooks_replayed: 2
```

## References

- [Polar](https://github.com/polarsource/polar)
- [Polar usage billing docs](https://polar.sh/docs/features/usage-based-billing)
- Kit companions: `saas-blueprint-patterns`, `privacy-first-analytics`
