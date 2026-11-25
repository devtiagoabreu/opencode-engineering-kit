---
provenance:
  source: OpenCode Engineering Kit (community)
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-08-15
maturity: beta
name: vercel-deployment
description: Deploy and operate Next.js apps on Vercel — previews, environment variables, Route Handler limits, serverless considerations, monitoring and CI integration
category: devops
version: 0.1.0
author: devtiagoabreu
tags: [vercel, deployment, serverless, nextjs, ci-cd, env-vars, monitoring]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - A Next.js project connected to a Git repository (GitHub)
  - A Vercel account/team
provides:
  - Deploy setup with Git integration and preview environments
  - Environment variable management across environments
  - Serverless function limits and Route Handler best practices
  - CI integration (GitHub Actions) and database migrations on deploy
  - Monitoring and analytics wiring (Vercel Analytics, Sentry, error tracking)
---

# Vercel Deployment

## Overview

Vercel is the native hosting platform for Next.js: push to Git, and Vercel
builds and deploys automatically. It provides preview deployments per branch/PR,
environment variables per environment (development/preview/production), and a
serverless runtime for Route Handlers and Server Components. For a Next.js
full-stack SaaS (like the RouteOS reference app) this means one codebase — UI +
API + database access — deployed without a separate server, with careful
attention to serverless function limits and database connections.

## Prerequisites

- Project pushed to GitHub/GitLab
- Vercel account (free Hobby or Pro for teams)
- `vercel` CLI optionally for local env sync (`vercel env pull`)

## Usage Instructions

### Step 1: Connect the repository

1. Import the repo at <https://vercel.com/new> and let Vercel detect Next.js.
2. Keep the framework preset `Next.js` and build settings default
   (`next build`). Do not set custom `output` unless needed.
3. A deployment is created for `main` (production) and for every PR
   (preview). Preview deployments are the default review environment.

### Step 2: Environment variables

Add variables per environment — never commit secrets:

```bash
vercel env add DATABASE_URL production
vercel env add ORS_API_KEY production
vercel env add AUTH_SECRET production
```

- Keep a `.env.example` in the repo documenting every variable; keep
  `.env.local` out of Git.
- Conecte o projeto com `vercel link` e puxe o ambiente com
  `vercel env pull .env.local`.
- Nunca use `vercel env add --value ...`: o valor fica no histórico do shell.
  Prefira o prompt interativo, stdin ou o painel da Vercel.
- `NEXT_PUBLIC_` apenas para dados públicos: segredos com esse prefixo entram
  no bundle do browser.
- For Neon: use the pooled connection string in production so serverless
  functions share connections.

### Step 3: Function limits (confirme no plano e na docs atuais)

Route Handlers rodam como Functions, mas limites mudam por plano e região: não
repita números antigos como "~10s Hobby / ~60s Pro". Confira
<https://vercel.com/docs/functions> e o plano contratado.

- **Payload:** o teto de requisição/resposta costuma ficar em torno de 4.5 MB —
  confirme antes de dimensionar. Para upload use URL assinada de armazenamento,
  não o body do Route Handler.
- **Duração:** declare `maxDuration` por rota e envolva chamadas externas com
  `AbortSignal.timeout(15_000)`; trabalho longo vai para fila/job.
- **Memória e bundle:** meça o uso real, mantenha o Prisma client como singleton
  (`export const runtime = "nodejs"`) e enxugue dependências no caminho crítico.
- **Fluid Compute:** reduz o custo de cold starts com instâncias concorrentes
  aquecidas; ainda assim projete para timeout, retry e idempotência.
- Don't run heavy work during render; move it to Route Handlers or background.

### Step 4: Database migrations on deploy

Apply migrations before the app reads new tables:

```bash
# in a GitHub Action before/at deploy, or via Vercel build command
"build": "prisma generate && prisma migrate deploy && next build"
```

Never run `migrate dev` (drops data) in production — use `migrate deploy`.

### Step 5: CI integration with GitHub Actions

Preview checks run Vercel's own bot; add your own CI for tests:

```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: npm }
      - run: npm ci
      - run: npm run lint
      - run: npm run test
      - run: npx tsc --noEmit
```

### Step 6: Monitoring and analytics

- Enable **Vercel Analytics** for page/route usage (no external SDK).
- Add **Sentry** for error tracking: initialize in `sentry.client.config.ts`
  and `sentry.server.config.ts`, set `SENTRY_DSN` per environment.
- Configure **Speed Insights** for performance.
- Set up **deployment protection** for previews if the app has auth or secrets.

### Step 7: Cache e revalidação (resumo)

Para `updateTag`, `revalidateTag(tag, "max")`, `revalidatePath`, Cache
Components, streaming com Suspense e hidratação determinística, siga
[runtime e cache](../vercel-runtime-and-cache/SKILL.md). Tags são
case-sensitive e limitadas a 256 caracteres; confirme as assinaturas na versão
instalada do Next.js antes de editar.

### Step 8: Promoção e rollback

Fluxo: PR → preview → checks (lint, tipos, testes, e2e) → `vercel promote` →
`vercel rollback` se algo falhar. No CI, use `vercel build --prod` seguido de
`vercel deploy --prebuilt` para não gerar builds diferentes. Promover com
variáveis de Production diferentes pode recompilar: verifique depois de
promover. Confirme a sintaxe na versão da CLI instalada.

```bash
vercel promote <url-do-preview> --prod
vercel rollback <deployment-anterior>
```

### Step 9: Verificação ponta a ponta

Não declare deploy pronto sem percorrer **browser → API → dados → resposta**:
interação real sem erro de hidratação, status e latência da API, persistência e
invalidação no banco, HTML/JSON final com `Cache-Control` coerente. Metas de Web
Vitals em campo (p75): LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1.

### Step 10: Telemetria do plugin Vercel

O plugin oficial `vercel/vercel-plugin` coleta eventos de uso por padrão. Antes
de instalá-lo em ambiente de time, avalie a política de privacidade e desligue
a coleta com `VERCEL_PLUGIN_TELEMETRY=off` quando não houver autorização.

## Examples

### Environment-dependent base URL

```ts
// lib/config.ts
export const config = {
  appUrl: process.env.NEXT_PUBLIC_APP_URL ?? "https://app.example.com",
  isProd: process.env.NODE_ENV === "production",
};
```

### Route Handler with runtime and timeout guard

```ts
export const runtime = "nodejs"; // needed for Prisma

export async function POST(req: Request) {
  // validate → tenant scope → call service
  // wrap external provider calls with a 15s timeout
  return Response.json({ success: true, data });
}
```

## Best Practices

- Keep secrets only in Vercel env vars; `.env.example` documents names.
- Use pooled DB connections; keep the ORM client a singleton.
- Add `vercel.json` only when needed (headers, rewrites, cron).
- Cron jobs (recurring route reports) via `vercel.json` `crons`.
- Test production build locally (`next build`) before pushing.

## References

- Vercel docs: <https://vercel.com/docs>
- Vercel serverless limits: <https://vercel.com/docs/functions/limits>
- Neon pool + Vercel: <https://neon.tech/docs/guides/vercel>
- RouteOS SaaS spec — Documento 15 (Arquitetura do Projeto Next.js)
