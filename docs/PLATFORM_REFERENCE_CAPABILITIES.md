# Platform Reference Capabilities

**Date:** 2026-11-23  
**Status:** Active; all imported capabilities are `beta` until curated.

This document records what was learned from the eleven platform repositories named in the request (the request mentioned twelve, but only eleven names were provided) and where the adapted capabilities now live. The clones are local research material and are not part of the kit. No upstream source code, images, icons or long reference text were vendored.

## Rule of adaptation

Ideas, workflows and checklists were re-expressed in this kit's asset format. Each new asset declares the upstream source, canonical URL and license in its frontmatter. Where an upstream license adds conditions, only idea-level patterns were used and the provenance says so explicitly.

## Mapping

| Upstream | License | Kit assets | What was adapted |
|---|---|---|---|
| [Open SaaS](https://github.com/wasp-lang/open-saas) | MIT | `saas-blueprint-patterns`, `saas-launch-checklist` | Vertical-slice inventory, AI-ready repository instructions, provider ledger, clean-checkout rehearsal, launch gate. |
| [shadcn/ui](https://github.com/shadcn-ui/ui) | MIT | `registry-distribution` | Code-distribution registry, item manifest, GitHub and namespace addressing, environment-based credentials, publish validation, untrusted-registry review. The existing `shadcn-ui` skill remains the component guide. |
| [Neon](https://github.com/neondatabase/neon) | Apache-2.0 | `database-branching-workflows` | Copy-on-write branch types, schema-only branching for sensitive data, branch-per-PR, TTL, point-in-time restore rehearsal, branch-aware dependent services. |
| [Supabase](https://github.com/supabase/supabase) | Apache-2.0 | `rls-tenancy-pattern` | RLS as the final authorization boundary, JWT claims, service-role discipline, edge functions as the user, storage policies, isolation tests. |
| [Better Auth](https://github.com/better-auth/better-auth) | MIT | `auth-plugin-architecture` | Typed plugin contract, server and client pairing, schema extensions, hooks and middleware, organizations/teams/roles, recovery paths, capability-based agent credentials. |
| [AI SDK](https://github.com/vercel/ai) | Apache-2.0 | `ai-sdk-agent-patterns` | Provider-agnostic surface, schema-validated output, tool contract, step and concurrency budgets, streaming choices, prompt-injection boundary, tool packages. |
| [Dify](https://github.com/langgenius/dify) | Dify Open Source License (Apache-2.0 with added conditions; ideas only) | `llm-workflow-orchestration` | Visible node taxonomy, human review, typed failure paths, versioned workflow definitions, trace export, RAG pipeline stages, decoupled integrations. |
| [Polar](https://github.com/polarsource/polar) | Apache-2.0 | `usage-based-billing`, `billing-meter-spec` | Event/meter/price layering, aggregation types, unit/volume/graduated pricing, credits, subscription lifecycle, idempotency, webhooks, per-customer margin. |
| [React Email](https://github.com/resend/react-email) | MIT | `transactional-email-patterns` | Component structure, preview text, pixel-based styling, HTML plus plain text, accessibility defaults, cross-client matrix, provider decoupling. |
| [Umami](https://github.com/umami-software/umami) | MIT | `privacy-first-analytics` | Minimal event schema, no cookies or profiles, UTC, explicit review of optional tracking, read-only AI access, self-hosting responsibility boundary. |
| [Coolify](https://github.com/coollabsio/coolify) | Apache-2.0 | `self-host-deployment` | Control-plane versus workload boundary, project/environment resource model, previews and rollbacks, health checks, secrets backup, exit path. |

## What was intentionally not copied

- shadcn component source, theme files and CLI implementation; only the distribution pattern is described, and the kit already has a `shadcn-ui` component guide.
- Wasp framework code and the full Open SaaS application; only the foundation checklist is adapted.
- Neon storage engine, Supabase services, Better Auth server, AI SDK runtime, Dify platform, Polar API, React Email components, Umami application and Coolify control plane.
- Dify's extra commercial conditions on multi-tenancy and frontend branding; the adapted skill contains no upstream code or UI.
- Provider icons, logos, screenshots and bundled templates.

## Maturity and curation

All new assets are `beta`: usable but not yet in `profiles/core.json`. Promotion to `stable` follows [QUALITY_POLICY.md](./QUALITY_POLICY.md) and requires profile curation plus the normal quality gates.

## Verification

```bash
python scripts/validate_assets.py --root . --check-manifest --check-links --strict-policy
python scripts/sync_readme_counts.py --root . --check
```

Provenance rows for the new skills are also listed in `context/provenance.md`. For future `aprenda` runs, the canonical queue and protocol live in [APRENDA_REPOSITORIOS.md](./APRENDA_REPOSITORIOS.md).
