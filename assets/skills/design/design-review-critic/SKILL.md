---
provenance:
  source: "OpenCode Engineering Kit (community) — padrões adaptados de plugin87/ux-ui-agent-skills (crítica com subagente cego), NN/g heuristics, WAI-ARIA APG e processo de revisão de pares do kit"
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: design-review-critic
description: "Crítica independente de UI renderizada em 1280 e 390, light/dark, com veredito aprovar/rework, achados com evidência e separação entre correto e bom."
category: design
version: 0.1.0
author: devtiagoabreu
tags: [design, code-review, critica, ui, veredito, subagente-cego, evidencia]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - URL ou build navegável da tela, com estados de carregamento, vazio e erro alcançáveis
  - Capacidade de renderizar em 1280px e 390px nos temas claro e escuro
provides:
  - "Protocolo de crítica independente com veredito binário: aprovar ou rework"
  - Separação entre requisitos ("correto") e julgamento ("bom")
  - Modelo de achado com evidência, regra violada e severidade
  - Prompts de subagente cego e critérios para avaliar o próprio crítico
---

# Crítica Independente de Design

## Overview

Esta skill executa uma **crítica independente** de uma interface renderizada. O crítico não é o autor da tela e não recebe a intenção do autor como argumento de defesa. Ele olha evidência — capturas em 1280px e 390px, claro e escuro, estados e saídas de gate — e devolve um veredito: **`aprovar`** ou **`rework`**.

Distinção central:

- **Correto** = passa nos gates mensuráveis (acessibilidade, tokens, contraste, responsividade).
- **Bom** = julgamento de hierarquia, foco, densidade, estados e microcopy.

Gates verdes são pré-condição, não aprovação. Se tudo mediu bem mas a tela não comunica, o veredito é `rework`. Se a tela é bonita mas o foco fica oculto, também é `rework`.

## Prerequisites

- Build ou URL estável, com o tema selecionável por `data-theme` ou equivalente.
- Acesso aos estados da tela: carregando, vazio, erro, sucesso e permissão negada quando houver.
- Gates mínimos já executados com `a11y-audit` e `design-tokens-pipeline`; as saídas são anexadas, não confiadas cegamente.
- Uma pessoa ou agente diferente do autor para assumir o papel de crítico.

## Preparação da cena

Capture sempre quatro combinações básicas: desktop 1280×800 e mobile 390×844, cada uma em `light` e `dark`. Acrescente capturas de cada estado relevante e do modal/mais longo fluxo da tela.

```ts
import { chromium } from '@playwright/test';

const browser = await chromium.launch();
const page = await browser.newPage();
for (const [nome, width, height] of [
  ['desktop', 1280, 800],
  ['mobile', 390, 844],
] as const) {
  await page.setViewportSize({ width, height });
  for (const tema of ['light', 'dark']) {
    await page.goto(process.env.URL_REVIEW);
    await page.evaluate((t) => {
      document.documentElement.dataset.theme = t;
    }, tema);
    await page.screenshot({
      path: `review-${nome}-${tema}.png`,
      fullPage: true,
    });
  }
}
await browser.close();
```

`URL_REVIEW` deve apontar para preview ou ambiente isolado. Não critique código lido de memória: critique o que foi renderizado.

## Passo 1 — avaliar o "correto"

Rode ou receba as saídas dos gates e confirme o escopo:

```bash
npx playwright test tests/a11y.spec.ts
npx lhci autorun --config=./lighthouserc.json
npx style-dictionary build --config=config/style-dictionary.config.json
```

Checklist do crítico:

- [ ] Nenhum P0 aberto em `a11y-audit`; P1 sem dono é bloqueio.
- [ ] Foco visível e não oculto ao percorrer a tela por teclado.
- [ ] Contraste medido por estado nos dois temas, com números anexados.
- [ ] Componentes consomem tokens semânticos; nenhum hex hardcoded.
- [ ] Alvos e reflow verificados em 390px.
- [ ] `prefers-reduced-motion` respeitado sem perder informação.

Se qualquer item falhar, o veredito já é `rework`; ainda assim continue para o passo 2, porque uma lista de falhas técnicas não é crítica de design.

## Passo 2 — avaliar o "bom"

Julgue cada dimensão e registre **o que foi visto**, não só o que faltou:

| Dimensão | Pergunta do crítico |
|---|---|
| Ponto focal | Dá para dizer em um segundo qual é a ação principal? |
| Hierarquia | Display, título e corpo têm relação intencional ou parecem ajustes avulsos? |
| Densidade | A tela é escaneável sem apertar nem dispersar? |
| Consistência | Espaçamento, raio e profundidade repetem decisões ou variam por capricho? |
| Estados | Carregar, vazio, erro e sucesso são distintos e honestos? |
| Microcopy | O texto diz o que aconteceu e qual é o próximo passo? |
| Tema escuro | A hierarquia sobrevive sem depender de sombra invisível? |
| Responsividade | Em 390px a informação foi reordenada ou apenas comprimida? |
| Anti-slop | Há gradiente genérico, quatro cards iguais, emoji-ícone ou cor destrutiva errada? |

Para cada dimensão, use `forte`, `aceitável` ou `fraco` com uma evidência. "Fraco sem evidência" não é achado — é opinião e deve ser descartado.

## Veredito

