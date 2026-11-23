---
provenance:
  source: OpenCode Engineering Kit (community)
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-23
maturity: beta
name: bank-reconciliation
description: Concilie extratos bancários com o razão e o caixa usando regras de correspondência, trilha de evidências e tratamento explícito de divergências.
category: finance
version: 0.1.0
author: devtiagoabreu
tags: [finance, accounting, bank, reconciliation, extrato, conciliacao]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - Extrato bancário do período (OFX, CSV ou PDF)
  - Razão/caixa ou lançamentos internos do mesmo período
provides:
  - Regras de correspondência por valor, data e descrição
  - Classificação de divergências com responsável e prazo
  - Modelo de relatório de conciliação auditável
security:
  risk_level: low
  permissions:
    - filesystem
  audited: true
difficulty: intermediate
---

# Bank Reconciliation

## Overview

Bank reconciliation is not "matching lines until the balance agrees". It is a controlled process that explains every difference between what the bank recorded and what the company recorded. The output is evidence: each break has a cause, an owner and a disposition.

Use this skill for `extrato bancário` (bank statement) reconciliation, caixa, and bank-account-to-ledger controls.

## Prerequisites

- Statement covering the exact period, with opening and closing balances.
- Internal ledger entries for the same period, including transfers in transit.
- A chart of accounts and a defined cutoff rule (business day vs. bank day).
- A place to store evidence: spreadsheet, CSV or accounting system.

## Usage Instructions

### 1. Fix the period and the population

Record the statement date range, account identifier (masked), currency, opening balance and closing balance. Never reconcile against a partial export: totals must tie to the statement header.

### 2. Normalize both sides

Create a common shape for each line:

| Field | Rule |
|---|---|
| `date` | ISO date; keep both booking date and value date when available |
| `amount` | Signed number; positive entry, negative exit |
| `description` | Raw text preserved; never overwrite the original |
| `reference` | Document number, invoice id or bank reference |
| `source` | `bank` or `ledger` |
| `line_id` | Stable identifier from the source file |

Keep the original file immutable. Normalization is a derived view.

### 3. Match in conservative passes

Run matches from strongest to weakest and record which rule matched:

1. **Exact:** same amount, same value date, same reference.
2. **Amount + date window:** same amount within an agreed number of days.
3. **Amount + description:** same amount with normalized text (accents and case removed).
4. **Manual candidate:** flagged for human review, never auto-posted.

A candidate matched by a weaker rule must be reviewed. One bank line must not be split across several ledger lines without an explicit allocation record.

### 4. Classify every break

| Break | Typical cause | Action |
|---|---|---|
| Deposit in transit | Company recorded, bank not yet | Confirm next statement; no adjustment |
| Outstanding check/payment | Company recorded, bank not yet | Track aging; clear or cancel |
| Bank fee/interest | Bank recorded, company not yet | Post accrual or expense with owner approval |
| Direct debit/PIX not booked | Bank recorded, company not yet | Retrieve authorization and post |
| Amount difference | FX, rounding or partial payment | Document calculation and post difference |
| Duplicate | Repeated export or entry | Mark duplicate, do not delete evidence |
| Unknown | No explanation found | Escalate with deadline; do not force a match |

### 5. Prove the arithmetic

```text
Opening bank balance
+ bank credits
- bank debits
= Closing bank balance

Closing bank balance
+ deposits in transit
- outstanding payments
+/- unrecorded bank items
= Adjusted bank balance

Adjusted ledger balance must equal adjusted bank balance.
```

If the numbers do not tie, stop and list the unexplained difference. A "small difference" is still a finding.

### 6. Post and document

- Obtain approval before posting adjustments above the agreed threshold.
- Link each adjustment to the matched bank line and the supporting document.
- Record who prepared, who reviewed and the review date.
- Re-run the reconciliation after posting; the final report must be zero-open or carry an approved aging list.

### 7. Protect sensitive data

Bank statements contain personal and financial data. Mask account numbers in reports, avoid uploading raw files to third-party services, and delete working copies according to the company retention policy.

## Examples

### Example 1: Match record

```yaml
bank_line: B-2026-11-042
ledger_line: L-2026-11-091
amount: -1490.00
rule: amount_date_window_2d
reviewer: analista-financeiro
status: approved
evidence: invoice-2291.pdf
```

### Example 2: Reconciliation summary

```text
Opening: 12,400.00 | Credits: 31,200.00 | Debits: 27,850.00 | Closing: 15,750.00
In transit: 1,200.00 | Outstanding: -850.00 | Unrecorded fees: -40.00
Adjusted bank: 16,060.00 | Adjusted ledger: 16,060.00 | Open items: 0
```

## References

- Kit companions: `accounting-basics`, `financial-statements`, `controllership-close`
- Agent companions: `contador`, `controladoria`, `analista-financeiro`
- Template: `monthly-close-checklist`
