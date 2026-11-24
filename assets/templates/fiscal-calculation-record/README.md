---
maturity: beta
name: {{operation_id}}
description: Registro auditável de cálculo fiscal — {{regime}} — {{operation_date}}
version: {{version}}
author: {{author}}
category: finance
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
---

# {{operation_id}} — Registro de cálculo fiscal

## Usage

Preencha uma linha por item e uma linha por erro. Anexe a evidência da regra vigente e do XML validado. Só marque `approved_for_posting` quando `open_items` for zero e o revisor tiver assinado.

## Contexto

| Campo | Valor |
|---|---|
| Operação | {{operation_id}} |
| Regime | {{regime}} |
| Data da operação | {{operation_date}} |
| Data da regra aplicada | {{rule_date}} |
| Motor | {{engine}} |
| Versão da aplicação | {{engine_version}} |
| Versão da base de regras | {{database_version}} |
| Perfil | {{profile}} |
| Modo de execução | {{mode}} |
| Requisição | {{request_id}} |
| Preparador | {{preparer}} |
| Revisor | {{reviewer}} |

## Itens

| # | Descrição | CST | cClassTrib | NCM/NBS | CBS | IBS | Status | Evidência |
|---|---|---|---|---|---:|---:|---|---|
| {{item_1}} | {{desc_1}} | {{cst_1}} | {{cclass_1}} | {{ncm_1}} | {{cbs_1}} | {{ibs_1}} | {{status_1}} | {{evidence_1}} |
| {{item_2}} | {{desc_2}} | {{cst_2}} | {{cclass_2}} | {{ncm_2}} | {{cbs_2}} | {{ibs_2}} | {{status_2}} | {{evidence_2}} |

## Erros de observabilidade

| Código | Item | Campo | Descrição oficial | Ação | Responsável | Status |
|---|---|---|---|---|---|---|
| {{error_code_1}} | {{error_item_1}} | {{error_field_1}} | {{error_desc_1}} | {{action_1}} | {{owner_1}} | {{error_status_1}} |

Dicionário de códigos consultado em: {{error_catalog_url}}

## Validação do documento

- [ ] XML gerado a partir do resultado {{operation_id}}
- [ ] XSD oficial aplicado: {{xsd_version}}
- [ ] Tipo validado: {{document_type}} (grupo de tributação / nota completa)
- [ ] Diferenças corrigidas e registradas: {{validation_notes}}
- [ ] DANFSe gerado após validação: {{danfse_file}}
- [ ] `stc={{stc}}`, `canhoto={{canhoto}}`, tamanho do XML {{xml_size_bytes}} bytes

## Operação e segurança

- [ ] Logs sem XML, PDF, IDs fiscais, querystring ou credenciais
- [ ] `request_id` gerado pelo servidor e usado para correlação
- [ ] `/health/live` e `/health/ready` verificados
- [ ] OTel opt-in revisado: {{otel_status}}

## Fechamento

- [ ] `open_items = {{open_items}}`
- [ ] Recálculo com a mesma versão reproduziu os totais
- [ ] Revisor diferente do preparador
- [ ] `approved_for_posting = {{approved_for_posting}}`
- [ ] Aprovado em {{approval_date}} por {{approver}}

## Questões abertas

1. {{open_question_1}}
2. {{open_question_2}}
