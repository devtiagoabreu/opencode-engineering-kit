---
provenance:
  source: Supabase
  source_url: https://github.com/supabase/supabase
  license: Apache-2.0
  verified: 2026-11-23
maturity: beta
name: rls-tenancy-pattern
description: Enforce multi-tenant authorization in PostgreSQL with row-level security, JWT claims, scoped service roles and tested policies.
category: database
version: 0.1.0
author: devtiagoabreu
tags: [postgres, rls, multi-tenant, authorization, jwt, storage]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - PostgreSQL with row-level security available
  - a way to pass verified identity claims into the database session
provides:
  - A policy-first authorization model
  - Service-role and edge-function boundaries
  - Policy test cases for tenant isolation
security:
  risk_level: low
  permissions:
    - network
  audited: true
difficulty: advanced
---

# RLS Tenancy Pattern

## Overview

When the database is exposed through a data API, the database must be the last line of authorization. Row-level security (RLS) turns a verified identity into a predicate on every read and write, so a forgotten UI check does not leak another tenant's rows.

This pattern uses PostgreSQL directly. It does not require a particular hosted platform.

## Prerequisites

- A tenant identifier on every shared table.
- A verified claim source, typically a JWT issued by your auth service.
- SQL migrations under version control and a test database.

## Usage Instructions

### 1. Design the ownership key first

Add `tenant_id` (or the equivalent) to every tenant-scoped table, index it, and make it part of foreign keys where practical. A policy cannot protect rows it cannot identify.

### 2. Enable RLS on every tenant table

```sql
alter table public.projects enable row level security;
alter table public.projects force row level security;

create policy projects_tenant_select on public.projects
  for select to authenticated
  using (tenant_id = (select auth.jwt() ->> 'tenant_id')::uuid);
```

`force` matters: table owners should be subject to the same rules. Use separate `select`, `insert`, `update` and `delete` policies so write paths are explicit.

### 3. Treat claims as verified input only

Policies should read claims set by the auth service, not values supplied by the client in a header or body. Reject requests with missing or malformed tenant claims. Keep token lifetime short and rotate signing keys on a schedule.

### 4. Keep privileged roles narrow

A service role bypasses RLS by design. Use it only for administrative work in trusted server code, never in a browser or a user-facing edge function. Log each privileged operation with actor and reason.

### 5. Run edge functions as the user when possible

For ordinary CRUD, issue requests with the user's token so policies apply. If a function needs elevated access, isolate that path, validate the user's intent yourself, and write an audit row.

### 6. Apply the same model to files

Object storage permissions should be expressed with policies that reference tenant and ownership, not with public bucket URLs. Generate short-lived signed URLs after authorization.

### 7. Test isolation as a gate

For each table, assert that tenant A cannot select, update or delete tenant B's rows, including through nested relations. Add a test that a new table has RLS enabled; silent omissions are the common failure.

## Examples

### Example 1: Policy test matrix

```text
table=projects, role=authenticated, claim.tenant=A
select own    -> 1 row
select other  -> 0 rows
update other  -> 0 rows affected
delete other  -> 0 rows affected
insert with claim.tenant=B -> rejected or stored as B, never as A
```

### Example 2: Service-role receipt

```yaml
operation: backfill_invoice_numbers
actor: job/invoice-backfill
reason: migration-0042
rows: 1204
tenant_scope: all
reviewed_by: owner
```

## References

- [Supabase](https://github.com/supabase/supabase)
- [Supabase architecture](https://supabase.com/docs/guides/getting-started/architecture)
- Kit companions: `multi-tenant-saas`, `rbac-authorization`, `database-branching-workflows`
