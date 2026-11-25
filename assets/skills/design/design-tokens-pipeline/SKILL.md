---
provenance:
  source: "OpenCode Engineering Kit (community) — padrões adaptados de W3C Design Tokens Community Group format, Style Dictionary, tokens-studio/sd-transforms, primer/primitives e plugin87/ux-ui-agent-skills"
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: design-tokens-pipeline
description: "Pipeline de design tokens em formato DTCG: $value/$type, aliases, três camadas, temas, transform CSS/TS e validação de contraste no CI."
category: design
version: 0.1.0
author: devtiagoabreu
tags: [design-tokens, dtcg, style-dictionary, oklch, temas, contraste, ci]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Node.js 20+ e um projeto com pipeline de build de estilos
  - Escala de cor, tipografia, espaçamento e raio já decidida ou a definir nesta etapa
provides:
  - Estrutura DTCG com $value, $type e aliases por referência
  - Arquitetura primitive → semantic → component com regras de dependência
  - Transform para CSS custom properties e constantes TypeScript
  - Gate de contraste e proibição de valores hardcoded no CI
---

# Pipeline de Design Tokens

## Overview

Design tokens são a **única fonte de verdade** para decisões visuais. Esta skill define um pipeline determinístico: JSON no formato da Design Tokens Community Group (DTCG), três camadas de abstração, temas e modos, transform para CSS/TypeScript e validação no CI.

Sem pipeline, cada componente reinventa cor e espaçamento; o resultado é dark mode quebrado, contraste não medido e ajustes que precisam ser repetidos em dez arquivos. Com pipeline, mudar uma intenção (`action.bg`) propaga para todas as superfícies.

Regras de ouro:

1. **Componente nunca consome valor cru.** Ele consome token semântico ou de componente.
2. **Dependência é unidirecional:** componente → semântico → primitivo.
3. **Arquivos gerados não são editados à mão.** Mude a fonte e rode o build.
4. **Todo par de cor usado junto precisa de contraste medido** em cada tema.
5. **CI reprova valor hardcoded em componente.**

## Prerequisites

- Node.js 20+ com `npm` e acesso para instalar dependências de build.
- Decisão prévia sobre os eixos de tema: esquema de cor (`light`/`dark`) e, se houver, densidade (`comfortable`/`compact`).
- Nomes de estados de componente acordados: `default`, `hover`, `focus`, `disabled`, `error`, `loading`.

## Formato DTCG

Cada token é um objeto com `$value` (valor ou alias) e `$type` (natureza). `$description` é opcional e útil para intenção. Alias usa a sintaxe de referência entre chaves; o resolvedor substitui o caminho pelo valor final.

```json
{
  "primitive": {
    "color": {
      "blue": {
        "500": {
          "$value": "oklch(0.55 0.16 255)",
          "$type": "color",
          "$description": "Passo da rampa; não usar diretamente em componentes"
        }
      }
    },
    "space": {
      "4": { "$value": "0.25rem", "$type": "dimension" }
    },
    "radius": {
      "md": { "$value": "8px", "$type": "dimension" }
    }
  },
  "semantic": {
    "color": {
      "action": {
        "bg": { "$value": "{primitive.color.blue.500}", "$type": "color" }
      },
      "surface": {
        "default": { "$value": "oklch(0.99 0.005 250)", "$type": "color" }
      },
      "text": {
        "primary": { "$value": "oklch(0.22 0.02 250)", "$type": "color" }
      }
    }
  },
  "component": {
    "button": {
      "bg": {
        "default": { "$value": "{semantic.color.action.bg}", "$type": "color" }
      }
    }
  }
}
```

- Use `$type` explícito mesmo quando o grupo permite herança; isso evita erro no transform.
- Tipos comuns: `color`, `dimension`, `fontFamily`, `fontWeight`, `duration`, `cubicBezier`, `number`.
- Não use `$value` com comentário embutido; documentação vai em `$description`.
- Formato DTCG é draft da Community Group: fixe a versão do resolvedor e valide com a versão instalada antes de adotar extensões.

