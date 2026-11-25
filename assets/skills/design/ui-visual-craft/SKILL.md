---
provenance:
  source: "OpenCode Engineering Kit (community) — padrões adaptados de Refactoring UI, Vercel Web Interface Guidelines, Tailwind CSS, plugin87/ux-ui-agent-skills e pesquisa interna docs/WEB_UI_VERCEL_PYTHON_RESEARCH.md"
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: ui-visual-craft
description: "Artesanato visual verificável em UI: escala tipográfica com propósito, ritmo de 4px, cor semântica em OKLCH, profundidade, motion e anti-slop."
category: design
version: 0.1.0
author: devtiagoabreu
tags: [design, ui, tipografia, espacamento, oklch, dark-mode, motion, anti-slop]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Design tokens do projeto ou autorização para defini-los antes de compor a tela
  - "Componentes com estados nomeados: default, hover, focus, disabled, error"
provides:
  - Escala tipográfica e ritmo de espaçamento com regras explícitas
  - Convenções de cor semântica, OKLCH, profundidade, raio e motion
  - Checklist de beleza verificável e catálogo de anti-padrões visuais
---

# Artesanato Visual de UI

## Overview

"Bonito" não pode ser só opinião.Esta skill transforma artesanato visual em decisões verificáveis: escala com propósito, ritmo de espaçamento, cor semântica, profundidade coerente e motion respeitoso. O objetivo é uma tela que um designer sênior assinaria — densa, legível, consistente — sem decoração gratuita.

Correção não é qualidade: uma tela pode passar nos gates de acessibilidade e ainda parecer gerada por modelo. Use `a11y-audit` para o "correto" e esta skill para o "bem composto"; `design-review-critic` julga o resultado de forma independente.

Regras de ouro:

1. **Hierarquia por tamanho e peso**, nunca por cor sozinha.
2. **Um ponto focal por tela**, uma ação primária.
3. **Repetir decisões antes de inventar.** Token existente vence valor novo.
4. **Todo estado precisa de tratamento**, inclusive carregamento e vazio.
5. **Light e dark são entregas obrigatórias**, não um ajuste posterior.

## Prerequisites

- Tokens de cor, tipografia, espaçamento e raio disponíveis — ou permissão para criá-los com `design-tokens-pipeline`.
- Componentes que exponham estados nomeados, para que a verificação por estado seja possível.
- Disponibilidade para conferir a tela renderizada em 1280px e 390px, nos dois temas.

## Escala tipográfica com propósito

Defina o corpo como base e derive o restante. Exemplo com corpo de 16px: **display = 3× o corpo = 48px**. A proporção é uma decisão, não acidente de `text-2xl`.

| Papel | Tamanho | Peso | Entrelinha | Uso |
|---|---:|---|---:|---|
| Display | 48px (3× corpo) | 700 | 1.05 | Número/métrica de destaque, raramente título de página |
| Título de página (H1) | 32px (2×) | 650–700 | 1.15 | Um por tela |
| Título de seção (H2) | 24px (1.5×) | 600 | 1.25 | Agrupa blocos |
| Título de bloco (H3) | 18px | 600 | 1.35 | Denomina cartão ou linha de detalhe |
| Corpo | 16px | 400 | 1.5 | Leitura e dados |
| Rótulo | 14px | 500 | 1.4 | Formulários e metadados |
| Legenda | 12–13px | 400 | 1.35 | Rodapé, ajuda curta; nunca informação crítica |

- Use `rem` para escala e `px` só para bordas e alvos.
- No máximo três pesos por família; uma família principal e uma mono para código/valores.
- Números em tabelas e KPIs com `font-variant-numeric: tabular-nums`.
- Parágrafos entre 60 e 75 caracteres por linha; tabelas ficam isentas.
- **Anti-padrão explícito:** título 24px sobre corpo 14px como única hierarquia. Se o corpo é 14px, o display não pode ser "um pouco maior": a relação precisa ser intencional.

