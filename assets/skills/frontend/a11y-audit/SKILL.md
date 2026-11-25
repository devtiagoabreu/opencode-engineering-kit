---
provenance:
  source: "OpenCode Engineering Kit (community) — padrões adaptados de WCAG 2.2 e WAI-ARIA APG (W3C), axe-core (Deque), Lighthouse (Google), testing-library e plugin87/ux-ui-agent-skills"
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: a11y-audit
description: "Gate obrigatório de acessibilidade para UI: WCAG 2.2 AA/AAA, APG por widget, axe/Lighthouse/testes manuais e relatório priorizado."
category: frontend
version: 0.1.0
author: devtiagoabreu
tags: [acessibilidade, wcag-2-2, aria-apg, axe-core, lighthouse, teclado, leitor-de-tela, contraste]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Aplicação web com HTML renderizado e tema claro/escuro identificável
  - Node.js 20+ para executar axe-core, Playwright e Lighthouse CI
provides:
  - Gate de saída antes de declarar UI pronta
  - Matriz WCAG 2.2 AA/AAA com critérios novos e evidências
  - Comandos de auditoria automatizada e protocolo manual
  - Relatório priorizado P0/P1/P2 com critérios de aceite
---

# Auditoria de Acessibilidade (A11y)

## Overview

Esta skill é o **gate obrigatório** antes de escrever que uma interface está pronta. Ela vale para telas novas, refatorações, componentes de design system e correções de bug visual. "Passou no lint" e "axe não acusou nada" **não** são sinônimo de acessibilidade.

Regras de ouro:

1. **Gate antes do verbete "pronto".** Se não há evidência de teclado, leitor de tela e contraste renderizado, a UI não está pronta.
2. **AA é o piso; AAA é explicitamente solicitado.** Declare o alvo no início da auditoria e não o mude depois de ver os resultados.
3. **Automação encontra o óbvio; manual encontra o resto.** As duas camadas são obrigatórias.
4. **Todo achado tem evidência reprodutível:** URL, tema, viewport, passos, saída da ferramenta e regra violada.
5. **Relatório priorizado P0/P1/P2**, com dono e critério de verificação para cada item.

## Prerequisites

- Aplicação rodando em URL estável, com os temas claro e escuro selecionáveis.
- Node.js 20+ e navegador Chromium instalado para Playwright.
- Acesso a um leitor de tela real (NVDA, VoiceOver ou TalkBack) para a etapa manual.
- Lista das janelas/modais, menus e formulários que fazem parte do escopo.

## Escopo normativo (WCAG 2.2)

| Critério | Nível | O que exigir na auditoria |
|---|---|---|
| 1.1.1 Texto alternativo | A | Imagem informativa com `alt` útil; decorativa com `alt=""` |
| 1.3.1 Informação e relações | A | Cabeçalhos, listas, rótulos e associações de formulário na ordem certa |
| 1.4.3 Contraste (mínimo) | AA | Texto normal ≥ 4.5:1; texto grande ≥ 3:1 |
| 1.4.11 Contraste não textual | AA | Bordas de input, ícones significativos e indicadores ≥ 3:1 |
| 2.1.1 / 2.1.2 Teclado | A | Toda ação por teclado; sem armadilha de foco |
| 2.4.3 Ordem de foco | A | Ordem segue a leitura visual, inclusive em `modal` e `drawer` |
| 2.4.7 Foco visível | AA | Anel de foco perceptível em todo elemento interativo |
| 2.4.11 Foco não oculto | AA | Cabeçalho fixo, sticky bar e toast não encobrem o elemento focado |
| 2.4.13 Aparência do foco | AAA | Área e contraste do indicador de foco conforme o critério |
| 2.5.8 Alvo mínimo (24×24) | AA | Alvos pelo menos 24×24 CSS px, com exceções documentadas |
| 3.2.6 Ajuda consistente | A | Dica/ajuda/tooltip aparece no mesmo lugar e com o mesmo gatilho |
| 3.3.7 Entrada redundante | A | Não pedir de novo dado já informado no mesmo processo |
| 3.3.8 Autenticação acessível | AA | Sem quebra-cabeça cognitivo; permitir colar e gestor de senhas |
| 4.1.2 Nome, função, valor | A | Nome acessível, role correto, estado (`expanded`, `checked`) sincronizado |
| 4.1.3 Mensagens de status | AA | `role="status"` / `role="alert"` para mudanças sem mudança de foco |

**Contraste por estado e por tema:** meça `default`, `hover`, `focus`, `disabled` e `error` em **light e dark**. O critério 1.4.3 isenta componentes inativos, mas texto `disabled` ilegível continua sendo defeito de usabilidade: registre como P2 com justificativa.

