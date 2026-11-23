---
provenance:
  source: Open SaaS
  source_url: https://github.com/wasp-lang/open-saas
  license: MIT
  verified: 2026-11-23
maturity: beta
name: saas-blueprint-patterns
description: Assemble a SaaS starter from verified vertical slices covering auth, email, jobs, billing, uploads, deploy and AI-ready repository instructions.
category: projects
version: 0.1.0
author: devtiagoabreu
tags: [saas, boilerplate, fullstack, onboarding, deploy, agents]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - a chosen application framework and deployment target
provides:
  - A vertical-slice checklist for SaaS foundations
  - An AI-ready repository instruction layout
  - A first-deploy acceptance contract
security:
  risk_level: low
  permissions:
    - filesystem
  audited: true
difficulty: intermediate
---

# SaaS Blueprint Patterns

## Overview

A SaaS starter is valuable when every feature is wired end to end, not when it is a bag of examples. Treat each foundation as a vertical slice: schema, server code, UI, tests, environment variables and deploy configuration must all be present.

The same discipline applies to AI readiness: repository instructions, skills and plugin configuration are part of the starter, not an afterthought.

## Prerequisites

- A target framework and a deployment platform.
- A list of providers you are allowed to use (auth, email, payments, storage).
- A clean way to manage local environment variables.

## Usage Instructions

### 1. Inventory the slices before generating code

| Slice | Minimum proof |
|---|---|
| Authentication | Sign up, log in, session refresh, protected route |
| Authorization | Role or ownership check on a real resource |
| Email | Template rendered, sent in local dev, captured in a test |
| Background jobs | Enqueue, retry, idempotent handler, failure log |
| Billing | Checkout, webhook verified, entitlement reflected in UI |
| Uploads | Validate type/size, store object, authorize access |
| Landing and docs | Public page with working links |
| Deploy | One documented command or pipeline from clean checkout |
| AI instructions | `AGENTS.md` or equivalent plus project skills |

Do not scaffold a slice you cannot demonstrate. An unwired provider is debt.

### 2. Make provider choices explicit

For each external provider record: purpose, environment variables, local emulator or test mode, production account owner, and cost trigger. Mark which providers are optional so a database-only setup remains valid.

### 3. Design the data boundaries early

Put tenant identity on shared tables from the first migration. Decide whether authorization lives in the database, in middleware, or both. Add an ownership test alongside the first protected endpoint so the rule is enforced rather than documented.

### 4. Add agent instructions as versioned files

Keep short, durable rules in the repository root. Point to deeper docs instead of pasting them into prompts. Include:

- build, test and lint commands;
- directory map and where new features belong;
- conventions for migrations, environment variables and commits;
- a list of skills agents should load for common tasks.

Review these files like code; stale instructions are worse than none.

### 5. Finish with a clean-checkout rehearsal

Clone or archive the starter into a new directory, install dependencies, copy the example environment file, run migrations and tests, then deploy a preview. Record every manual fix as a starter defect.

## Examples

### Example 1: Slice definition

```yaml
slice: email
files: [emails/welcome.tsx, lib/mailer.ts, test/mailer.test.ts]
env: [EMAIL_API_KEY, EMAIL_FROM]
local: preview server plus captured message
acceptance: template renders, test captures send, no key in logs
```

### Example 2: First-deploy contract

```text
[ ] Clean checkout builds
[ ] Migrations run on an empty database
[ ] Health endpoint returns 200
[ ] Auth flow works against the preview domain
[ ] Webhook endpoint verifies signatures
[ ] Rollback to the previous image is documented
```

## References

- [Open SaaS](https://github.com/wasp-lang/open-saas)
- [Open SaaS docs](https://docs.opensaas.sh/)
- Kit companion: `rls-tenancy-pattern`