## Ritmo de espaçamento de 4px

Escala: `4, 8, 12, 16, 24, 32, 48, 64` px. Valores como 13px, 17px ou 22px não entram sem justificativa registrada no token.

```css
:root {
  --space-1: 0.25rem;  /* 4px  */
  --space-2: 0.5rem;   /* 8px  */
  --space-3: 0.75rem;  /* 12px */
  --space-4: 1rem;     /* 16px */
  --space-6: 1.5rem;   /* 24px */
  --space-8: 2rem;     /* 32px */
  --space-12: 3rem;    /* 48px */
  --space-16: 4rem;    /* 64px */

  --text-body: 1rem;
  --text-display: calc(var(--text-body) * 3);
  --font-weight-regular: 400;
  --font-weight-medium: 500;
  --font-weight-bold: 700;
}
```

Regra de proximidade: **dentro do grupo** use 4–12px; **entre grupos** use 24–48px; **entre seções** use 48–64px. Se tudo usa o mesmo `gap: 16px`, a tela perde hierarquia mesmo com boa tipografia. Densidade de tabela pode reduzir o ritmo, mas por meio de tokens de densidade, não valores soltos no componente.

## Cor semântica e OKLCH

Nomeie por **função**, não por aparência: `surface.default`, `text.muted`, `border.subtle`, `action.primary.bg`, `feedback.danger.fg`. Nomes como `blue-500` vivem apenas na camada primitiva; componentes nunca os consomem diretamente.

OKLCH facilita ajustes perceptuais (`l c h`); não substitui medição de contraste. A luminosidade percebida não é razão WCAG.

```css
:root {
  --color-surface: oklch(0.99 0.005 250);
  --color-surface-raised: oklch(0.97 0.008 250);
  --color-text: oklch(0.22 0.02 250);
  --color-text-muted: oklch(0.45 0.02 250);
  --color-border: oklch(0.88 0.01 250);
  --color-action-bg: oklch(0.55 0.16 255);
  --color-action-fg: oklch(0.99 0.005 255);
  --color-danger-bg: oklch(0.58 0.19 25);
  --color-focus-ring: oklch(0.52 0.17 255);
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --shadow-1: 0 1px 2px oklch(0.2 0 0 / 0.08);
}

:root[data-theme="dark"] {
  --color-surface: oklch(0.19 0.015 250);
  --color-surface-raised: oklch(0.24 0.015 250);
  --color-text: oklch(0.96 0.005 250);
  --color-text-muted: oklch(0.76 0.015 250);
  --color-border: oklch(0.34 0.015 250);
}
```

Matriz obrigatória por cor interativa: `default / hover / focus / disabled / error` em light e dark. Contraste de texto normal ≥ 4.5:1, texto grande e elemento de interface ≥ 3:1; meça, não estime. Ação destrutiva usa token de `danger`, nunca a cor primária. Estado não pode depender apenas de cor: erro leva texto e ícone, sucesso leva confirmação textual.

## Profundidade e raio

- Estrutura vem de borda e espaçamento; sombra só para elevação real (dropdown, modal, popover). No máximo dois níveis de sombra (`--shadow-1`, `--shadow-2`).
- Um único raio para tudo é anti-padrão. Use `4px` para controle, `8px` para cartão, `12px` para painel e `full` para avatar/pílula.
- Em elementos aninhados, raio interno ≤ raio externo - 4px.
- No dark mode, enfraqueça sombras e fortaleça bordas: sombra preta sobre fundo escuro quase não informa.
- Não use sombra colorida de marca como decoração em tabela densa.

## Motion com preferência respeitada

Durações curtas e previsíveis: `120ms` para hover/foco, `180ms` para expansão, `280ms` para transição de painel. Anime apenas `transform` e `opacity`; evite animar `width`, `top` ou `box-shadow` em listas longas.

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

