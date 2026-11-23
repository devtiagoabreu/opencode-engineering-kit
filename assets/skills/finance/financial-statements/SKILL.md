---
provenance:
  source: OpenCode Engineering Kit (community)
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-23
maturity: beta
name: financial-statements
description: Monte a DRE e concilie demonstrações contábeis com o razão, usando estrutura consistente, análises verticais/horizontais e rastreabilidade por conta.
category: finance
version: 0.1.0
author: devtiagoabreu
tags: [finance, dre, demonstracoes, accounting, fp&a, variancia]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - Balancete ou razão do período
  - Plano de contas e regras de classificação
  - Período comparativo (opcional, mas recomendado)
provides:
  - Estrutura padrão de DRE
  - Fórmulas de indicadores e análise de variâncias
  - Checklist de consistência entre DRE, balanço e fluxo de caixa
security:
  risk_level: low
  permissions:
    - filesystem
  audited: true
difficulty: intermediate
---

# Financial Statements (DRE)

## Overview

A DRE (`Demonstração de Resultados do Exercício`) is a structured answer to one question: how did the company made money in the period? Build it from classified ledger balances, not from a memory of what should be there. Every line must be traceable to one or more accounts.

## Prerequisites

- Trial balance (`balancete`) with opening balances, movements and closing balances.
- Chart of accounts mapped to DRE lines.
- Definition of gross sales deductions and which expenses are operating, financial or tax.
- Comparativo do período anterior ou orçamento para análise de variação.

## Usage Instructions

### 1. Lock the period and the rules

Record start date, end date, currency, consolidation scope and the classification version. If the chart of accounts changes mid-period, document the mapping used so the comparativo is fair.

### 2. Build the DRE in this order

| Linha | Conteúdo típico |
|---|---|
| Receita bruta | Vendas de produtos, serviços, outras receitas operacionais |
| (-) Deduções | Devoluções, abatimentos, impostos incidentes sobre a receita |
| = Receita líquida | Base para margens |
| (-) Custo da venda | Custo direto do produto ou serviço |
| = Lucro bruto | Receita líquida − custo |
| (-) Despesas operacionais | Comercial, administrativa, logística, tecnologia |
| = Resultado operacional | Lucro bruto − despesas operacionais |
| (+/-) Resultado financeiro | Juros, variação cambial, rendimentos |
| = LAIT | Lucro antes do imposto |
| (-) IR/CSLL | Provisão ou imposto apurado |
| = Lucro líquido | Resultado final do período |

Add EBITDA and EBIT only as derived indicators; state exactly which items you add back. Do not mix tax, interest and depreciation adjustments across periods without disclosure.

### 3. Tie to the ledger

For each DRE line keep a mapping:

```yaml
line: receita_liquida
accounts: [4010, 4020, 4110]
period: 2026-11
balance: 482300.00
source: balancete-2026-11.csv
```

The sum of all mapped accounts must reconcile to the trial balance. Revenue and expense accounts should close to zero after transfer to result; investigate balances that do not.

### 4. Apply the cutoff rule

Recognize revenue when the performance obligation is satisfied, and expenses when incurred — not when cash moves. A cash-based view belongs in the fluxo de caixa, not in the DRE. List accruals and prepaid items explicitly.

### 5. Add two analyses

- **Vertical:** each line as a percentage of receita líquida. Useful for margens and comparability across company sizes.
- **Horizontal:** variation versus prior period or budget, in absolute value and percentage. Explain variations above the agreed threshold.

```text
Receita líquida: 482,300 (100.0%) | anterior 440,100 | variação +42,200 (+9.6%)
Lucro bruto:     188,097 (39.0%) | anterior 176,040 | variação +12,057 (+6.8%)
```

A margin drop with revenue growth deserves a sentence, not only a number.

### 6. Cross-check the three statements

- DRE lucro líquido flows into lucros retidos no balanço (equity), after distributions.
- Depreciation and working-capital changes connect DRE to fluxo de caixa operacional.
- Balanço must satisfy `Ativo = Passivo + Patrimônio Líquido`.

If the statements do not connect, the period is not closed.

### 7. Present with a data dictionary

Include: period, classification version, currency, rounding rule, meaning of each derived indicator, and the name of the person who approved the classification. Avoid reclassifying prior periods silently; restate and disclose.

## Examples

### Example 1: DRE resumida

```text
Receita bruta                 530,000
(-) Deduções                  -47,700
= Receita líquida             482,300
(-) Custo da venda           -294,203
= Lucro bruto                 188,097
(-) Despesas operacionais    -121,400
= Resultado operacional         66,697
(-) Resultado financeiro        -8,200
= LAIT                          58,497
(-) IR/CSLL                    -12,884
= Lucro líquido                 45,613
```

### Example 2: Finding a classification error

```text
Finding: "Taxa de cartão" está em despesas financeiras.
Rule: taxa de cartão sobre vendas é dedução da receita.
Action: reclassificar R$ 6,210; recalcular margem bruta; registrar versão 2 da DRE.
```

## References

- Kit companions: `accounting-basics`, `bank-reconciliation`, `controllership-close`, `business-intelligence`
- Agent companions: `analista-financeiro`, `controladoria`, `contador`
- Template: `monthly-close-checklist`