## As três camadas

| Camada | Finalidade | Nome típico | Pode referenciar |
|---|---|---|---|
| Primitiva | Rampas e escalas cruas, sem intenção de produto | `primitive.color.blue.500` | Nada |
| Semântica | Papel e intenção; muda conforme tema/modo | `semantic.color.action.bg` | Primitiva |
| Componente | Superfície e estado específicos | `component.button.bg.hover` | Semântica |

O componente `button` pode ter `bg.default`, `bg.hover`, `bg.focus`, `bg.disabled` e `fg.default`. Se um estado não tem token, ele ainda precisa de regra — por exemplo, `disabled` derivado de `semantic.color.text.muted` com opacidade controlada por token de `number`, nunca por literal no CSS do componente.

Nomes semânticos descrevem **uso**, não aparência: `action.bg` é bom; `blue500Button` não. Se o time troca a marca de azul para verde, apenas a camada primitiva muda.

## Temas e modos

Organize a fonte por arquivos, mantendo as mesmas chaves semânticas em cada tema:

```text
tokens/
  primitives.json
  semantic.json
  component.json
  themes/
    light.json
    dark.json
    compact.json
```

- `light.json` e `dark.json` sobrescrevem **valores semânticos**, não a estrutura do componente.
- `compact.json` é um eixo de densidade: altera `semantic.space.*`, não cor.
- O conjunto de chaves de `light` e `dark` deve ser idêntico. Chave faltante é erro de build, não `undefined` no CSS.
- aliases circulares (`a → b → a`) são erro de build.
- Não coloque segredos, URLs de ambiente ou dados de usuário em tokens: tokens são públicos por definição.

## Transform com Style Dictionary e tokens-studio

```bash
npm i -D style-dictionary @tokens-studio/sd-transforms colorjs.io
npx style-dictionary build --config=config/style-dictionary.config.json
```

Exemplo de entrada do build (confirme a API na versão fixada do pacote):

```js
import StyleDictionary from 'style-dictionary';
import { registerTransforms } from '@tokens-studio/sd-transforms';

registerTransforms(StyleDictionary);
const sd = StyleDictionary.extend('./config/style-dictionary.config.json');
sd.buildAllPlatforms();
```

O config declara uma plataforma `css` com `css/custom-properties` e uma plataforma `ts` com saída tipada. Use prefixo curto e estável (`--ds-`). Gere arquivos com cabeçalho "gerado automaticamente — não editar". Escolha uma política: commits incluem `dist/` e o CI confere que está atualizado, ou `dist/` é gerado no build e nunca versionado. As duas opções são válidas; mista não é.

## Saída CSS e TypeScript

```css
:root {
  --ds-color-action-bg: oklch(0.55 0.16 255);
  --ds-color-action-fg: oklch(0.99 0.005 255);
  --ds-color-surface-default: oklch(0.99 0.005 250);
  --ds-space-4: 0.25rem;
  --ds-radius-md: 8px;
}

:root[data-theme="dark"] {
  --ds-color-action-bg: oklch(0.72 0.14 255);
  --ds-color-surface-default: oklch(0.19 0.015 250);
}
```

```ts
export const ds = {
  color: {
    actionBg: 'var(--ds-color-action-bg)',
    actionFg: 'var(--ds-color-action-fg)',
  },
  space: { s4: 'var(--ds-space-4)' },
  radius: { md: 'var(--ds-radius-md)' },
} as const;
```

Exportar `var(...)` em TypeScript mantém o tema reativo. Valores literais no TS só quando o consumidor não é navegador (por exemplo, um gerador de imagem); nesse caso, documente o tema usado.

## Proibição de valores hardcoded

Configuração ESLint para cor literal em componentes:

```js
'no-restricted-syntax': [
  'error',
  {
    selector: 'Literal[value=/^#([0-9a-f]{3}|[0-9a-f]{6}|[0-9a-f]{8})$/i]',
    message: 'Use um token semântico; cores vivem em tokens/primitives.json.',
  },
];
```

