---
provenance:
  source: "OpenCode Engineering Kit (community) — padrões adaptados de googlesamples/google-photos e da documentação oficial Photos Picker / Library API"
  source_url: https://github.com/googlesamples/google-photos
  license: "Apache-2.0 (upstream); MIT (adapter)"
  verified: 2026-11-25
maturity: beta
name: google-photos-api
description: Work with Google Photos safely via Picker API selection and Library API app-created media, respecting removed scopes and privacy limits.
category: tools
version: 0.1.0
author: devtiagoabreu
tags: [google-photos, picker-api, photos-library, media, albums, privacy]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Google Cloud project with Photos Library API and Photos Picker configured
  - OAuth client with Picker origin/account constraints reviewed
  - Explicit user consent for any personal media access
provides:
  - Picker vs Library API decision guide
  - Upload/album/media-item workflow
  - Privacy, quota and scope guardrails
  - Assessment of unofficial Photos MCP servers
---

# Google Photos API

## Overview

Google Photos is the most privacy-sensitive Workspace surface. The old model —
one broad `photoslibrary` scope for the whole library — was removed on
**2025-03-31**. The supported model today splits responsibilities:

- **Photos Picker API**: the user explicitly selects photos/videos in a Google
  UI; your app receives tokens for just that selection.
- **Photos Library API**: create albums and manage media **your app created**.
  Full-library listing of arbitrary user media is no longer the contract.

There is **no official Google skill or MCP server for Photos**. Community MCPs
exist; treat them as untrusted integrations.

## 1. Decision table

| Task | Supported path | Do not |
|---|---|---|
| User chooses existing photos | Picker API, handle selection tokens | Request removed broad scopes |
| Upload new media from your app | Library API upload session + `batchCreate` | Reuse another app's media item IDs |
| Create albums / organize app media | Library API `albums.create`, `album.add` | Claim access to user-created albums |
| Search the user's entire library | Not available via current scopes | Use private web RPCs or browser cookies |
| Agent tool for Photos | Wrap the supported APIs with narrow scopes | Use an unofficial MCP based on private `batchexecute` calls |

## 2. Picker flow

1. Configure the Picker in the Cloud Console with the allowed origins and
   `photoslibrary.picker.create` / related scopes.
2. Open the Picker from a user gesture; do not try to automate the UI headlessly.
3. Receive the selection result (session/media item tokens).
4. Use the tokens only for the selected items and the documented exchange path.
5. Store tokens briefly, scoped to the session; delete after use.
6. Treat selection as consent for that set of items only.

A Picker token is not a general Library API credential. Do not persist or reuse
it for background sync.

## 3. Library flow for app-created media

```text
1. uploadBytes / upload file
   → receive uploadToken (short-lived)
2. batchCreate with { uploadToken, fileName, description }
   → receive mediaItem id + productUrl
3. albums.create → album id
4. add media items to album with albumId + mediaItemIds
5. list via filters (albumId, date ranges, mediaType) with pagination
```

Rules:

- Upload large files with a resumable session; keep the session URL for retry.
- Batch media item creation to reduce quota usage.
- Honor `nextPageToken`; do not assume a single page is the whole album.
- Download URLs returned by the API need documented size parameters; do not
  fabricate transformation URLs.
- Respect per-user/per-app quotas and back off on `429`/`5xx`.

## 4. Privacy and safety

- Personal photos can reveal location, faces, minors and health context. Ask
  before sending any image to an external model or storage provider.
- Never log media URLs, tokens, filenames with PII, or album contents.
- Do not infer sensitive attributes from images; describe only what the user
  asked for.
- Require explicit approval before upload, delete, or album sharing.
- Unofficial MCP servers that use browser cookies or undocumented RPCs run with
  the authority of the user's whole session and may violate Terms of Service.
  If one is evaluated, isolate it, review scopes, and never store credentials
  in the kit.

## 5. Review checklist

- [ ] Picker used for user-selected media; no removed scopes requested
- [ ] App-created media tracked with stable source IDs (no duplicates)
- [ ] Uploads resumable; batching and pagination implemented
- [ ] Explicit consent for external processing of images
- [ ] No credential/URL/PII logged
- [ ] Write/delete operations approved by a human
- [ ] No private-RPC/cookie-based integration in production

## 6. Failure modes

| Symptom | Likely cause | Action |
|---|---|---|
| `PERMISSION_DENIED` on sharing | Removed sharing scope | Use Picker; do not retry with broader scope |
| Empty library listing | Library API covers app-created media only | Use Picker for user items |
| `403 insufficient_scopes` | Wrong Picker/Library scope set | Reconfigure OAuth client and re-consent |
| `429` | Upload/list quota | Backoff, batch, reduce concurrency |
| Upload token expired | Long delay between upload and `batchCreate` | Re-upload with a fresh session |

## References

- https://github.com/googlesamples/google-photos
- https://developers.google.com/photos/library/guides/client-libraries
- https://developers.google.com/photos/picker/guides/overview
- https://www.googleapis.com/discovery/v1/apis/photoslibrary/v1/rest
- Inventário interno: `docs/GOOGLE_WORKSPACE_REPOS.md` (§2.4, §4)
