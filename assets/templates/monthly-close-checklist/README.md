---
maturity: beta
name: {{period}}
description: Checklist de fechamento mensal para {{company}}
version: {{version}}
author: {{author}}
category: project
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
---

# {{period}} — Fechamento Mensal

## Usage

Preencha uma linha por tarefa, conciliação e provisão. Anexe a evidência correspondente e só marque a porta de liberação após a revisão de uma pessoa diferente do preparador.

## Responsáveis

| Papel | Nome | Aprovado por |
|---|---|---|
| Preparador | {{preparer}} | {{reviewer}} |
| Revisor | {{reviewer}} | {{approver}} |
| Aprovador final | {{approver}} | — |

## Calendário

| Dia | Tarefa | Responsável | Status | Evidência |
|---|---|---|---|---|
| {{cutoff_day}} | Corte de receitas e despesas | {{owner_1}} | {{status}} | {{evidence_1}} |
| {{recon_day}} | Conciliações bancárias e caixa | {{owner_2}} | {{status}} | {{evidence_2}} |
| {{provision_day}} | Provisões e accruals | {{owner_3}} | {{status}} | {{evidence_3}} |
| {{report_day}} | DRE, balanço e fluxo de caixa | {{owner_4}} | {{status}} | {{evidence_4}} |
| {{review_day}} | Revisão e variâncias | {{owner_5}} | {{status}} | {{evidence_5}} |

## Conciliações obrigatórias

| Conta | Conciliação com | Saldo contábil | Saldo esperado | Diferença | Explicação | Owner |
|---|---|---|---|---|---|---|
| Bancos | Extrato {{bank_account}} | {{bank_ledger}} | {{bank_statement}} | {{bank_diff}} | {{bank_note}} | {{owner_2}} |
| Caixa | Contagem/PDV | {{cash_ledger}} | {{cash_count}} | {{cash_diff}} | {{cash_note}} | {{owner_2}} |
| Contas a receber | Aging | {{ar_ledger}} | {{ar_aging}} | {{ar_diff}} | {{ar_note}} | {{owner_6}} |
| Contas a pagar | Aging/fornecedor | {{ap_ledger}} | {{ap_aging}} | {{ap_diff}} | {{ap_note}} | {{owner_6}} |
| Estoque | Inventário | {{inv_ledger}} | {{inv_count}} | {{inv_diff}} | {{inv_note}} | {{owner_7}} |
| Impostos | Apuração fiscal | {{tax_ledger}} | {{tax_return}} | {{tax_diff}} | {{tax_note}} | {{owner_8}} |

## Provisões

| Provisão | Base de cálculo | Valor | Política | Aprovada por |
|---|---|---|---|---|
| {{provision_1}} | {{basis_1}} | {{amount_1}} | {{policy_1}} | {{approver}} |
| {{provision_2}} | {{basis_2}} | {{amount_2}} | {{policy_2}} | {{approver}} |

## Demonstrações

- [ ] DRE gerada a partir do balancete {{trial_balance_version}}
- [ ] Balanço satisfaz Ativo = Passivo + Patrimônio Líquido
- [ ] Lucro líquido conectado ao patrimônio líquido
- [ ] Fluxo de caixa reconcilia variação de caixa
- [ ] Análise vertical e horizontal incluída
- [ ] Variâncias acima de {{threshold}} explicadas

## Portas de liberação

- [ ] Nenhum item crítico sem explicação aprovada
- [ ] Preparador diferente do revisor
- [ ] Versão da classificação registrada: {{classification_version}}
- [ ] Pacote de auditoria arquivado em {{archive_path}}
- [ ] Relatório final aprovado em {{approval_date}}

## Questões abertas

1. {{open_question_1}}
2. {{open_question_2}}