Verificação complementar no CI:

```bash
if rg -n '#[0-9A-Fa-f]{3,8}' src/components; then
  echo "ERRO: cor hardcoded em componente"
  exit 1
fi
```

A mesma regra vale para `oklch(...)`, `rgb(...)` e números de espaçamento soltos em componentes. Exceções precisam de comentário com dono e data, e devem ser temporárias.

## Validação de contraste no CI

A cada build, resolva os aliases e calcule a razão de contraste dos pares que realmente aparecem juntos. Exemplo ilustrativo — confirme a API da versão instalada de `colorjs.io`:

```ts
import { readFileSync } from 'node:fs';
import Color from 'colorjs.io';

const built = JSON.parse(readFileSync('dist/tokens.json', 'utf8'));
const ratio = (fg: string, bg: string) =>
  new Color(fg).contrast(new Color(bg), 'WCAG21');

const pares = [
  ['text.primary', 'surface.default', 4.5],
  ['text.muted', 'surface.default', 4.5],
  ['action.fg', 'action.bg', 4.5],
  ['border.subtle', 'surface.default', 3],
] as const;

for (const tema of ['light', 'dark']) {
  const t = built.themes[tema];
  for (const [fg, bg, min] of pares) {
    const r = ratio(t[fg], t[bg]);
    if (r < min) {
      throw new Error(`${tema}: ${fg}/${bg} = ${r.toFixed(2)} < ${min}`);
    }
  }
}
```

Inclua também os estados `hover`, `focus` e `error` na matriz de pares. Contraste de token não substitui contraste renderizado: componentes podem sobrepor superfícies, então complemente com o gate de axe do `a11y-audit` em light e dark.

## Erros comuns

| Erro | Sintoma | Correção |
|---|---|---|
| Alias circular | Build falha ou valores vazios | Detectar ciclo no resolvedor e corrigir a referência |
| Componente referenciando primitiva | Troca de marca exige editar componentes | Passar a referência pela camada semântica |
| Tema com chaves diferentes | Variável ausente em dark | Validar paridade de chaves no CI |
| Edição direta em `dist/` | Build sobrescreve a mudança | Editar fonte e regenerar |
| Hex no componente | Tema ignorado | ESLint + `rg` no CI |
| Contraste medido só na primitiva | Par real falha ao compor | Medir pares semânticos por tema e estado |
| `$type` ausente | Transform gera unidade errada | Declarar `$type` em cada token |
| Token de componente sem estado | Hover/focus viram literal | Completar a matriz de estados |

## Checklist de saída

- [ ] JSON validado contra o formato DTCG fixado no projeto.
- [ ] Três camadas presentes, com dependência apenas no sentido componente → semântico → primitivo.
- [ ] Temas light/dark com o mesmo conjunto de chaves; densidade separada quando existir.
- [ ] Build gera CSS e TS sem editar arquivos gerados manualmente.
- [ ] Zero cores literais em `src/components`.
- [ ] Pares de contraste verificados por tema e por estado, com números no log do CI.
- [ ] Relatório de axe em light/dark anexado ao mesmo commit.

## Limites

Tokens não garantem acessibilidade: eles só tornam a medição possível. O formato DTCG é uma especificação em evolução; não confie em extensões sem fixar e testar a ferramenta. Esta skill não substitui `ui-visual-craft` (composição) nem `a11y-audit` (verificação renderizada).

## Referências

- [Design Tokens Community Group — format](https://design-tokens.github.io/community-group/format/)
- [Style Dictionary](https://amzn.github.io/style-dictionary/)
- [tokens-studio/sd-transforms](https://github.com/tokens-studio/sd-transforms)
- [primer/primitives](https://github.com/primer/primitives)
- [WCAG 2.2 Quick Reference](https://www.w3.org/WAI/WCAG22/quickref/)
