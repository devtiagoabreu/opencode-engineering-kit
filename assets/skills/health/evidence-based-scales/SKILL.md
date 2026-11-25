---
provenance:
  source: OpenCode Engineering Kit (community) — instrumentos de domínio público/livre uso (PHQ, GAD, PCL-5, WHO-5) e padrões de rhavekost/clinical-toolkit e alexclowe/awesome-claude-cowork-plugins
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: evidence-based-scales
description: Aplicação e leitura responsável de escalas de rastreio (PHQ-9/2, GAD-7, WHO-5, PCL-5, C-SSRS), com pontuação, limites e encaminhamento — nunca diagnóstico
category: health
version: 0.1.0
author: devtiagoabreu
tags: [escalas, phq-9, gad-7, who-5, pcl-5, cssrs, rastreio, saude-mental]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Consentimento informado e contexto de uso educacional
  - Dados pseudonimizados e mínimos (LGPD)
provides:
  - Tabela de pontuação e faixas de severidade
  - Regras de tendência e gatilhos de encaminhamento
  - modelos de saída com disclaimers e limites de interpretação
---

# Escalas de Rastreio Baseadas em Evidências

## Overview

Escalas são **sinais estruturados**, não diagnósticos. Use-as para organizar a conversa, acompanhar tendências e decidir encaminhamento. A pontuação **nunca** substitui avaliação clínica.

Antes de aplicar qualquer escala:

1. Explique para que serve e que não é diagnóstico.
2. Permita responder "prefiro não responder".
3. Aplique item a item, sem induzir resposta.
4. Ao terminar, rode sempre o gate `mental-health-crisis-protocol` se houver item de risco.

## Prerequisites

- Consentimento informado e finalidade educacional declarada
- Dados pseudonimizados e mínimos, conforme LGPD
- Disponibilidade do gate `mental-health-crisis-protocol` para itens de risco

## Tabela de referência rápida

| Instrumento | Faixa | Pontuação | Interpretação (rastreio) | Atenção |
|---|---|---|---|---|
| **PHQ-9** (depressão, 2 semanas) | 0–27 | 0–4 mínimo; 5–9 leve; 10–14 moderado; 15–19 moderadamente grave; 20–27 grave | ≥10 sugere avaliação; ≥15 priorizar | **Item 9 > 0 → gate de crise imediato** |
| **PHQ-2** (rastreio inicial) | 0–6 | ≥3 sugere depressão → aplicar PHQ-9 | Não é diagnóstico | Integrar ao fluxo do PHQ-9 |
| **GAD-7** (ansiedade, 2 semanas) | 0–21 | 0–4 mínimo; 5–9 leve; 10–14 moderado; 15–21 grave | ≥10 sugere avaliação | Piora ≥4 pontos merece revisão |
| **WHO-5** (bem-estar) | 0–25 (índice ×4) | ≤12 ou índice <50 sugere baixo bem-estar | >50 costuma indicar bem-estar preservado | Verificar termos de uso antes de uso comercial |
| **PCL-5** (TEPT, 1 mês) | 0–80 | ~31–33 sugere TEPT provável | 5–9 = mudança clinicamente relevante | Confirmar com avaliação especializada |
| **PC-PTSD-5** (rastreio breve) | 0–5 | ≥3 sugere avaliação | Não é diagnóstico | Encaminhar para avaliação |
| **C-SSRS** (suicídio) | graus 1–5 de ideação + comportamentos | 1 desejo de morrer → 5 plano com intenção | Qualquer ideação ativa exige o protocolo de crise | Ver item 9 do PHQ-9 |

> As faixas são **gerais**. Contexto, idade, comorbidades e culturalidade mudam a leitura. Nunca apresente "você tem depressão" — apresente "sua pontuação fica na faixa X; isso indica procurar avaliação".

## Regras de tendência

Não interprete uma única aplicação como evolução. Para tendência:

