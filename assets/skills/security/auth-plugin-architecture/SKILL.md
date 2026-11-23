---
provenance:
  source: Better Auth
  source_url: https://github.com/better-auth/better-auth
  license: MIT
  verified: 2026-11-23
maturity: beta
name: auth-plugin-architecture
description: Design authentication as a typed plugin system with server and client contracts, schema extensions, hooks and organization-scoped authorization.
category: security
version: 0.1.0
author: devtiagoabreu
tags: [authentication, authorization, plugins, organizations, sessions, passkeys]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - a TypeScript server runtime
  - a database with migrations
provides:
  - A plugin contract checklist
  - Organization, team and role modeling guidance
  - Security and migration gates for auth changes
security:
  risk_level: low
  permissions:
    - filesystem
  audited: true
difficulty: advanced
---

# Auth Plugin Architecture

## Overview

Authentication grows by features: 2FA, passkeys, organizations, SSO, API keys, billing hooks. A plugin architecture keeps that growth out of the core by giving each feature a narrow contract: identity, endpoints, schema, hooks, middleware and optional client surface.

The same model supports AI agents: capability-based credentials should be a plugin, not a separate auth system bolted on later.

## Prerequisites

- A core auth object with session management.
- A migration tool for schema extensions.
- Agreement on which identity claims are trusted.

## Usage Instructions

### 1. Define the plugin contract

| Element | Question |
|---|---|
| `id` | Is it unique and stable across server and client? |
| endpoints | What routes does it add, and who may call them? |
| schema | Which tables or fields does it extend, and how are they migrated? |
| hooks | Which existing flows does it observe or modify? |
| middleware | Which route group needs a guard, and what is the matcher? |
| rate limits | Which endpoints can be abused? |
| client | Does the browser need typed actions, and are they paired with server endpoints? |

Keep the `id` versioned if behavior changes incompatibly. A plugin that needs both sides must ship them together.

### 2. Layer authorization after authentication

Session middleware answers "who are you?". A second layer answers "in which organization, with which role?". Store the active organization and optional active team on the session so every request has an unambiguous scope.

```text
request -> verify session -> resolve active org -> check role -> run handler
```

Never infer the organization from a client-supplied field without checking membership.

### 3. Model organizations explicitly

Use first-class tables for organization, member, invitation and optional team/team-member. Roles and permissions belong to membership, not to the user globally. Custom fields should flow through endpoints automatically or be deliberately hidden.

### 4. Add strong auth as opt-in but reviewable

2FA, passkeys and magic links are plugins with their own recovery paths. For each one document enrollment, recovery, device loss and revocation. A feature without a recovery story is not done.

### 5. Treat agent credentials as capabilities

For AI agents, prefer discovery plus registration and capability-scoped tokens over sharing a human session. Grant the minimum actions, bind tokens to an owner and expiry, and log every use.

### 6. Test the auth boundary

- unauthenticated request to a protected endpoint is rejected;
- cross-organization access is rejected even with a valid session;
- role change takes effect on the next request;
- plugin migration is reversible or has a documented forward fix;
- rate limit trips before abuse becomes expensive.

## Examples

### Example 1: Plugin declaration sketch

```ts
export const auditPlugin = () => ({
  id: "audit",
  hooks: {
    after: [{ matcher: "/organization/*", handler: writeAuditRow }]
  },
  schema: {
    auditLog: { fields: { actorId: "string", action: "string" } }
  }
});
```

### Example 2: Authorization decision record

```text
actor: user_42
session: active
organization: acme (membership confirmed)
role: member
required: admin
decision: deny
reason: insufficient role
```

## References

- [Better Auth](https://github.com/better-auth/better-auth)
- [Better Auth plugins](https://www.better-auth.com/docs/plugins)
- Kit companions: `rbac-authorization`, `multi-tenant-saas`, `authentication`
