---
provenance:
  source: "OpenCode Engineering Kit (community) — padrões adaptados de vercel/vercel-plugin, vercel/next.js, Vercel Docs, Next.js Docs e OWASP Cheat Sheet Series"
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: vercel-runtime-and-cache
description: Runtime, cache e verificação de apps Next.js na Vercel — RSC, revalidação, Cache Components, limites de Functions e Web Vitals
category: devops
version: 0.1.0
author: devtiagoabreu
tags: [vercel, nextjs, rsc, cache, revalidate, functions, web-vitals]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Projeto Next.js conectado a uma conta ou equipe da Vercel
  - CLI `vercel` autenticada para variáveis, promoção e rollback
  - Acesso aos docs da versão instalada em `node_modules/next/dist/docs`
provides:
  - Critérios para a fronteira Server Component/Client Component
  - Regras de cache, revalidação e Cache Components
  - Limites de Functions, ambiente seguro e pipeline preview → promote → rollback
  - Checklist de verificação ponta a ponta e metas de Web Vitals
security:
  risk_level: low
  permissions:
    - shell
    - network
  audited: true
---

# Runtime e Cache na Vercel

## Overview

Esta skill cobre as decisões de runtime e cache que fazem um app Next.js na
Vercel ser rápido, correto e verificável. Ela liga quatro camadas: a fronteira
entre Server Components e Client Components, a invalidação de dados, os limites
de Functions e a prova de que a mudança funciona no browser, na API e nos dados.
As regras são adaptadas das skills oficiais de `vercel/vercel-plugin` e
`vercel/next.js`, sem copiar texto upstream. Nenhuma API é tratada como estável:
confirme na versão instalada antes de aplicar. Para autorização e ameaças, use
[segurança Next.js](../../security/nextjs-web-security/SKILL.md).

## Prerequisites

- Projeto com `app/`, build reproduzível (`next build`) e repositório conectado.
- CLI `vercel` autenticada na conta ou equipe correta (`vercel whoami`).
- **Docs versionadas:** leia `node_modules/next/dist/docs` e a versão da CLI
  instalada em vez de confiar na memória do modelo. Onde esta skill diz
  "confirme na versão instalada", pare e verifique antes de editar.
- Metas de desempenho e limites variam por plano, região e versão: meça no
  deployment real, não em valores decorados.

## Usage Instructions

### 1. Decida a fronteira server/client primeiro

Use Server Component por padrão para dados, segredos e lógica de negócio.
Adicione `'use client'` apenas no menor escopo que precisa de estado, efeito ou
evento do browser. Props que cruzam a fronteira precisam ser serializáveis:
strings, números, booleanos, arrays, objetos simples e elementos React. Funções
só cruzam quando são Server Actions; evite classes, símbolos, promises e
instâncias de bibliotecas.

```ts
// lib/server-data.ts
import "server-only";
import { taintObjectReference, taintUniqueValue } from "react";

export function loadPrivateConfig() {
  const config = { token: process.env.PRIVATE_API_TOKEN ?? "" };
  taintObjectReference("Config privada não deve cruzar para o client", config);
  taintUniqueValue("Token privado", config, config.token);
  return config;
}
```

`server-only` impede a importação acidental em código client; as APIs `taint`
são experimentais em algumas versões — confirme na versão instalada. Nenhuma das
duas impede que o próprio servidor **retorne explicitamente** o dado sensível a
um componente client: não passe o objeto inteiro como prop.

### 2. Invalide cache pelo motivo certo

| API | Uso típico | Ressalva |
|---|---|---|
| `updateTag(tag)` | Server Action que escreve e precisa de read-your-own-writes | Chamada no contexto da ação; confirme a assinatura na versão instalada |
| `revalidateTag(tag,'max')` | Dados compartilhados com SWR | Sem o segundo argumento a forma antiga é deprecada — confirme na versão instalada |
| `revalidatePath("/rota")` | Invalidação por URL quando não há tag estável | Prefira tags para dados reutilizados em várias rotas |

Tags são **case-sensitive**, com limite **≤256 caracteres**. Normalize a
construção da tag numa única função para não criar variantes acidentais.

```ts
"use server";

import { revalidatePath, revalidateTag, updateTag } from "next/cache";

const tagCliente = (id: string) => `cliente:${id}`; // minúsculas, estável, curta

export async function salvarCliente(id: string) {
  // autorizar no DAL, gravar, depois invalidar
  updateTag(tagCliente(id));
  revalidateTag("clientes", "max");
  revalidatePath("/clientes");
}
```

### 3. Cache Components quando o limite precisa ser explícito

Cache Components deslocam a decisão de cache para o código: `'use cache'`
delimita o que pode ser cacheado, `cacheLife` define a frescura e `cacheTag`
liga o trecho às invalidações. Habilite `cacheComponents` (e verifique onde
`partialPrefetching` fica na sua versão) e lembre que esse modo exige runtime
Node.js e não aceita certas configurações de segmento como `runtime = "edge"`
— confirme na versão instalada.

```ts
// next.config.ts — confirme as chaves na versão instalada
const nextConfig = {
  cacheComponents: true,
  partialPrefetching: true,
};
export default nextConfig;
```

```ts
async function carregarCatalogo() {
  "use cache";
  cacheLife("hours");
  cacheTag("catalogo");
  return queryCatalogo(); // chamada ao servidor de dados, não a um Route Handler
}
```

`partialPrefetching` reduz trabalho de prefetch em rotas com muito conteúdo
estático, desde que os fallbacks sejam determinísticos. Cache de servidor,
cache de CDN e cache do browser são camadas diferentes: não use um para
explicar o comportamento do outro.

