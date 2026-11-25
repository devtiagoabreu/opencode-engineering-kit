---
provenance:
  source: "OpenCode Engineering Kit (community) — padrões adaptados de OWASP Cheat Sheet Series, vercel/next.js, vercel/vercel-plugin, documentação oficial do Next.js, Stripe Docs e Supabase Docs"
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: nextjs-web-security
description: Segurança web em Next.js — XSS e CSRF, autorização no DAL, validação em Actions e Route Handlers, webhooks Stripe, RLS e segredos
category: security
version: 0.1.0
author: devtiagoabreu
tags: [nextjs, owasp, xss, csrf, authorization, webhooks, secrets]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Aplicação Next.js com rotas, Server Actions ou Route Handlers
  - Acesso ao código da versão instalada em `node_modules/next/dist/docs`
  - Provedor de autenticação e banco com escopo de tenant definido
provides:
  - Regras de escape, sanitização e allowlist de URL
  - Checklist de CSRF com SameSite, checagem de Origem e CSP defensiva
  - Padrão de autorização no DAL e validação com 401/403/429 e timeout
  - Regras para webhook Stripe, RLS, service_role e segredos
security:
  risk_level: medium
  permissions:
    - shell
    - network
  audited: true
---

# Segurança Web para Next.js

## Overview

Em uma aplicação Next.js, a fronteira de confiança não é o Layout nem o proxy:
é cada acesso a dados e cada entrada do usuário. Esta skill reúne as regras que
evitam os erros mais caros em produção — HTML injetado, requisição forjada,
autorização apenas visual, payload sem validação, cache público de dado
privado, webhook sem assinatura e segredo no bundle. As diretrizes são
adaptadas de OWASP e da documentação oficial; confirme na versão instalada
antes de aplicar uma API ou alegar que uma vulnerabilidade foi corrigida. Para cache e runtime, veja
[runtime e cache](../../devops/vercel-runtime-and-cache/SKILL.md).

## Prerequisites

- Entender qual dado é público, qual é do usuário e qual é de outro tenant.
- Ter um DAL (camada de acesso a dados) por onde passem todas as leituras e
  escritas sensíveis.
- Ler os docs da versão instalada em `node_modules/next/dist/docs` em vez de
  confiar na memória do modelo, especialmente para cabeçalhos e Server Actions.
- Nenhuma destas regras substitui revisão de código e teste de penetração.

## Usage Instructions

### 1. Escape por contexto e HTML confiável

O React escapa texto por padrão; o problema aparece quando você transforma
string em HTML ou coloca dado não confiável em atributo, URL, JavaScript ou CSS.
Escape muda conforme o contexto: HTML, atributo entre aspas, URL, JS e stylesheet
não usam as mesmas regras. Para rich text, sanitize com allowlist explícita de
tags, atributos e protocolos de URL (`https:`, `mailto:`).

**Proibido:** `dangerouslySetInnerHTML` sem sanitização. Nunca passe conteúdo
vindo de banco, formulário ou webhook diretamente para `__html`.

```tsx
import DOMPurify from "dompurify";

export function ConteudoSeguro({ bruto }: { bruto: string }) {
  const html = DOMPurify.sanitize(bruto, {
    ALLOWED_TAGS: ["p", "strong", "em", "a", "ul", "li"],
    ALLOWED_ATTR: ["href", "title"],
  });
  return <div dangerouslySetInnerHTML={{ __html: html }} />;
}
```

Se o HTML for montado no servidor, sanitize também no servidor antes de
persistir. `href` e `src` precisam de allowlist de protocolo: bloqueie
`javascript:` e `data:` salvo necessidade justificada. CSP é defesa adicional,
não desculpa para pular escape.

### 2. CSRF: SameSite, Origem e CSP defensiva

Cookies de sessão devem ser `HttpOnly`, `Secure` e `SameSite=Lax` (ou `Strict`
quando o fluxo permitir). Mesmo assim, checagem da Origem em mutações é
necessária. Server Actions do Next.js têm proteção interna — confirme na versão
instalada — e isso não cobre Route Handlers escritos por você.