```yaml
minimo_para_tendencia:
  escalas: 3 aplicacoes   # ex.: baseline + 2 reavaliações
  diario: 7 dias          # suficiente para padrões de humor
sinais_de_alerta:
  - "PHQ-9 item 9 > 0 em qualquer aplicação"
  - "Piora >= 5 pontos/mês em PHQ-9 ou GAD-7"
  - "WHO-5 <= 12 com piora sustentada"
  - "PCL-5 com aumento >= 5 pontos"
acao:
  - rodar mental-health-crisis-protocol
  - registrar data, pontuação e encaminhamento oferecido
```

## Fluxo de aplicação

```text
1. Contexto + consentimento
2. Aplicar item a item (texto literal, sem induzir)
3. Somar e mapear faixa
4. Checar itens de risco (PHQ-9 item 9, ideação, meios)
5. Entregar resultado em linguagem simples + disclaimer
6. Decidir: psicoeducação | encaminhar em 48-72h | encaminhar em 24h | emergência
7. Registrar mínimo necessário e reagendar reavaliação
```

## Modelo de saída

```markdown
**Escala aplicada:** GAD-7 (rastreio, não diagnóstico)
**Data:** 2026-11-25  **Respostas:** 7/7
**Pontuação:** 12/21 — faixa moderada

**O que isso significa:** seus sintomas de ansiedade nas últimas duas semanas
merecem atenção. Isso não é um diagnóstico, mas é um sinal para conversar com
um profissional de saúde.

**Próximo passo sugerido:** agendar avaliação com psicólogo(a) ou médico(a);
se houver piora rápida ou pensamentos de se machucar, procurar urgência ou CVV 188.

**Reavaliação:** em 2 semanas, com a mesma escala.
```

## Anti-padrões

| Anti-padrão | Correção |
|---|---|
| "Seu PHQ-9 é 16, você tem depressão grave" | "Sua pontuação ficou na faixa X; procure avaliação" |
| Aplicar escala sem explicar finalidade | Consentimento e explicação curta antes |
| Interpretar uma única medição como melhora/piora | Exigir pelo menos 3 medições ou 7 dias |
| Ignorar item 9 com "é só 1" | Qualquer >0 aciona o protocolo de crise |
| Coletar nome/CPF/dados clínicos completos | Pseudônimo e mínimo necessário (LGPD) |
| Misturar escalas em uma única nota sem data | Registrar instrumento, data e pontuação separadamente |

## Exemplo de raciocínio

```yaml
entrada: "PHQ-9=16; item9=1; GAD-7=13; sem plano relatado"
classificacao:
  phq9: "moderadamente grave"
  gad7: "moderado"
  risco: "moderado-alto (item 9 positivo)"
acao:
  - rodar mental-health-crisis-protocol antes de qualquer psicoeducação
  - "Procurar avaliação presencial em até 24-48h"
  - "CVV 188 disponível 24h"
  - reavaliar_em: "7 a 14 dias"
nao_fazer: ["diagnostico", "medicacao", "promessa de cura"]
```

## Referências

- [PHQ-9 / GAD-7 — Pfizer (domínio público)](https://www.phqscreeners.com/)
- [WHO-5 Well-Being Index — WHO](https://www.who.int/tools/who-5)
- [PCL-5 — U.S. Department of Veterans Affairs](https://www.ptsd.va.gov/professional/assessment/adult-sr/ptsd-checklist.asp)
- [C-SSRS — Columbia University](https://cssrs.columbia.edu/)
- [rhavekost/clinical-toolkit](https://github.com/rhavekost/clinical-toolkit)
- [alexclowe/awesome-claude-cowork-plugins — clinical-mental-health](https://github.com/alexclowe/awesome-claude-cowork-plugins)

> Conteúdo original adaptado dos padrões citados. Verifique sempre os termos de uso de cada instrumento antes de distribuição comercial.
