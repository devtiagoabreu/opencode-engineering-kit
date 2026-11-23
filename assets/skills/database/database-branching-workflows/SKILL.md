---
provenance:
  source: Neon
  source_url: https://github.com/neondatabase/neon
  license: Apache-2.0
  verified: 2026-11-23
maturity: beta
name: database-branching-workflows
description: Use copy-on-write database branches for preview environments, migration tests, isolated QA and point-in-time recovery without loading production.
category: database
version: 0.1.0
author: devtiagoabreu
tags: [postgres, branching, preview-environments, migrations, backup, restore]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - a database platform that supports isolated branches or an equivalent restore workflow
provides:
  - Branch lifecycle rules for preview, test and recovery
  - A sensitive-data branching decision
  - A branch-per-change CI contract
security:
  risk_level: low
  permissions:
    - network
  audited: true
difficulty: intermediate
---

# Database Branching Workflows

## Overview

A database branch is a copy-on-write clone: it starts with the parent's data at a point in time, then diverges through its own writes. Creating one should not add read load to production or mutate the parent. Use branches to make environments disposable instead of shared.

## Prerequisites

- A branch-capable database service or a scripted restore into an isolated instance.
- A naming convention that encodes owner, change and lifetime.
- A documented data classification for each environment.

## Usage Instructions

### 1. Pick a branch type by intent

| Intent | Branch from | Lifetime | Notes |
|---|---|---|---|
| Pull-request preview | Current main | Until PR closes | Destroy automatically |
| Migration rehearsal | Current main | Short | Run up and down migrations here |
| QA or load test | Current main or sanitized snapshot | Days | Give it dedicated compute |
| Incident analysis | Point in time | Until review ends | Never write production fixes here |
| Recovery | Point in time | Until cutover | Validate before promoting |

### 2. Protect sensitive data

If a branch contains production personal data, either use schema-only branching or a sanitized snapshot. Record which option was used. A preview URL is still a production data surface if it exposes real records.

### 3. Keep branches boring

- Create from a named ancestor, not an ambiguous "latest".
- Set an expiry on temporary branches; no forever previews.
- Never point a production service at a branch by accident: include the branch name in its connection label and in logs.
- Deleting a branch is a normal cleanup step. Do not use a branch as the only backup of a fact.

### 4. Wire branches into CI

For each pull request: create branch, apply migrations, run schema checks and seeded tests, then drop it on failure or merge. Report the branch identifier in the check output so a reviewer can inspect the same state.

### 5. Plan restore separately

Branching is not a backup strategy by itself. Configure a history window, know its limit, and rehearse a point-in-time restore. Verify the restored data and the application compatibility before any cutover.

### 6. Branch dependent services too

Authentication state, object storage namespaces and function deployments may need to follow the data branch so a preview does not share sessions or files with production. Document which services are branch-aware.

## Examples

### Example 1: Preview branch definition

```yaml
branch: preview/pr-482
ancestor: main
data: schema-only
expires: 7d
compute: dedicated-small
checks: [migrate up, seed, smoke tests]
```

### Example 2: Restore rehearsal record

```text
Target: 2026-11-22T18:10Z, 12 minutes before the bad deploy
Restored into: recovery/incident-17 (isolated)
Verified: row counts, auth session isolation, app health
Decision: promote only after checksum comparison passes
```

## References

- [Neon](https://github.com/neondatabase/neon)
- [Neon branching](https://neon.com/docs/introduction/branching)
- Kit companion: `rls-tenancy-pattern`