Skeleton comunica "dados chegando"; spinner isolado não diz o que está carregando. Nunca simule `disabled` com opacidade durante carregamento: parece proibição, não progresso. Se a animação carrega informação (por exemplo, sequência de onboarding), ofereça equivalente sem movimento.

## Light e dark como primeiro cidadão

- Escreva componentes só com tokens semânticos; o tema troca os valores dos tokens, não as classes do componente.
- Revisar contraste no tema escuro separadamente: branco sobre superfície escura pode passar, enquanto `text.muted` mal calibrado falha.
- Superfícies elevadas no escuro devem ficar **mais claras**, não mais escuras, para manter a hierarquia.
- Verifique estados de foco, erro e desabilitado nos dois temas; não apenas o estado inicial.
- Se o produto tiver mais de um tema de marca, cada tema precisa da mesma matriz de contraste.

## Checklist de beleza verificável

- [ ] Existe um único ponto focal e uma ação primária por tela.
- [ ] Display = 3× o corpo (ou outra proporção declarada), com no máximo três pesos.
- [ ] Todo espaçamento vem da escala de 4px; nenhum valor solto no componente.
- [ ] Nomes de cor são semânticos; componentes não contêm hex nem `oklch(...)` direto.
- [ ] Contraste medido por estado, nos dois temas, com números no relatório.
- [ ] Profundidade tem no máximo dois níveis e raio segue a hierarquia.
- [ ] `prefers-reduced-motion` respeitado sem perder informação.
- [ ] Loading, vazio e erro têm tratamento próprio e coerente.
- [ ] Nenhuma cor carrega significado sozinha.
- [ ] Tabela densa continua legível em 1280px e 390px.
- [ ] Microcopy específica ("Nenhum fornecedor encontrado") em vez de "Sem dados".
- [ ] Ao copiar um padrão de outra tela, a decisão foi reusada — não reescrita com valores novos.

## Anti-slop

| Anti-padrão | Sintoma | Correção |
|---|---|---|
| Gradiente índigo→roxo genérico | Fundo "moderno" sem relação com a marca | Cor sólida semântica; gradiente só se comunicar algo |
| Quatro cards idênticos em linha | Nenhum ponto focal | Destaque um card ou substitua por lista hierárquica |
| Emoji como ícone | Renderização inconsistente entre sistemas | Ícone vetorial com `aria-hidden` quando decorativo |
| Texto cinza sobre branco "porque é sutil" | Contraste baixo e leitura cansativa | Token `text.muted` com contraste medido |
| Botão destrutivo azul | Ação irreversível parece segura | Token `danger` + confirmação com nome do objeto |
| Heading 24px sobre corpo 14px | Escala sem propósito | Rebasear: corpo 16px, display 48px, H1 32px |
| Valores hardcoded (`#3b82f6`, `18px`) | Tema e ajustes quebram um a um | Token semântico + pipeline de tokens |
| Loading com opacidade de `disabled` | Usuário acha que não pode agir | Skeleton com rótulo e `aria-busy` |
| Toast que afirma "criado" sem mudar a lista | Mentira visual | Atualizar fonte de dados antes de anunciar |
| Sombra enorme em todo cartão | Ruído e hierarquia falsa | Borda sutil; sombra só em elevação real |

## Limites

Esta skill organiza decisões visuais; não substitui `a11y-audit`, testes com usuário nem `design-review-critic`. Uma checklist preenchida não prova que a tela é boa — ela apenas remove erros repetíveis. Quando houver conflito entre estética e legibilidade, legibilidade vence.

## Referências

- [Refactoring UI](https://www.refactoringui.com/)
- [Vercel Web Interface Guidelines](https://github.com/vercel-labs/web-interface-guidelines)
- [OKLCH color space — CSS Color 4](https://www.w3.org/TR/css-color-4/)
- [Tailwind CSS — design tokens e temas](https://tailwindcss.com/)
