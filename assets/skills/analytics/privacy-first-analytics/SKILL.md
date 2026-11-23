---
provenance:
  source: Umami
  source_url: https://github.com/umami-software/umami
  license: MIT
  verified: 2026-11-23
maturity: beta
name: privacy-first-analytics
description: Instrument product analytics with minimal event data, no cookies, UTC time, explicit opt-in features and a documented self-hosting boundary.
category: analytics
version: 0.1.0
author: devtiagoabreu
tags: [analytics, privacy, gdpr, events, funnels, self-hosting]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - an analytics endpoint you control or a self-hosted instance
provides:
  - A minimal event schema
  - A privacy review gate for optional tracking
  - An AI-query boundary for analytics data
security:
  risk_level: low
  permissions:
    - network
  audited: true
difficulty: beginner
---

# Privacy-First Analytics

## Overview

The cheapest personal data to protect is the data you never collect. Privacy-first analytics answers useful questions with coarse events, no cookies and no cross-site identifiers. Advanced features are opt-in and require their own review.

## Prerequisites

- A defined set of questions the analytics must answer.
- A data owner who approves optional identifiers.
- UTC configured on the database and consistent time handling in clients.

## Usage Instructions

### 1. Start from the questions

| Question | Minimum event |
|---|---|
| Which pages are visited? | pageview with path and referrer |
| Which campaigns convert? | UTM fields on pageview |
| Where do users drop off? | named custom events on funnel steps |
| What is a page worth? | revenue value on a conversion event |

If a question requires a persistent personal identifier, escalate rather than adding it quietly.

### 2. Keep the event shape small

```json
{
  "name": "checkout.completed",
  "url": "/checkout/success",
  "data": { "plan": "pro", "value": 49 }
}
```

Use stable event names, coarse properties and UTC timestamps. Avoid raw emails, names, full URLs with tokens, and free-text fields.

### 3. Default to no cookies and no profiles

Pages can be grouped into anonymous visits without persistent profiles. Do not track users across sites. If your product does not need a cookie banner for analytics, say so explicitly in the privacy note — and verify other scripts do not reintroduce one.

### 4. Review optional features separately

Distinct IDs, custom session properties, revenue tracking, session replay and heatmaps can collect personal data. Each requires: purpose, retention, who can view it, consent or legal basis, and a deletion path. Replay should be disabled unless explicitly enabled.

### 5. Make funnels and goals meaningful

Define the conversion event and its value before launching. A funnel without a typed drop-off reason produces charts but no decisions. Track attribution at the campaign level rather than the individual level.

### 6. Bound AI access

If an assistant can query analytics, use a read-only connection with scoped credentials. Allow aggregate questions; deny queries that return raw event rows or attempt to join with identity tables. Log the question and the data scope.

### 7. Document the self-hosting boundary

When self-hosting, you own TLS, updates, backups, credential protection, administrative access and legal compliance. Store secrets outside the repository and rotate defaults immediately. Write this boundary into the runbook.

## Examples

### Example 1: Event naming convention

```text
<object>.<past-tense-action>  e.g. account.created, checkout.completed
properties: plan, source, value, step
forbidden: email, name, phone, token, raw_query
```

### Example 2: Optional-feature review row

```yaml
feature: session_replay
default: off
purpose: debug checkout drop-off
retention: 30d
viewers: support-leads
legal_basis: consent
deletion: documented API call
approved_by: data-owner
```

## References

- [Umami](https://github.com/umami-software/umami)
- [Umami docs](https://docs.umami.is/docs/)
- Kit companions: `business-intelligence`, `harness-engineering-patterns`