```ts
export function mesmaOrigem(request: Request): boolean {
  const origin = request.headers.get("origin");
  const base = process.env.APP_URL;
  if (!origin || !base) return false;
  try {
    return new URL(origin).origin === new URL(base).origin;
  } catch {
    return false;
  }
}
```

Aplique a checagem em POST/PUT/PATCH/DELETE que mudam estado; `Sec-Fetch-Site`
pode ser usado como sinal extra. Atrás de proxy, configure `APP_URL` com a URL
pública real, não com o host interno.

CSP defensiva começa em modo `Report-Only`, com `default-src 'self'`,
`object-src 'none'`, `base-uri 'self'` e `frame-ancestors 'none'`. Se precisar
de script inline, gere um nonce por requisição e nunca reutilize o valor; evite
`unsafe-inline`. CSP não impede XSS em HTML confiável mal sanitizado: as duas
camadas são complementares.

### 3. Autorização no DAL, não só no Layout ou no Proxy

Layouts e `proxy.ts` melhoram a experiência e reduzem trabalho, mas não são a
fronteira de autorização. Renderização parcial pode buscar dados fora do Layout,
e uma Action ou Route Handler pode ser chamada diretamente. Toda função do DAL
que toca dado de usuário ou tenant deve verificar sessão e permissão **antes**
da consulta, com escopo de tenant na própria query.

```ts
import "server-only";

class HttpError extends Error {
  constructor(public readonly status: 401 | 403) {
    super("acesso negado");
  }
}

export async function lerCliente(clienteId: string, tenantId: string) {
  const session = await getSession();
  if (!session) throw new HttpError(401);
  if (session.tenantId !== tenantId || !(await podeLer(session, clienteId))) {
    throw new HttpError(403);
  }
  return db.cliente.findFirst({ where: { id: clienteId, tenantId } });
}
```

Não confie apenas no `id` recebido do cliente para inferir tenant. Trate erro de
autorização como 401/403, não como "não encontrado" quando isso vazar
informação — decida com a política do produto e documente.

### 4. Valide payload e responda com o status correto

Route Handlers e Server Actions recebem dados arbitrários. Use o mesmo schema
Zod do formulário no servidor, limite tamanho, aplique rate limit e imponha
timeout nas chamadas externas. Não chame Route Handler interno a partir de
Server Component: chame a função de serviço diretamente.

```ts
const Corpo = z.object({ clienteId: z.string().uuid() });

export async function POST(request: Request) {
  const dados = Corpo.safeParse(await request.json());
  if (!dados.success) {
    return Response.json({ erro: "payload inválido" }, { status: 400 });
  }
  if (!mesmaOrigem(request)) {
    return Response.json({ erro: "origem inválida" }, { status: 403 });
  }
  const session = await getSession();
  if (!session) return Response.json({ erro: "não autenticado" }, { status: 401 });
  if (await limiteAtingido(session.userId)) {
    return Response.json({ erro: "muitas requisições" }, { status: 429 });
  }
  const resultado = await servico(dados.data, AbortSignal.timeout(5_000));
  return Response.json(resultado, {
    headers: { "Cache-Control": "private, no-store" },
  });
}
```

Em Server Actions, valide antes de qualquer escrita e revalide a permissão no
DAL — não apenas no componente que renderizou o botão.

### 5. `Cache-Control: public` em dado privado é proibido

Resposta personalizada nunca deve usar `public`, `s-maxage` compartilhado ou
tag de cache compartilhada. Use `private, no-store` para dado de usuário;
`private` ainda pode ser armazenado no browser, portanto avalie dados sensíveis.
Cache de CDN, de servidor e de browser são camadas distintas: uma configuração
correta em uma não compensa a outra.

- Sem scripts de terceiros lendo HTML com token ou e-mail embutido.
- Sem PII em chave de cache, URL de log, query de telemetria ou mensagem de erro.
- Teste com dois usuários: a resposta de um não pode aparecer para o outro.