- **`aprovar`**: zero P0/P1 e nenhuma dimensão `fraco` sem plano imediato. P2 pode ficar registrado como follow-up com dono.
- **`rework`**: qualquer P0/P1, ou duas ou mais dimensões `fraco`, ou ausência de evidência para julgar.

Nunca use um terceiro rótulo. Se faltou informação para decidir, o veredito é `rework` com achado "escopo incompleto".

## Achados com evidência

Todo achado precisa de cinco campos: **id, natureza (`correto` ou `bom`), regra violada, evidência, severidade**. Regra violada pode ser um critério WCAG, uma seção de `ui-visual-craft`, uma regra de `design-tokens-pipeline`, uma heurística NN/g ou uma convenção do projeto escrita. Sem regra citável, transforme a observação em sugestão informal e remova do relatório.

```json
{
  "veredito": "rework",
  "escopo": {
    "url": "URL_REVIEW",
    "viewports": ["1280x800", "390x844"],
    "temas": ["light", "dark"],
    "build": "sha-do-commit"
  },
  "correto": { "p0": 0, "p1": 1, "p2": 2, "gates": "anexados" },
  "bom": [
    { "dimensao": "ponto focal", "nota": "fraco", "evidencia": "review-desktop-light.png" }
  ],
  "achados": [
    {
      "id": "CRIT-01",
      "natureza": "bom",
      "regra": "ui-visual-craft: display deve ser 3x o corpo; H1 32px sobre corpo 16px",
      "evidencia": "capture desktop: H1 24px, corpo 14px; computed style font-size",
      "severidade": "P1",
      "correcao": "Rebasear escala com tokens de tipografia"
    }
  ]
}
```

Severidade: **P0** impede a tarefa ou viola direito de uso; **P1** degrada claramente a compreensão ou a execução; **P2** é refinamento com contorno conhecido. A correção proposta deve ser específica o bastante para virar issue, com arquivo ou token nomeado quando possível.

## Prompts de subagente cego

Use dois agentes separados. O primeiro critica a tela; o segundo critica o crítico. Não mencione quem escreveu o código nem o que o time queria comunicar.

```text
Você é um crítico de design independente. Você não recebeu o autor nem a justificativa da tela.
Avalie apenas a experiência renderizada nos anexos (1280 light/dark e 390 light/dark).
Primeiro verifique o "correto" com as saídas de gate anexadas; depois julgue o "bom".
Todo achado deve conter: id, natureza (correto|bom), regra violada, evidência observável e severidade.
Descarte opiniões sem regra citável. Termine com um único veredito: aprovar ou rework.
```

```text
Você é o auditor do crítico. Recebe o relatório dele e as mesmas capturas, mas não a identidade do autor.
Confira: cada achado é reproduzível? A regra citada existe? A evidência corresponde à captura?
Há pelo menos uma força real da tela? A severidade está coerente com o impacto?
O veredito segue a regra: qualquer P0/P1 => rework?
Devolva: crítico aceito ou crítico rejeitado, com os motivos e os achados que devem ser removidos.
```

A separação de agentes importa: o autor que critica a própria tela tende a explicar intenção no lugar de descrever efeito.

## O crítico também deve ser avaliado

Aplicar a mesma disciplina a quem critica evita "design critic" que só produz adjetivos.

| Teste | Falha típica | Ação |
|---|---|---|
| Evidência reproduzível | Cita screenshot que não existe ou não mostra o alegado | Remover achado e pedir nova captura |
| Regra citável | "Eu faria diferente" sem referência | Converter em sugestão informal ou descartar |
| Cobertura | Julgou só desktop claro | Exigir as quatro combinações antes do veredito |
| Calibração | P0 para preferência estética, P2 para foco oculto | Reclassificar e reemitir veredito |
| Equilíbrio | Só negativos, nenhuma força identificada | Devolver para nova leitura |

Antes de aceitar um relatório, marque: capturas conferidas, regras verificadas, severidade justificada, veredito coerente, pelo menos uma força nomeada. Um crítico que aprova tudo sem mencionar evidência é tão inválido quanto um que reprova tudo.

## Anti-padrões

| Anti-padrão | Correção |
|---|---|
| Aprovar porque "os gates estão verdes" | Aplicar o passo 2 e exigir julgamento com evidência |
| Elogiar sem apontar onde viu | Nomear captura, estado e elemento |
| Criticar o código em vez da experiência renderizada | Abrir a tela nos quatro cenários |
| Autor criticando a própria entrega com prompt cego | Usar agente separado, sem contexto de intenção |
| Veredito intermediário para evitar conflito | Escolher `aprovar` ou `rework` e registrar P2 à parte |
| `rework` sem correção acionável | Escrever regra, evidência e próximo passo por achado |
| Inventar evidência para reforçar opinião | Remover achado; evidence inexistente invalida o relatório |

## Limites

Crítica é amostragem, não um teste exaustivo: ela não substitui pesquisa com usuário, auditoria legal ou testes de acessibilidade manuais completos. O veredito vale para o escopo e o build declarados; mudou o build, é necessária nova crítica.

## Referências

- [NN/g — 10 Usability Heuristics](https://www.nngroup.com/articles/ten-usability-heuristics/)
- [WAI-ARIA APG](https://www.w3.org/WAI/ARIA/apg/)
- [Playwright — screenshots e viewports](https://playwright.dev/)