O anel de foco precisa de 3:1 contra as cores adjacentes. Texto grande significa ~24px normal ou ~18,66px negrito; confirme a definição na versão da norma que você usa.

**Reduced motion:** com `prefers-reduced-motion: reduce`, animações não essenciais devem parar. Se uma animação carrega informação, ofereça alternativa equivalente — remover motion não pode remover significado.

## APG por widget

Use o padrão do WAI-ARIA Authoring Practices Guide correspondente ao widget; ARIA não substitui HTML semântico.

| Widget | Referência APG | Obrigações mínimas |
|---|---|---|
| Link de navegação | Não é `menu` | `<nav>` + `<a>`; Tab entre links; `role="menu"` só para menu de comandos |
| Modal / dialog | Dialog (modal) | `aria-modal`, nome, `inert` no fundo, foco inicial, Esc fecha, foco retorna |
| Abas | Tabs | `tablist`/`tab`/`tabpanel`, setas para navegar, Tab entra no painel |
| Acordeão | Accordion | `aria-expanded`, `aria-controls`, Enter/Espaço alternam |
| Combobox | Combobox | Nome, `aria-expanded`, `aria-activedescendant`, filtro por teclado |
| Menu de comandos | Menu / Menubar | Setas, Home/End, Esc; ausência de setas indica menu errado |
| Tabela de dados | Table / Grid | `th` com `scope`, captions, ordenação com `aria-sort` |
| Toast e feedback | Status / Alert | Anúncio sem roubar foco; `alert` só para urgência |
| Tooltip | Tooltip | Gatilho por foco e hover, Esc dispensa, não contém ação |

Erro frequente do kit antigo: usar `role="menu"` para links de navegação. Corrija para `<nav><ul><li><a>`; o modelo `menu` do APG exige navegação por setas e é para ações de aplicação.

## Gate automatizado

Instalação:

```bash
npm i -D @axe-core/playwright @playwright/test @testing-library/react @testing-library/user-event @testing-library/jest-dom jest-axe @lhci/cli eslint-plugin-jsx-a11y
npx playwright install chromium
```

Configure `use.baseURL` no `playwright.config.ts` e rode a varredura nos dois temas:

```ts
import AxeBuilder from '@axe-core/playwright';
import { test, expect } from '@playwright/test';

for (const theme of ['light', 'dark']) {
  test(`axe: dashboard em ${theme}`, async ({ page }) => {
    await page.goto('/dashboard');
    await page.evaluate((t) => {
      document.documentElement.dataset.theme = t;
    }, theme);
    const results = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21aa', 'wcag22aa'])
      .analyze();
    expect(results.violations).toEqual([]);
  });
}
```

A regra `target-size` (2.5.8) pode ser `experimental` ou opt-in conforme a versão do axe-core. Quando não estiver na tags do pacote, rode `withRules(['target-size'])` se disponível e meça manualmente; nunca reporte "2.5.8 coberto" apenas porque o pacote não acusou nada.

Testes de componente com Testing Library e jest-axe:

```tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

test('formulário associa rótulo, erro e foco', async () => {
  const { container } = render(<Formulario />);
  expect(await axe(container)).toHaveNoViolations();
  await userEvent.click(screen.getByRole('button', { name: /salvar/i }));
  expect(screen.getByRole('alert')).toHaveTextContent('Informe o e-mail');
  expect(screen.getByLabelText(/e-mail/i)).toHaveFocus();
});
```

Queries por papel e nome, nunca por estrutura interna ou `data-testid` de implementação. `user-event` simula teclado real melhor que `fireEvent`.

Lighthouse CI com orçamento de acessibilidade (arquivo `lighthouserc.json`):

```json
{
  "ci": {
    "collect": { "url": "https://preview.example.test" },
    "assert": {
      "assertions": {
        "categories:accessibility": ["error", { "minScore": 1 }]
      }
    }
  }
}
```

```bash
npx lhci autorun --config=./lighthouserc.json
```

Use o Lighthouse como check de regressão em laboratório: ele reusa subconjunto das regras axe e não cobre fluxos autenticados por padrão.

## Protocolo manual obrigatório

