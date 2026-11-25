---
provenance:
  source: "OpenCode Engineering Kit (community) — padrões adaptados de google/skills (google-cloud-recipe-auth), google-auth-* e googleworkspace/apps-script-samples"
  source_url: https://github.com/google/skills
  license: "Apache-2.0 (upstream); MIT (adapter)"
  verified: 2026-11-25
maturity: beta
name: google-workspace-oauth
description: "Choose and implement least-privilege auth for Google Workspace APIs: OAuth user consent, service accounts, ADC/WIF and safe token handling."
category: security
version: 0.1.0
author: devtiagoabreu
tags: [google-workspace, oauth2, adc, service-account, iam, scopes, tokens]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Google Cloud project with the target APIs enabled
  - Admin access to consent screen or Workspace admin for domain-wide delegation
  - Node.js, Python or another language with an official Google auth client
provides:
  - Decision table for user OAuth, service accounts, ADC/WIF and API keys
  - Scope selection and consent checklist per Workspace service
  - Token storage, refresh and rotation rules
  - Failure modes to avoid in automated agents
---

# Google Workspace OAuth

## Overview

Most Workspace incidents are not API bugs: they are auth design bugs. A client
gets a broad scope, a refresh token lands in a log, or a service account is
granted domain-wide delegation "just to test". This skill gives a conservative
default: **pick the narrowest identity and scope that can do the job, and make
every write reversible or explicitly approved.**

Treat tokens, service-account JSON keys and browser cookie snapshots as
credentials with the same value as a password. Never paste them into chat,
commits, fixtures or screenshots.

## 1. Decision table

| Situation | Use | Avoid |
|---|---|---|
| Script acting for one user, installed locally | OAuth 2.0 installed-app flow with loopback redirect + PKCE | Out-of-band (OOB) copy/paste redirect, deprecated |
| Automation owned by your app, one Workspace domain | Service account + domain-wide delegation, impersonating a specific user | Impersonating an admin for routine reads |
| Workload on Cloud Run / GKE / Compute Engine | ADC with attached service account or Workload Identity Federation | Downloading JSON keys into the container |
| Public, non-sensitive data only | API key with API + referrer restrictions | API key for Drive/Docs/Calendar private data |
| Agent calling Google-hosted MCP endpoints | OAuth user grant + `roles/mcp.toolUser`, least-privilege toolsets | Sharing one token across all users and tools |

Rule: if the operation changes user data, require a human confirmation step
outside the model turn.

## 2. Setup sequence (user OAuth)

1. In the Cloud Console, create/select the project and enable only the APIs
   needed (for example `drive.googleapis.com`, `sheets.googleapis.com`).
2. Configure the OAuth consent screen. Internal-only audience is the default
   for Workspace; external/testing requires verification and adds friction.
3. Create an OAuth client of type **Desktop app** or **Web application**;
   register exact loopback redirect URIs (for example `http://127.0.0.1:port`)
   and use PKCE.
4. Request scopes one service at a time. Prefer the readonly variant first;
   upgrade only after the write path is approved.
5. Exchange the code immediately, persist the refresh token encrypted at rest,
   and keep access tokens in memory only.
6. On `401 invalid_grant`, revoke and re-consent instead of blindly retrying.

Pseudo-flow:

```text
build authorization URL (client_id, redirect_uri, scope, state, code_challenge)
→ open browser, user consents
→ callback with code + state (verify state!)
→ exchange code + verifier for tokens
→ call API with access token
→ on 401: refresh once with refresh token, then re-consent
```

`state` and PKCE are mandatory, not optional hardening.

## 3. Service accounts and ADC

- A service account is an identity for **your workload**, not a shared human.
- Domain-wide delegation requires a Workspace admin to authorize the client
  ID and exact scopes. Scope changes require re-authorization.
- Always impersonate a dedicated, low-privilege mailbox for automation.
- On Google Cloud, prefer ADC: the client library finds credentials from the
  environment with no file to copy. Use WIF for external runners (GitHub
  Actions, on-prem) instead of long-lived keys.
- If a key is unavoidable: rotate on a schedule, restrict its IAM roles, store
  it in a secret manager and never in the repository.

## 4. Scope selection (start narrow)

| Service | Read scope | Write scope |
|---|---|---|
| Drive | `drive.metadata.readonly` / `drive.readonly` | `drive.file` (app-created files) before `drive` |
| Sheets | `spreadsheets.readonly` | `spreadsheets` only for approved edits |
| Docs | `documents.readonly` | `documents` only for approved edits |
| Calendar | `calendar.readonly` | `calendar.events` (events only) |
| Photos | `photoslibrary.readonly` **app-created media only** | Picker API token for user-selected media |

Important: the broad `photoslibrary`, `photoslibrary.readonly` and
`photoslibrary.sharing` scopes were removed on 2025-03-31. Do not design new
flows around them; use the Photos Picker API.

## 5. Token handling rules

- Store refresh tokens encrypted, keyed by user + client + scopes.
- Log token **metadata** (expiry, scope set, client id), never token values.
- Refresh once per request; on repeated failure, surface a re-consent action.
- Revoke tokens on user offboarding and after a suspected leak.
- Set a short access-token lifetime assumption; never cache beyond expiry.
- In agents, expose `auth_status` / `reconnect` operations rather than asking
  the model to "fix the token".

## 6. Review checklist

- [ ] Only required APIs enabled; consent screen audience is intentional
- [ ] Narrowest scope chosen; readonly first
- [ ] PKCE + `state` present for installed/web OAuth
- [ ] Redirect URIs exact; no wildcard in production
- [ ] No service-account key in code, image or CI log
- [ ] Tokens encrypted, rotatable, revocable; expiries monitored
- [ ] Write calls require explicit human approval
- [ ] Retrieved Docs/Sheets/email content treated as untrusted prompt input

## 7. Failure modes

| Symptom | Likely cause | Action |
|---|---|---|
| `403 insufficient_scopes` | Scope upgrade after consent | Re-consent with the new scope; do not reuse old token |
| `invalid_grant` | Revoked/expired refresh token or clock skew | Re-consent; check system clock |
| `access_denied` at consent | Unverified external app or wrong audience | Use internal audience or complete verification |
| `PERMISSION_DENIED` on Photos sharing | Removed scope | Switch to Picker API |
| `403` from hosted MCP endpoint | Missing `roles/mcp.toolUser` | Grant role on the project/resource |

## References

- https://github.com/google/skills (google-cloud-recipe-auth)
- https://github.com/googleapis/google-auth-library-python
- https://github.com/googleapis/google-auth-library-nodejs
- https://github.com/googleworkspace/apps-script-samples
- https://developers.google.com/identity/protocols/oauth2
- Inventário interno: `docs/GOOGLE_WORKSPACE_REPOS.md`