### 4. Stream com Suspense e fallback determinístico

Envolva trechos lentos em `Suspense` com um fallback de tamanho fixo. O fallback
deve ser igual no servidor e no cliente: sem `Date()`, `Math.random()`,
`localStorage`, preferência do usuário ou texto específico de tenant. Reservar
dimensões evita CLS quando o conteúdo chega. Streaming não substitui
autorização: faça a checagem antes de iniciar a consulta que será transmitida.

```tsx
import { Suspense } from "react";

export default function Relatorios() {
  return (
    <section>
      <h1>Relatórios</h1>
      <Suspense fallback={<div className="h-64 w-full animate-pulse rounded" />}>
        <GraficoMensal />
      </Suspense>
    </section>
  );
}
```

### 5. Hidratação determinística

- Renderize o mesmo HTML no servidor e na primeira passagem do cliente.
- Mova `window`, `document`, `localStorage` e leitura de cookie para `useEffect`
  ou para o servidor.
- Gerze horários, números aleatórios e formatação dependente de locale no
  servidor ou depois da montagem; passe o resultado como prop.
- `suppressHydrationWarning` não corrige texto divergente: corrija a origem.
- Rewrites combinados com `usePathname()` podem gerar mismatch — confirme na
  versão instalada antes de culpar o React.

### 6. Runtime: `proxy.ts` antes de middleware/edge

No Next.js 16, `middleware.ts` e `runtime='edge'` estão deprecados (confirme na
versão instalada). Para redirects, rewrites leves e cabeçalhos, prefira
`proxy.ts` com runtime Node.js. Proxy não é lugar de autorização definitiva: a
decisão final fica no DAL, porque renderização parcial pode buscar dados fora do
Layout.

```ts
// proxy.ts na raiz — confirme o nome do arquivo e a exportação na versão instalada
import { NextResponse, type NextRequest } from "next/server";

export function proxy(request: NextRequest) {
  if (request.nextUrl.pathname === "/antigo") {
    return NextResponse.redirect(new URL("/novo", request.url));
  }
  return NextResponse.next();
}
```

### 7. Respeite os limites de Functions

- **Payload:** o teto de requisição/resposta costuma ficar em torno de 4.5 MB;
  confirme no plano e na docs atual. Para upload, use URL assinada para
  armazenamento, não o body do Route Handler.
- **Duração:** defina `maxDuration` por rota e coloque `AbortSignal.timeout` nas
  chamadas externas. Não repita números antigos de plano sem confirmação.
- **Memória e bundle:** meça o uso real, mantenha dependências fora do caminho
  crítico e reutilize clientes de banco como singleton.
- **Fluid Compute:** reduz o custo de cold starts com concorrência em warmer
  containers; ainda assim projete para timeout, retry e idempotência.

```ts
export const runtime = "nodejs";
export const maxDuration = 30; // ajuste ao plano confirmado
```

Trabalho pesado vai para fila/job, não para o request nem para a renderização.

### 8. Ambiente sem vazamento

```bash
vercel link
vercel env pull .env.local
```

- Nunca use `vercel env add --value`: o valor fica no histórico do shell.
  Prefira o prompt, stdin ou o painel.
- `.env.example` versionado com os nomes; `.env.local` no `.gitignore`.
- `NEXT_PUBLIC_` somente para dado público. Qualquer segredo com esse prefixo
  entra no bundle do browser.
- Variáveis de Production diferentes das de Preview podem fazer a promoção
  recompilar; valide depois de promover.

### 9. Preview, checks e promoção

Fluxo: PR → preview → checks (lint, tipos, testes, e2e, acessibilidade) →
`vercel promote` → `vercel rollback` se algo falhar. No CI, construa uma vez e
reimplante o artefato com `--prebuilt` para não gerar builds diferentes.

```bash
vercel build --prod
vercel deploy --prebuilt
vercel promote <url-do-preview> --prod
vercel rollback <deployment-anterior>
```

Confirme a sintaxe exata na versão da CLI instalada. Não promova sem o
resultado dos checks do preview.

### 10. Verificação ponta a ponta

A ordem importa: **browser → API → dados → resposta**.

1. Browser: interação real, console sem erro de hidratação, estado correto após
   a ação.
2. API: status, latência, cabeçalhos de cache e ausência de dado privado em
   cache público.
3. Dados: gravação persistida e invalidação efetiva — a próxima leitura reflete
   a escrita.
4. Resposta: HTML/JSON final e `Cache-Control` coerentes com a sensibilidade.

Metas de Web Vitals em campo (p75, segmentado por mobile/desktop): **LCP ≤ 2.5s**,
**INP ≤ 200ms**, **CLS ≤ 0.1**. Lab não substitui field data: meça com dados
reais de usuários e trate regressão como bloqueio de merge.

## Best Practices

- Leia os docs da versão instalada antes de citar API ou limite; nunca responda
  apenas de memória.
- `'use client'` no menor escopo; `server-only` e `taint` nos módulos sensíveis.
- Invalide pelo motivo: escrita própria com `updateTag`, dados compartilhados
  com `revalidateTag(tag,'max')`, URL com `revalidatePath`.
- Fallback de Suspense com dimensão fixa e conteúdo determinístico.
- Separe cache de servidor, CDN e browser ao diagnosticar hit rate e stale.
- Nunca declare deploy pronto sem a verificação browser → API → dados → resposta.

## References

- Vercel: <https://vercel.com/docs>
- Limites de Functions: <https://vercel.com/docs/functions>
- Next.js docs versionadas: <https://nextjs.org/docs>
- Web Vitals: <https://web.dev/articles/vitals>
- OWASP Cheat Sheet Series: <https://cheatsheetseries.owasp.org/>