```text
1. Sem mouse: Tab e Shift+Tab por toda a tela; anote ordem, foco invisível e armadilhas.
2. Widgets compostos: setas, Home/End, Enter, Espaço e Esc conforme o APG daquele widget.
3. Modal: foco inicial, fundo inerte, Esc, retorno ao gatilho; foco não oculto por sticky header.
4. Leitor de tela: NVDA + Firefox (Windows) ou VoiceOver + Safari (macOS).
5. Formulário: percorra em modo formulário; confirme nome, rótulo, erro e anúncio de status.
6. Zoom 200% e 400%: sem perda de conteúdo ou função (reflow).
7. Forced colors / high contrast: ícones e bordas não desaparecem.
8. prefers-reduced-motion: sem movimento não essencial; informação preservada.
9. Repita os itens 1-8 em light e dark, em 1280px e 390px de largura.
```

Em dispositivo móvel, complemente com TalkBack. Anexar gravação curta ou transcrição do que o leitor anunciou transforma opinião em evidência.

## Relatório priorizado

Estrutura mínima do relatório:

| Campo | Conteúdo |
|---|---|
| Veredito | `BLOQUEADO` ou `APROVADO COM RESSALVAS`; nunca "conforme" sem manual |
| Escopo | URL, build/commit, viewport, tema, navegador e leitor de tela usados |
| Alvo | AA ou AAA, com critérios extras listados |
| Cobertura | O que foi testado por ferramenta e o que foi testado por humano |
| Limites | O que não foi verificado e por quê |

Achados:

| ID | Prioridade | Critério | Evidência | Impacto | Correção | Verificação |
|---|---|---|---|---|---|---|
| A11Y-01 | P0 | 2.4.11 | Capture com foco sob header sticky | Usuário não sabe onde está | `scroll-margin-top` + recuo do header | Repetir Tab no mesmo breakpoint |

- **P0 — bloqueia entrega:** teclado preso, foco invisível/oculto, ação sem nome acessível, erro não anunciado, contraste do texto principal abaixo do mínimo, autenticação com teste cognitivo.
- **P1 — barreira com contorno:** alvo abaixo de 24×24 sem exceção válida, ordem de foco incoerente, status importante sem anúncio, ajuda inconsistente entre telas.
- **P2 — melhoria:** texto `disabled` com contraste fraco, item AAA, documentação de exceção, refinamento de microcopy.

**Critério de saída:** zero P0; P1 com dono, prazo e aprovação explícita; P2 registrado; evidências anexadas; escopo e limites declarados. Se qualquer P0 permanecer, a resposta é "bloqueado", não "pronto".

## Anti-padrões

| Anti-padrão | Por que falha | Correção |
|---|---|---|
| "axe zero violações" como prova de conformidade | Ferramentas cobrem parcela das regras | Executar protocolo manual e declarar limites |
| `<div onClick>` clicável | Sem foco, sem nome, sem teclado | Usar `<button>` ou `<a>` conforme a ação |
| `role="menu"` em links de navegação | Contrato de setas do APG não existe ali | `<nav>` com lista de links |
| `placeholder` servindo de rótulo | Desaparece ao digitar e some para leitor | `<label for>` visível |
| Erro indicado só por cor vermelha | Falha para daltonismo e leitor de tela | Texto + ícone + `aria-invalid` + `aria-describedby` |
| `opacity: 0.4` para "desabilitado" em botão que deveria ser descoberto | Remove o alvo da navegação sem explicação | `aria-disabled` com foco preservado quando fizer sentido |
| Foco escondido por `header` sticky | Viola 2.4.11 | Ajustar `scroll-padding-top`/`scroll-margin-top` |
| CAPTCHA de ler caracteres distorcido no login | Viola 3.3.8 | Permitir colar, gestor de senhas e método alternativo |
| Pedir e-mail de novo no passo 2 do checkout | Viola 3.3.7 | Preencher ou permitir confirmar o dado já informado |
| Animação de entrada obrigatória ignorando `prefers-reduced-motion` | Exclusão de usuários sensíveis a movimento | Respeitar a media query e preservar o conteúdo |

## Limites

Gates automáticos **não provam conformidade**. Eles reduzem regressões conhecidas; a decisão final depende de teste manual, leitor de tela e revisão humana. Conformidade WCAG é afirmação por página e por processo completo, com escopo e exceções documentados — nunca uma frase genérica do tipo "o site é acessível". Não use esta skill para emitir laudo jurídico ou certificação.

## Referências

- [WCAG 2.2 Quick Reference](https://www.w3.org/WAI/WCAG22/quickref/)
- [WAI-ARIA APG — práticas de teclado](https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/)
- [axe-core](https://github.com/dequelabs/axe-core)
- [Lighthouse](https://github.com/GoogleChrome/lighthouse)
- [Testing Library](https://testing-library.com/)
- [WebAIM WCAG checklist](https://webaim.org/standards/wcag/checklist)
