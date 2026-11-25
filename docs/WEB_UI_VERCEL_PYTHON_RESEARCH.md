# Pesquisa — UI/SaaS acessível, JS/TypeScript na Vercel e Python moderno

**Data da verificação:** 2026-11-25
**Escopo:** repositórios, Agent Skills, design systems e fontes normativas para três eixos: (A) UI web/SaaS com foco em acessibilidade, intuitividade e beleza; (B) desenvolvimento JavaScript/TypeScript na Vercel; (C) desenvolvimento Python moderno.
**Método:** busca na web + leitura de páginas públicas do GitHub e documentação oficial. A API REST do GitHub retornou `403` (rate limit), então **stars são aproximados** e foram confirmados diretamente na página apenas onde marcado com ✅. Licenças foram confirmadas no arquivo `LICENSE`/página do repositório quando possível.
**Nenhum texto integral de upstream foi copiado.** A proposta é adaptar ideias, checklists e gates ao formato do kit.

---

## Resumo executivo

| Eixo | Fonte mais valiosa | Por quê |
|---|---|---|
| UI/SaaS | ✅ [plugin87/ux-ui-agent-skills](https://github.com/plugin87/ux-ui-agent-skills) — 3.2k★, MIT | 26 skills, tokens DTCG, WCAG 2.2 AA→AAA e **52 gates que falham o build**. É o único achado que mede o resultado em vez de só descrever boas intenções. |
| UI/SaaS | ✅ [radix-ui/primitives](https://github.com/radix-ui/primitives) + [shadcn-ui/ui](https://github.com/shadcn-ui/ui) | Comportamento acessível separado do estilo; composition sobre herança; padrão de copy-in já usado pelo kit. |
| Vercel/JS | ✅ [vercel/vercel-plugin](https://github.com/vercel/vercel-plugin) — 350★, Apache-2.0, suporte nativo a **OpenCode 2** | ~40 skills oficiais (env, deploy/rollback, functions, cache, auth, verificação, performance). Fonte primária e autoritativa. |
| Python | ✅ [astral-sh/uv](https://github.com/astral-sh/uv) — 92.6k★, Apache-2.0/MIT + [astral-sh/ruff](https://github.com/astral-sh/ruff), MIT | Substitui `venv + pip freeze + black` por lock determinístico, `pyproject.toml` e lint/format unificados. |

**Três lacunas concretas no kit hoje:** (1) `accessibility` para em WCAG 2.1 e não tem gates medíveis; (2) `vercel-deployment` não cobre cache/revalidate, Server Actions, env segura nem rollback; (3) `python-best-practices` recomenda um fluxo legado (`venv` + `pip freeze` + `black`).

---

## Parte A — UI/SaaS: acessibilidade, intuitividade e beleza

### A.1 Agent Skills e curadoria (licença verificada quando marcado)

| Repo | Stars | Licença | O que contém | Padrões para adaptar | Ressalva |
|---|---:|---|---|---|---|
| ✅ [plugin87/ux-ui-agent-skills](https://github.com/plugin87/ux-ui-agent-skills) | 3.2k | MIT | 26 skills, DTCG, 2.144 design systems, 52 gates, 34 com browser real | Gates falham o build; contraste renderizado claro/escuro por estado; target-size 2.5.8; token-por-intenção; `/critique` com subagente cego; `/observe` mede se o agente seguiu as regras | Gates exigem Node 20+ e Chrome; não vendore os 27.6 MB de specs |
| [podo/design-agent-skills](https://github.com/podo/design-agent-skills) | n/d | MIT informado | ~165 skills com roteadores por domínio e seções Accessibility/Quality | Roteador por domínio; catálogo com upstreams; gates de qualidade | Stars não confirmadas; pinar upstreams |
| [ibelick/ui-skills](https://github.com/ibelick/ui-skills) | n/d | MIT informado | Registry com CLI + MCP (`list_skills`, `get_skill`), `DESIGN.md` | Registry versionado; comando `get`; skill `baseline-ui` | Registry externo: pinar commit |
| [cuellarfr/design-skills](https://github.com/cuellarfr/design-skills) | n/d | MIT informado | Design critique, auditoria WCAG 2.2 em 5 camadas, journey mapping | Crítica de design; auditoria em camadas; regras para UI gerada por IA | Exigir revisão humana |
| [divyanshu-iitian/agent-website-design-skills](https://github.com/divyanshu-iitian/agent-website-design-skills) | n/d | MIT informado | Verificação no browser, responsive QA, a11y, *ethical conversion* | Validar no browser; QA responsivo; anti-dark-patterns | — |
| [dequelabs/axe-accessibility](https://github.com/dequelabs/axe-accessibility) | ~3 | MIT informado | Toolkit Deque para coding agents | Skill de a11y para agente; explicar violações | Projeto muito novo; usar `axe-core` como base técnica |
| [plugin87/full-stack-design-skills](https://github.com/plugin87/full-stack-design-skills) | ~10 | MIT informado | 15 skills com exemplos Tailwind/Material 3/Bootstrap 5 | Exemplos multi-stack; AA+; light/dark | Stars baixas, confirmar manutenção |
| ⚠️ [zhuyansen/awesome-claude-design-skills](https://github.com/zhuyansen/awesome-claude-design-skills) | n/d | n/d | ~207 repos, lista "security-graded" | Taxonomia e grade de segurança | Números de stars citados (93k/134k) **não confirmados** — não replicar |
| ⚠️ [Owl-Listener/inclusive-design-skills](https://github.com/Owl-Listener/inclusive-design-skills) | n/d | n/d | 40 skills / 18 commands, foco pré-código | Inclusão antes de escrever UI; conteúdo inclusivo | Licença não verificada |

### A.2 Componentes e design systems

| Repo | Stars | Licença | Padrões para adaptar | Ressalva |
|---|---:|---|---|---|
| [shadcn-ui/ui](https://github.com/shadcn-ui/ui) | ~129k | MIT | Pasta `skills/`; `npx shadcn search` antes de criar UI; `npx shadcn info --json`; composição Tabs+Card+form; `DESIGN.md` como contrato | Registries de terceiros exigem revisão |
| [radix-ui/primitives](https://github.com/radix-ui/primitives) | ~19–20k | MIT | Separar comportamento de estilo; foco/teclado corretos; `data-state`; composição | — |
| [tailwindlabs/tailwindcss](https://github.com/tailwindlabs/tailwindcss) | ~92k | MIT | Escalas de spacing/cor; variantes responsivas; tokens CSS; `@theme` | — |
| [chakra-ui/chakra-ui](https://github.com/chakra-ui/chakra-ui) | ~41k | MIT | `skills/`, recipes, tokens semânticos, estados de componente, dark mode | — |
| [mantinedev/mantine](https://github.com/mantinedev/mantine) | ~32k | MIT | Hooks reutilizáveis; `@mantine/form`; notificações acessíveis | — |
| [ant-design/ant-design](https://github.com/ant-design/ant-design) | ~100k | MIT | `DESIGN.md`/`CLAUDE.md`; tabelas e forms enterprise; i18n | — |
| [mui/material-ui](https://github.com/mui/material-ui) | ~96k | MIT | `.agents/skills/`; theming; forms/grid; docs para agentes | MUI X é separado/comercial |
| [primer/react](https://github.com/primer/react) | ~3.9k | MIT | `.agents/skills/` + `.mcp.json`; componentes tipados; temas; testes E2E | — |
| [saadeghi/daisyui](https://github.com/saadeghi/daisyui) | ~42.9k | MIT | Classes semânticas (`btn`, `card`); 35 temas; OKLCH; Micro CSS | — |
| [unocss/unocss](https://github.com/unocss/unocss) | ~19k | MIT | Presets, shortcuts, attributify, tokens por tema | — |
| [carbon-design-system/carbon](https://github.com/carbon-design-system/carbon) | ~9.5k | Apache-2.0 | Tokens de cor/tipografia/motion; temas; data tables; `AGENTS.md` | `@carbon/react` usa IBM Telemetry com opt-out |
| ⚠️ [twbs/bootstrap](https://github.com/twbs/bootstrap) | ~175k | MIT | Mobile-first; grid; variáveis Sass | Default branch é Bootstrap 6 alpha |
| ⚠️ [Shopify/polaris-react-archive](https://github.com/Shopify/polaris-react-archive) | ~6.2k | custom MIT-like | `variant` vs `tone`; padrões de admin | Uso restrito a apps Shopify; React deprecado |
| ⚠️ [material-components/material-components-web](https://github.com/material-components/material-components-web) | ~17k | MIT no repo / Apache-2.0 no npm | Componentes modulares; Sass tokens | **Arquivado** e com divergência de licença |
| ⚠️ [material-components/material-web](https://github.com/material-components/material-web) | ~11.5k | Apache-2.0 | Web Components, Material 3, tokens | Maintenance mode |

### A.3 Tokens, tipografia e validação automatizada

| Fonte | Stars | Licença | Padrões para adaptar | Ressalva |
|---|---:|---|---|---|
| [primer/primitives](https://github.com/primer/primitives) | n/d | MIT | Tokens JSON → CSS vars; tema colorblind; workflow `a11y-contrast` no CI | — |
| [tokens-studio/sd-transforms](https://github.com/tokens-studio/sd-transforms) | n/d | MIT | Aliases; temas/modos; pipeline transform; saída CSS/TS | — |
| [vercel/geist-font](https://github.com/vercel/geist-font) | n/d | OFL-1.1 | Família + mono; variable fonts; import por entry point | OFL: não vender a fonte isolada; nomes reservados |
| [system-ui/theme-ui](https://github.com/system-ui/theme-ui) | ~5.4k | MIT | Escalas; arrays responsivos; color modes | Branch default `develop` |
| [dequelabs/axe-core](https://github.com/dequelabs/axe-core) | ~7.9k | MPL-2.0 | Gate de CI; integração Playwright/Jest; severidades; baseline | MPL é copyleft por arquivo; regra 2.5.8 é opt-in |
| [GoogleChrome/lighthouse](https://github.com/GoogleChrome/lighthouse) | ~31k | Apache-2.0 | Score budget; JSON/HTML; Lighthouse CI; PR checks | Usa subconjunto das regras axe — não prova conformidade |
| [testing-library/react-testing-library](https://github.com/testing-library/react-testing-library) | ~19.7k | MIT | Queries por papel/nome; `user-event`; não testar detalhes internos | Combinar com axe |
| ⚠️ [pa11y/pa11y](https://github.com/pa11y/pa11y) | ~4.6k | LGPL-3.0-only | CLI simples; thresholds no CI; runners combinados | Cobertura WCAG 2.2 limitada |
| [ally.js](https://allyjs.io/) | n/d | MIT | Tabbable; focus trap; `inert`; origem do foco | Não torna a app acessível sozinho |

### A.4 Fontes normativas

| Fonte | Uso no kit |
|---|---|
| [WCAG 2.2 Quickref](https://www.w3.org/WAI/WCAG22/quickref) | Critérios A/AA/AAA — especialmente 2.4.11 (foco não oculto), 2.4.13 (aparência do foco, AAA), 2.5.8 (alvo mínimo), 3.2.6 (ajuda consistente), 3.3.7 (entrada redundante), 3.3.8 (autenticação acessível) |
| [WAI-ARIA APG — keyboard interface](https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface) | Tab/Shift+Tab; setas em composites; Escape em overlays; roles/states coerentes. ARIA não substitui HTML semântico |
| [EN 301 549 v3.2.1](https://www.etsi.org/deliver/etsi_en/301500_301599/301549/03.02.01_60/en_301549v030201p.pdf) | Requisitos europeus de acessibilidade para ICT; documentação de conformidade |
| [NN/g — 10 Usability Heuristics](https://www.nngroup.com/articles/ten-usability-heuristics) | Visibilidade do estado; feedback; prevenir erros; reconhecer em vez de lembrar |
| [ISO 9241-210:2019](https://www.iso.org/standard/77520.html) | Design centrado no humano — contexto, requisitos, iteração, avaliação (norma paga) |
| [USWDS Maturity Model](https://designsystem.digital.gov/maturity-model) | Adoção incremental de design system |
| [W3C Design Tokens Format](https://design-tokens.github.io/community-group/format) | `$value`/`$type`, aliases, modos — draft da Community Group, não Recommendation |
| [WebAIM WCAG 2 Checklist](https://webaim.org/standards/wcag/checklist) + [Inclusive Components](https://inclusive-components.design/) + [Adrian Roselli](https://adrianroselli.com/) + [Sara Soueidan](https://www.sara.codes/) | Checklists práticos e testes manuais (não são norma) |

### A.5 O que caracteriza "beleza" de forma verificável

O repositório `plugin87/ux-ui-agent-skills` é explícito: **correção ≠ qualidade**. Gates medem contraste, tamanho de alvo, responsividade e tokens; um *design critic* separado julga hierarquia, ponto focal, estados de vazio/carregamento e microcopy. Anti-padrões que o gate detecta e o kit deveria proibir:

- gradiente índigo→roxo genérico; quatro cards iguais sem ponto focal; emoji como ícone;
- um único raio/shadow para tudo; texto cinza sobre branco; botão destrutivo com cor primária;
- heading `24px` sobre corpo `14px` (escala sem propósito); valores hardcoded fora dos tokens;
- *loading* com opacidade de *disabled* (parece "você não pode fazer isso"); *toast* que afirma criou algo sem mudar a lista.

**Intuitividade (NN/g aplicado a SaaS):** visibilidade do estado, correspondência sistema↔mundo, liberdade com *undo*, consistência, prevenção de erro, reconhecer em vez de lembrar, atalhos, flexibilidade, estética minimalista, ajuda contextual.

---

## Parte B — JavaScript/TypeScript na Vercel

### B.1 Fonte primária: ✅ `vercel/vercel-plugin` (350★, Apache-2.0)

Oficial, mantido pela Vercel, **suporta OpenCode 2 nativamente** (`opencode plugin add github:vercel/vercel-plugin`). Contém grafo de conhecimento (`vercel.md`), ~40 skills, 3 agents, 4 comandos e MCP. Skills mais relevantes para o kit:

| Skill | Padrão adaptável |
|---|---|
| `env-vars` | `vercel link` → `vercel env pull`; **nunca** `vercel env add --value` (vaza no history); valor via stdin; `NEXT_PUBLIC_` só para dados públicos |
| `deployments-cicd` | PR → preview → checks → `vercel promote` / `vercel rollback`; `--prebuilt` no CI; promover com vars de Production pode rebuildar |
| `vercel-functions` | Preferir Node.js; `maxDuration`, payload <4.5 MB, memória/bundle; Fluid Compute |
| `verification` | História → browser → API → dados → resposta; não dar deploy como pronto sem verificar ponta a ponta |
| `react-best-practices` | 64 regras em 8 categorias de performance React/Next |
| `cdn-caching` / `runtime-cache` | Diagnóstico de hit rate, stale, revalidação, custo de ISR; cache regional com tags |
| `routing-middleware` | Interceptação antes do cache; rewrites/redirects/personalização; runtimes |
| `auth` / `client-side-security` | Provedores (Clerk, Better Auth, Descope, Auth0); CSP e Page Integrity |
| `custom-metrics` / `vercel-tracing` / observabilidade | Métricas de negócio sem PII; correlação trace↔log |

⚠️ **Telemetria ligada por padrão** no plugin (`VERCEL_PLUGIN_TELEMETRY=off` desliga). Antes de instalar em ambiente de time, avaliar política de privacidade. As skills injetadas são apenas do próprio plugin; ainda assim, há coleta de eventos de uso.

### B.2 Outros repos oficiais

| Repo | Stars | Licença | Padrões para adaptar | Ressalva |
|---|---:|---|---|---|
| ✅ [vercel/next.js](https://github.com/vercel/next.js) | ~144k | MIT | `skills/` e `.agents/skills/`; **modo audit por padrão**, fix só mediante pedido; pré-condições explícitas (ex.: "sem `app/`, pare"); resolver erros pelos fix cards do dev overlay | Não confiar em memória do modelo: ler docs da versão instalada |
| ✅ [vercel/ai](https://github.com/vercel/ai) | ~28k | Apache-2.0 | `skills/` (11); "do not trust your own memory"; `streamText`, `useChat`, migrations versionadas | Node.js 22+; API muda rápido — fixar versões |
| ✅ [vercel/turborepo](https://github.com/vercel/turborepo) | ~31k | MIT | Ler `node_modules/turbo/docs`; cache por task com `inputs`/`env` explícitos; `--filter` no CI | Não colocar segredos em chaves de cache |
| [vercel/swr](https://github.com/vercel/swr) | ~32k | MIT | SWR só para dados client mutáveis; mutation otimista com rollback; dedupe | Cache client ≠ cache servidor/CDN |
| [vercel/examples](https://github.com/vercel/examples) | ~5.2k | MIT | `.agents/skills/web-design-guidelines`; todo exemplo com `.env.example` e demo URL | Alguns exemplos usam padrões antigos |
| [vercel/vercel](https://github.com/vercel/vercel) | ~17k | Apache-2.0 | `vercel inspect <url> --json`; `vercel build --prod` + `--prebuilt`; `vercel logs requests --json` | Documentar versão da CLI |
| [vercel/speed-insights](https://github.com/vercel/speed-insights) | ~115 | MIT | Gate p75: LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1; segmentar mobile/desktop | Lab ≠ field (CrUX/RUM) |
| [vercel/flags](https://github.com/vercel/flags) | ~631 | MIT | Default seguro se SDK falhar; avaliação no servidor; não vazar targeting | `vercel/flags-sdk` não existe como repo |
| [vercel/next-forge](https://github.com/vercel/next-forge) | ~7.8k | MIT | Starter production-grade (auth, DB, pagamentos, observabilidade) | Opinativo |

### B.3 Ecossistema complementar

| Repo | Stars | Licença | Padrões para adaptar | Ressalva |
|---|---:|---|---|---|
| [supabase/supabase](https://github.com/supabase/supabase) | ~115k | Apache-2.0 | **RLS obrigatório**; `service_role` apenas no servidor; pooling para serverless | Nunca expor chave de serviço via `NEXT_PUBLIC_` |
| [prisma/prisma](https://github.com/prisma/prisma) | ~48k | Apache-2.0 | Migrations versionadas; tenant scoping; pooling; generated client no build | Cold starts |
| [stripe/stripe-node](https://github.com/stripe/stripe-node) | ~4.6k | MIT | `constructEvent` com **raw body**; `Stripe-Signature`; tolerância 5 min; idempotência; 2xx rápido | Preço calculado no servidor; `tolerance: 0` desliga checagem de replay |
| [colinhacks/zod](https://github.com/colinhacks/zod) | ~44k | MIT | Schema compartilhado API/UI; validar payload em Route Handler/Action | — |
| [better-auth/better-auth](https://github.com/better-auth/better-auth) | ~31k | MIT | `auth()` no servidor; sessão verificada no DAL; cookies SameSite/secure | — |
| [amannn/next-intl](https://github.com/amannn/next-intl) | ~4.4k | MIT | `app/[lang]`; `<html lang>`; negociação `Accept-Language`; `generateStaticParams` | — |
| [GoogleChrome/web-vitals](https://github.com/GoogleChrome/web-vitals) | ~8.7k | Apache-2.0 | Coleta de LCP/INP/CLS no cliente | — |
| ⚠️ [anthropics/skills](https://github.com/anthropics/skills) | ~alta | **licença mista** (Apache-2.0 e Proprietary por skill) | Formato de `SKILL.md` | Não copiar skill sem `LICENSE.txt` autorizando |
| ⚠️ [goldbergyoni/nodebestpractices](https://github.com/goldbergyoni/nodebestpractices) | ~106k | CC-BY-SA-4.0 | Componentes por domínio; erros centralizados; limitar concorrência | Atribuição + ShareAlike se adaptar texto |
| ⚠️ [formatjs/formatjs](https://github.com/formatjs/formatjs) | ~15k | não identificada | Base de i18n/Intl | Verificar licença por pacote |

Repos citados na pesquisa bruta e **não localizados** — não incluir sem confirmação: `unkey/unkey`, `clerkinc/clerk`, `vercel/flags-sdk`, `vercel/functions`, `vercel/og`, `testing-library/react`, `vercel/remote-patterns`.

### B.4 Checklist de alto valor (fonte: docs oficiais + OWASP)

| Tema | Regra | Armadilha |
|---|---|---|
| RSC vs Client | Decidir pela fronteira de dados/interatividade; `'use client'` no menor escopo; props serializáveis; `server-only` em módulos sensíveis | `server-only` não impede o servidor de **retornar** dado sensível explicitamente |
| Cache/revalidação | `updateTag` para read-your-own-writes (Server Actions); `revalidateTag(tag, 'max')` para SWR; `revalidatePath` por URL | Tags case-sensitive, ≤256 chars; sem 2º argumento é deprecated |
| Cache Components | `cacheComponents: true` + `partialPrefetching`; `use cache`, `cacheLife`, `cacheTag` | Requer Node.js; não aceita `runtime` segment config |
| Hidratação | Render determinístico; mover `window`/`localStorage`/`Date()`/`Math.random()` para `useEffect` | `suppressHydrationWarning` não corrige texto; rewrites + `usePathname()` geram mismatch |
| Edge/Proxy | Preferir Node.js; proxy para redirects/filtros; Edge só em legado | `runtime='edge'` e `middleware.ts` **deprecados no Next.js 16** — confirmar na versão instalada |
| Env/segredos | `.env.example` versionado; `.env.local` gitignored; `vercel link` + `vercel env pull`; via stdin | Limites: 1000 vars/ambiente, 64 KB/deploy; segredo em `NEXT_PUBLIC_` vai para o bundle |
| Auth | Autorização **perto da fonte de dados (DAL)**, não só no Layout/Proxy; 401/403 em Actions e Route Handlers | Partial Rendering renderiza partes fora do Layout |
| Route Handlers/Actions | Zod; timeouts; rate limit 429; não chamar Route Handler de Server Component | `Cache-Control: public` em resposta personalizada |
| Stripe | Checkout no servidor; webhook com raw body; idempotência; 2xx rápido | Body parseado quebra assinatura |
| XSS/CSRF | Escape por contexto; `DOMPurify.sanitize`; allowlist de URL; SameSite + checagem `Origin` | `dangerouslySetInnerHTML` sem sanitização; CSP/WAF como defesa única |
| Versões | Exigir patch mínimo (advisory SSRF em Server Actions em Next.js < 14.1.1) | Exemplos antigos reproduzem padrões deprecados |

**Fontes autoritativas:** [Next.js Docs (llms.txt)](https://nextjs.org/docs/llms.txt), [Vercel Docs](https://vercel.com/docs), [Agent Skills Spec](https://agentskills.io/specification), [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/), [NIST CSF 2.0](https://www.nist.gov/cyberframework/framework), [MDN](https://developer.mozilla.org/), [Web Vitals](https://web.dev/articles/vitals).

---

## Parte C — Python moderno

### C.1 Stack recomendada (consenso dos repos abaixo)

| Camada | Escolha | Motivo |
|---|---|---|
| Ambiente/deps | ✅ `uv` + `pyproject.toml` (PEP 621) | lock determinístico, ambiente rápido, padronização |
| Qualidade | `ruff` (lint+format) + `mypy --strict` **ou** `pyright strict` | uma única esteira |
| API | FastAPI + Pydantic v2 | validação, DI, async, OpenAPI |
| Persistência | SQLAlchemy 2.0 + Alembic | ORM tipado + migrações revisáveis |
| Testes | pytest + coverage + Hypothesis (quando fizer sentido) | fixtures, parametrização, property-based |
| Segurança | Bandit + pip-audit + Trivy + SBOM/OIDC | AST, CVEs, supply chain, publicação sem token |
| Observabilidade | OpenTelemetry ou Logfire | traces correlacionados a logs |

### C.2 Repos por camada

| Camada | Repo | Stars | Licença | Padrões para adaptar |
|---|---|---:|---|---|
| Spec | ✅ [agentskills/agentskills](https://github.com/agentskills/agentskills) | ~28k | Apache-2.0 | `SKILL.md` ≤500 linhas; validar no CI; `allowed-tools` é experimental |
| Núcleo | [python/cpython](https://github.com/python/cpython) | ~78k | PSF-2 | `pathlib`, `dataclasses(slots=True)`, `contextvars`, `asyncio.TaskGroup` |
| Tipagem | [python/mypy](https://github.com/python/mypy) | ~21k | MIT | `strict = true`; `disallow_untyped_defs`; `# type: ignore[código]` |
| Tipagem | [microsoft/pyright](https://github.com/microsoft/pyright) | ~16k | MIT | `typeCheckingMode = "strict"`; `reportMissingImports` |
| Lint | ✅ [astral-sh/ruff](https://github.com/astral-sh/ruff) | ~52k | MIT | `select = ["E","F","I","UP","B","SIM","ASYNC","S"]`; `ruff format --check`; evitar `# noqa` amplo |
| Ambiente | ✅ [astral-sh/uv](https://github.com/astral-sh/uv) | 92.6k ✅ | Apache-2.0/MIT | `uv init/add/sync --frozen/run`; `.python-version`; lock universal; instalar via `pip install uv` em vez de `curl \| sh` |
| Empacotamento | [pypa/sampleproject](https://github.com/pypa/sampleproject) | ~5.2k | MIT | Layout `src/`; `pyproject.toml` completo; `tests/` |
| Build/publish | [pypa/build](https://github.com/pypa/build) · [pypa/twine](https://github.com/pypa/twine) | ~864 / ~1.8k | MIT / Apache-2.0 | `python -m build`; `twine check dist/*`; trusted publishing OIDC |
| Web | [fastapi/fastapi](https://github.com/fastapi/fastapi) | ~105k | MIT | lifespan com `asynccontextmanager`; `APIRouter(dependencies=[...])`; `response_model` |
| Template | [fastapi/full-stack-fastapi-template](https://github.com/fastapi/full-stack-fastapi-template) | ~46k | MIT | Separar `schemas/` Pydantic de `models/`; `get_db` com `yield`/`finally`; config via `pydantic-settings` |
| Validação | [pydantic/pydantic](https://github.com/pydantic/pydantic) | ~30k | MIT | `ConfigDict(strict=True, extra="forbid")`; `Field(gt=0)`; `field_validator` |
| ORM | [sqlalchemy/sqlalchemy](https://github.com/sqlalchemy/sqlalchemy) · [sqlalchemy/alembic](https://github.com/sqlalchemy/alembic) | ~12k / ~4.5k | MIT | `DeclarativeBase` + `Mapped`; `select()`; `pool_pre_ping`; naming convention; batch mode SQLite |
| Testes | [pytest-dev/pytest](https://github.com/pytest-dev/pytest) · [nedbat/coveragepy](https://github.com/nedbat/coveragepy) | ~15k / ~3.4k | MIT / Apache-2.0 | `addopts = "-ra --strict-markers"`; `tmp_path`; `--cov-fail-under` |
| Testes prop | ⚠️ [HypothesisWorks/hypothesis](https://github.com/HypothesisWorks/hypothesis) | ~9.2k | MPL-2.0 | `@given`; `st.builds`; shrinking — cuidado ao redistribuir/modificar |
| Segurança | [PyCQA/bandit](https://github.com/PyCQA/bandit) | ~8.4k | Apache-2.0 | `bandit -r app -ll -f json`; `# nosec Bxxx` justificado |
| Segurança | [pypa/pip-audit](https://github.com/pypa/pip-audit) · [aquasecurity/trivy](https://github.com/aquasecurity/trivy) | ~1.4k / ~40k | Apache-2.0 | `--strict` no CI; `--severity HIGH,CRITICAL --exit-code 1` |
| Supply chain | [sigstore/sigstore-python](https://github.com/sigstore/sigstore-python) · [pypa/gh-action-pypi-publish](https://github.com/pypa/gh-action-pypi-publish) | ~341 / ~1.2k | Apache-2.0 / BSD-3 | assinatura keyless via OIDC; `permissions: id-token: write`; ambiente protegido |
| CI | [actions/setup-python](https://github.com/actions/setup-python) · [astral-sh/setup-uv](https://github.com/astral-sh/setup-uv) | ~2.3k / ~919 | MIT | `python-version-file`; `cache: 'uv'`; `uv sync --frozen`; pin por SHA |
| Obs. | [open-telemetry/opentelemetry-python](https://github.com/open-telemetry/opentelemetry-python) | ~2.7k | Apache-2.0 | `BatchSpanProcessor`; OTLP; `service.name`; sampling |

### C.3 Padrões inseguros a proibir em regras do kit

`verify=False` · `shell=True` · `pickle` em filas/Celery · `trust_remote_code=True` · `assert` para autorização · `np.load(allow_pickle=True)` com dados não confiáveis · `torch.load` sem `weights_only=True` · tokens/chaves em texto · `pip install` sem pin/hash · `OAuth2PasswordBearer` tratado como validação de token · `@app.on_event` legado · editar revisão Alembic já aplicada · ajustar preprocessing fora do fold de treino.

⚠️ **Licenças que exigem cuidado:** `anthropics/skills` (mista), [OWASP/CheatSheetSeries](https://github.com/OWASP/CheatSheetSeries) (CC-BY-SA-4.0 — atribuição), [pypa/advisory-database](https://github.com/pypa/advisory-database) (CC-BY-4.0 — atribuição), `Hypothesis` (MPL-2.0), `hugapi/hug` e `ebranca/owasp-pysec` (manutenção reduzida — referência histórica, não dependência padrão). Correções de nomes: `hugapi/hug` (não `cnpryer/hug`), `pola-rs/polars` (não `polars-labs/polars`), `HypothesisWorks/hypothesis` (não `hypothesis/hypothesis`).

**Fontes normativas:** PEP 8/484/517/621, [spec canônica `pyproject.toml`](https://packaging.python.org/en/latest/specifications/pyproject-toml/), docs de Python/FastAPI/Pydantic/SQLAlchemy/Alembic/pytest, OWASP FastAPI/Supply Chain/SBOM/AI Agent cheat sheets, Agent Skills spec.

---

## Parte D — Auditoria do kit e lacunas

| Área | Ativos atuais | Lacuna confirmada na leitura |
|---|---|---|
| Acessibilidade | `frontend/accessibility` (206 linhas) | Para em WCAG 2.1 básico; sem WCAG 2.2, APG por widget, axe/Lighthouse, testes manuais, reduced motion, gate de CI. Exemplo de ARIA usa `role="menu"` para links de navegação — padrão discutível segundo APG. |
| UI/UX | `design/ui-ux-design`, `design/design-system`, `frontend/shadcn-ui`, `frontend/css-best-practices` | Bons princípios de SaaS, mas "beleza" não é verificável: não há escala tipográfica/ritmo, critérios de "anti-slop", nem *design critic*. Sem gate que meça contraste renderizado. |
| Vercel | `devops/vercel-deployment`, `frontend/nextjs-development` | Cobre setup/env/limites básicos; **não cobre** cache/revalidate, Cache Components, Server Actions, RSC boundary, hidratação, proxy vs edge, rollback/promote, Web Vitals como gate. `vercel-deployment` ainda cita limites antigos (Hobby ~10s / Pro ~60s) que divergem da docs atual — revisar. |
| JS/TS | `languages/javascript-best-practices`, `typescript-best-practices`, `frontend/react-patterns`, `state-management`, `tanstack-query` | Cobertura razoável; falta gate de segurança Next.js (XSS/CSRF/DAL) e validação de payload em Actions. |
| Python | `languages/python-best-practices`, `testing/python-testing`, `backend/fastapi-development`, `database/sqlalchemy-alembic` | `python-best-practices` recomenda `venv + pip freeze > requirements.txt + black`; não cobre `uv`, PEP 621, lockfile, `ruff format`, Bandit/pip-audit/SBOM nem CI com trusted publishing. |

---

## Parte E — Proposta de implementação (executada em 2026-11-25)

### Prioridade 0 — maior ganho

| Ativo | Tipo | Escopo | Fontes primárias |
|---|---|---|---|
| `a11y-audit` | skill `frontend` | WCAG 2.2 AA/AAA, APG por widget, axe-core + Lighthouse + teste manual de teclado/leitor de tela, reduced motion, target size, gate em CI, relatório priorizado P0/P1/P2 | WCAG 2.2, APG, axe-core, Lighthouse, plugin87, WebAIM |
| `vercel-runtime-and-cache` | skill `devops` | RSC vs Client, cache/revalidate/Cache Components, Server Actions, proxy vs edge, timeouts/payload, env segura, promote/rollback, verificação ponta a ponta | `vercel/vercel-plugin`, `vercel/next.js`, docs oficiais |
| `python-modern-tooling` | skill `languages` | `uv` + `pyproject.toml` PEP 621, lock, ruff, mypy/pyright, pytest, Bandit/pip-audit, CI OIDC, anti-padrões | `uv`, `ruff`, PEPs, OWASP, sigstore |

### Prioridade 1

| Ativo | Tipo | Escopo |
|---|---|---|
| `ui-visual-craft` | skill `design` | Escala tipográfica, ritmo de espaçamento, cor semântica/OKLCH, profundidade, motion com `prefers-reduced-motion`, anti-slop, light/dark, checklist de "beleza verificável" |
| `design-review-critic` | skill + agente `design` | Crítica independente com capturas em 1280/390, veredicto de rework, achados com evidência; separar "correto" de "bom" |
| `nextjs-web-security` | skill `security` | XSS/CSRF, sanitização, DAL/auth, webhooks Stripe, segredos `NEXT_PUBLIC_`, CSP defensiva |
| `design-tokens-pipeline` | skill `design` | DTCG `$value`/`$type`, aliases, temas/modos, transform para CSS/TS, validação de contraste no CI |

### Prioridade 2 — atualizações in-place

- Reescrever `frontend/accessibility` para WCAG 2.2 e corrigir o exemplo de `role="menu"`.
- Atualizar `python-best-practices` para `uv` + `ruff`, mantendo `venv/pip` como legado.
- Atualizar `devops/vercel-deployment` com limites atuais, cache, promote/rollback e telemetria do plugin.
- Ampliar `frontend/shadcn-ui` com `npx shadcn search/info --json` e gate de `shadcn-ui/lint`.
- Atualizar agents `frontend-developer`, `ui-designer`, `nextjs-developer`, `javascript-developer`, `fullstack-developer`, `backend-developer` e `qa-engineer` para referenciarem as novas skills.

Todos os ativos novos seguem o padrão já usado na letra de psicologia: `beta`, `v0.1.0`, `provenance` declarada, `compatible: [opencode, claude-code, cursor]`, evals de segurança e atualização de índices/manifesto/README.

---

## Parte F — O que deliberadamente **não** adotar

- **Dark patterns:** escassez falsa, confirmação constrangedora, opt-in pré-marcado, cancelamento difícil, contagem regressiva artificial. Rejeitar também monitoramento de consentimento invasivo.
- **UI gerada por IA sem revisão:** nunca publicar direto do agente; exigir gates + teste de teclado/leitor de tela + revisão humana.
- **Padrões deprecados/inseguros:** `runtime='edge'` e `middleware.ts` no Next.js 16 (confirmar na versão instalada), `revalidateTag` sem 2º argumento, `vercel env add --value`, `dangerouslySetInnerHTML` sem sanitização, `Cache-Control: public` em dado privado.
- **Texto de licenças ambíguas/restritivas:** `anthropics/skills` mista, `nodebestpractices` CC-BY-SA, OWASP CC-BY-SA, `pa11y` LGPL, `axe-core` MPL (copyleft por arquivo), Polaris custom, MUI X comercial, `material-components-web` com licença divergente. Adaptar ideias, nunca copiar trechos longos.
- **Números não verificados:** as listas com stars inflados e repos "not found" relacionados na Parte B não devem entrar no `docs/APRENDA_REPOSITORIOS.md` sem confirmação.
- **Telemetria involuntária:** desligar `VERCEL_PLUGIN_TELEMETRY=off` se o plugin for instalado; o `@carbon/react` tem telemetria com opt-out.
