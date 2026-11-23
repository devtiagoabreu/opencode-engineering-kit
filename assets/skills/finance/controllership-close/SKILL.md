---
provenance:
  source: OpenCode Engineering Kit (community)
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-23
maturity: beta
name: controllership-close
description: Conduza o fechamento mensal da controladoria com calendário, conciliações, provisões, revisão e evidências auditáveis.
category: finance
version: 0.1.0
author: devtiagoabreu
tags: [controllership, fechamento, close, conciliacao, provision, auditoria]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Calendário de fechamento e responsáveis
  - Acesso ao razão, extratos e relatórios de apoio
  - Política contábil e limites de aprovação
provides:
  - Sequência de tarefas do fechamento
  - Matriz de conciliações obrigatórias
  - Checklist de revisão e evidências
security:
  risk_level: low
  permissions:
    - filesystem
  audited: true
difficulty: advanced
---

# Controllership Close

## Overview

Controllership (`controladoria`) owns the reliability of the numbers. The monthly close is a controlled sequence of cutoffs, reconciliations, accruals, reviews and approvals — not a scramble to publish a DRE. A close is done when the evidence supports the report.

## Prerequisites

- Published close calendar with day-by-day owners and dependencies.
- Chart of accounts, accounting policies and approval limits.
- Prior-period report and budget for variance comparison.
- Reconciliation store with immutable support files.

## Usage Instructions

### 1. Publish the close calendar

| Dia | Tarefa | Responsável | Saída |
|---|---|---|---|
| D-2 | Avisar corte e congelar parâmetros | Controladoria | Aviso registrado |
| D+1 | Cortar receitas e despesas | Contabilidade | Movimento classificado |
| D+2 | Conciliações bancárias e caixa | Analista financeiro | Relatório zero-open |
| D+3 | Provisões e accruals | Controladoria | Lançamentos aprovados |
| D+4 | Conciliações de CR, CP, estoque e impostos | Contabilidade | Relatórios assinados |
| D+5 | DRE, balanço e fluxo de caixa | Analista financeiro | Minuta |
| D+6 | Revisão e variâncias | Controladoria | Ata de revisão |
| D+7 | Aprovação e distribuição | CFO/Sócio | Relatório final |

Adjust the days, never the sequence.

### 2. Enforce the cutoff

- Revenue: recognize when the obligation is fulfilled, not when the bank receives the cash.
- Expenses: accrue invoices received after cutoff that belong to the period.
- Prepaid and unbilled items: list with contract, period and amount.
- Mark any manual post-after-close entry; it requires a new version and an approver.

### 3. Run the mandatory reconciliation matrix

| Conta | Conciliação com | Evidência |
|---|---|---|
| Bancos | Extrato bancário | `bank-reconciliation` report |
| Caixa | Arquivo de PDV/contagem | Fechamento de caixa assinado |
| Contas a receber | Fatura/aging | Relação de títulos em aberto |
| Contas a pagar | Fornecedor/aging | Confirmação saldo |
| Estoque | Contagem/inventário | Relatório de inventário |
| Impostos | Apuração fiscal | Guia/SPED conciliado |
| Folha | eSocial/arquivo de folha | Folha aprovada |
| Receita | Pedidos/faturamento | Relatório de faturamento |

Every row needs `saldo contábil`, `saldo esperado`, `diferença`, `explicação`, `responsável` and `status`.

### 4. Post provisions with a reason

Provisions (férias, rescisões, honorários, devoluções, créditos duvidosos) must cite the policy, the calculation basis and the approver. Reverse previous provisions explicitly; silent netting hides changes in estimate.

### 5. Review before publishing

- Variance above threshold explained with owner and action.
- DRE ties to the trial balance; balanço balances; lucro líquido connects to equity.
- Open reconciliation items have an aging and an approved carry-forward.
- No unsupported manual journal entry.
- Preparer and reviewer are different people; both are named.

### 6. Keep an audit packet

Store the close calendar, supported reconciliations, journal entries, approval records, final reports and the classification version in one read-only folder per period. Name files with period and version so a report can be reproduced months later.

### 7. Improve the next cycle

Track late tasks, recurring breaks, rework and days-to-close. Convert each recurring finding into a control or an automation. A close that depends on heroics is a control failure.

## Examples

### Example 1: Open item carry-forward

```yaml
account: bancos_conta_01
difference: 850.00
reason: pagamento agendado, compensação no próximo dia útil
owner: analista-financeiro
due: 2026-12-01
approved_by: controladoria
carry_forward: true
```

### Example 2: Close gate

```text
[ ] Todas as conciliações zero-open ou com aging aprovado
[ ] Provisões aprovadas com base documentada
[ ] DRE, balanço e fluxo de caixa consistentes
[ ] Variâncias acima do limite explicadas
[ ] Preparador ≠ revisor
[ ] Pacote de auditoria versionado
```

## References

- Kit companions: `bank-reconciliation`, `financial-statements`, `accounting-basics`, `tax-compliance`
- Agent companions: `controladoria`, `contador`, `analista-financeiro`
- Template: `monthly-close-checklist`