### 6. Webhook Stripe com assinatura, tolerância e idempotência

O corpo precisa ser lido **cru**: parsear JSON antes de verificar a assinatura
quebra a validação. Exija cabeçalho `Stripe-Signature`, use `constructEvent`
com o segredo do webhook e tolerância explícita de **5 minutos** (`300` s).
`tolerance: 0` desliga a proteção contra replay — não use. Evento repetido deve
ser reconhecido sem reprocessar efeitos colaterais; responda 2xx rapidamente e
mova trabalho longo para fila.

```ts
export async function POST(request: Request) {
  const raw = await request.text();
  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(
      raw,
      request.headers.get("stripe-signature") ?? "",
      process.env.STRIPE_WEBHOOK_SECRET ?? "",
      300,
    );
  } catch {
    return Response.json({ erro: "assinatura inválida" }, { status: 400 });
  }
  if (Date.now() / 1000 - event.created > 300) {
    return Response.json({ erro: "evento expirado" }, { status: 400 });
  }
  if (await jaProcessado(event.id)) {
    return Response.json({ recebido: true });
  }
  await processarUmaVez(event); // grava o id do evento na mesma transação
  return Response.json({ recebido: true });
}
```

Preço e total vêm do servidor; nunca aceite valor informado pelo cliente.
Confirme a API da versão instalada da biblioteca Stripe.

### 7. RLS, `service_role` e segredos

- Habilite RLS em toda tabela com dado de tenant e escreva policies explícitas
  por `auth.uid()`/tenant; teste o acesso cruzado entre tenants.
- A chave `service_role` ignora RLS: fica apenas no servidor e **nunca** em
  `NEXT_PUBLIC_`. No browser, use apenas a chave pública com RLS ativo.
- `.env.example` versionado com nomes; `.env.local` fora do Git; sincronize com
  `vercel link` e `vercel env pull` e nunca com `--value`.
- Roteiro de segredos: menor privilégio, rotação, sem logging de token, sem
  segredo em client component, bundle, erro amigável ou telemetria.
- Use pooling de conexões em serverless e mantenha o cliente de banco como
  singleton; isso é desempenho, mas também evita erro de conexão que vira
  exceção com dado sensível no stack trace.

### 8. Patch mínimo do Next.js

Exija uma versão com patches recentes e fixe a versão exata no lockfile.
Advisories históricos — por exemplo, SSRF em Server Actions corrigido em
versões antigas — mostram que copiar exemplo velho pode reintroduzir falha.
Execute auditoria de dependências no CI, acompanhe advisories e **confirme na
versão instalada** antes de afirmar que determinada correção já está presente.
Não use `dangerouslySetInnerHTML` sem sanitização nem `runtime='edge'` ou
`middleware.ts` só porque um tutorial antigo faz isso (confirme na versão
instalada).

## Best Practices

- Escape por contexto; sanitize rich text com allowlist; nunca HTML cru.
- Autorize no DAL e revalide em Actions/Route Handlers; Layout e proxy não bastam.
- Zod em toda entrada, 401/403/429/400 conforme o caso, timeout nas chamadas
  externas e rate limit em mutações.
- Resposta de dado privado com `Cache-Control: private, no-store`.
- Webhook Stripe: raw body, `constructEvent`, 300 s, idempotência, 2xx rápido.
- RLS ligado, `service_role` só no servidor, nenhum segredo com `NEXT_PUBLIC_`.
- Patch mínimo confirmado na versão instalada; CSP e WAF são defesa em profundidade.

## References

- OWASP Cheat Sheet Series: <https://cheatsheetseries.owasp.org/>
- Next.js docs versionadas: <https://nextjs.org/docs>
- Stripe webhooks: <https://docs.stripe.com/webhooks>
- Supabase RLS: <https://supabase.com/docs/guides/database/postgres/row-level-security>
- Variáveis de ambiente na Vercel: <https://vercel.com/docs/environment-variables>
