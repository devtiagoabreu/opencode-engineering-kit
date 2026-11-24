---
provenance:
  source: Receita Federal do Brasil — calculadora-rtc-regime-regular
  source_url: https://github.com/ReceitaFederal/calculadora-rtc-regime-regular
  license: MIT
  verified: 2026-11-24
maturity: beta
name: fiscal-engine-integration
description: Integre motores fiscais oficiais com base versionada, regras vigentes por data, erros observáveis, validação XML/XSD e geração de DANFSe auditável.
category: finance
version: 0.1.0
author: devtiagoabreu
tags: [fiscal, cbs, ibs, reforma-tributaria, observabilidade, xml, nfse, versionamento]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - Documentação oficial do motor fiscal (Swagger/README), sem copiar código ou banco
  - Regime tributário, data da operação e versão da base de regras
  - Definição de quais campos do documento fiscal são relevantes para a operação
provides:
  - Contrato de integração com modo estrito e modo observabilidade
  - Checklist de versionamento, vigência e rastreabilidade de regras
  - Registro de cálculo com erros por item, evidência e validação de documento
security:
  risk_level: low
  permissions:
    - filesystem
  audited: true
difficulty: advanced
---

# Fiscal Engine Integration

## Overview

Os motores oficiais da Receita Federal expõem o cálculo de CBS, IBS e Imposto Seletivo como API, com tabelas abertas, regras versionadas e dois modos de execução: **falha no primeiro erro** e **observabilidade com erro por item**. Este skill adapta esse contrato de engenharia — não a lógica tributária — para integrações auditáveis.

Use antes de chamar, automatizar ou registrar resultados de um motor fiscal. Ele responde: *qual versão das regras foi usada, por que cada item falhou e como o documento gerado foi validado?*

**Fontes oficiais verificadas em 2026-11-24** (todas MIT, organização `ReceitaFederal`):

| Repositório | Papel | Ideia adaptada |
|---|---|---|
| [calculadora-rtc-regime-regular](https://github.com/ReceitaFederal/calculadora-rtc-regime-regular) | Regime geral — CBS/IBS/Imposto Seletivo | Observabilidade por item, dados abertos, XML/XSD, base SQLite versionada com Flyway |
| [calculadora-rtc-simples-nacional](https://github.com/ReceitaFederal/calculadora-rtc-simples-nacional) | Simples Nacional — CBS/IBS | Atividades vigentes por data, filtros por anexo/tipo de documento/cClassTrib, `/versao` e `/versao/status` |
| [calculadora-rtc-gerador-danfse](https://github.com/ReceitaFederal/calculadora-rtc-gerador-danfse) | NFS-e → PDF (DANFSe) em Go | Limite de XML, sanitização, logs sem dados fiscais, health checks, OTel opt-in, fail-fast de configuração |

> Nenhum código, banco SQLite, binário, XSD, logo ou documento longo desses repositórios foi copiado para o kit. A licença MIT foi confirmada via API GitHub e arquivo `LICENSE`.

## Prerequisites

- Confirmar o repositório oficial e a licença antes de citar uma versão.
- Identificar o regime (geral ou Simples Nacional) e a data de referência da operação.
- Saber onde a aplicação registra `rule_version`, `database_version` e `engine_version`.
- Definir limites de tamanho e redaction de logs para XML/PDF e identificadores fiscais.

## Usage Instructions

### 1. Escolha o modo de execução

| Modo | Quando usar | Contrato |
|---|---|---|
| Estrito | Fechamento contábil, apuração, carga crítica | A operação inteira falha no primeiro erro; nada é publicado parcialmente |
| Observabilidade | Diagnóstico, migração, testes de massa, trilha de erros | Cada item retorna `ok` ou `error` com código estável; itens válidos continuam |

Registre qual modo foi usado. Nunca apresente um resultado parcial de observabilidade como apuração final.

### 2. Fixe a versão das regras

Antes de calcular, capture:

```yaml
engine: calculadora-rtc-regime-regular
engine_version: "<versão da aplicação>"
database_version: "<versão da base/migração>"
rule_date: 2026-11-24
profile: offline
```

O motor Simples Nacional expõe `/versao` e `/versao/status` (perfil offline compara com a instalação online). A base do regime geral é gerada por migrações Flyway e aberta em modo somente leitura. Um resultado sem versão não é reproduzível.

### 3. Aplique vigência, não "regra atual"

Para Simples Nacional, consulte atividades vigentes na `rule_date` e filtre por anexo, tipo de documento e `cClassTrib`. Para o regime geral, use CST/cClassTrib, NCM/NBS e fundamentações legais da data correta. Regras mudam; um documento de 2025 não pode ser recalculado com a tabela de 2026 sem reclassificação explícita.

### 4. Padronize o resultado por item

```yaml
request_id: "server-generated"
mode: observabilidade
regime: simples-nacional
rule_date: 2026-11-24
engine_version: "..."
database_version: "..."
items:
  - item_id: 1
    status: ok
    cst: "..."
    cclass_trib: "..."
    taxes: { cbs: 0.00, ibs: 0.00 }
    source_refs: ["fundamentacao:<id>", "ncm:<codigo>"]
  - item_id: 2
    status: error
    code: VSN-001
    message: "<descrição oficial do código>"
    field: "<caminho do campo na requisição>"
    source_refs: []
totals: { cbs: 0.00, ibs: 0.00 }
open_items: 1
approved_for_posting: false
```

Códigos de erro são estáveis (`REG-011`, `VSN-001`). Mantenha um dicionário de códigos com descrição oficial e tradução interna; não reinvente o significado.

### 5. Valide o documento antes de publicar

- Gere o XML a partir do resultado do cálculo e valide contra o XSD oficial, distinguindo **grupo de tributação** de **nota completa**.
- Para NFS-e, gere o DANFSe somente após o XML estar válido.
- Aplicável ao gerador oficial: limite de entrada (padrão 5 MiB), sanitização controlada, `stc` (0 válida, 1 substituída, 2 cancelada) e `canhoto`.
- Regenerate o PDF quando o XML ou a versão das regras mudar; nunca reutilize um PDF de versão anterior sem novo carimbo.

### 6. Operação segura do serviço

- Logs estruturados em `stderr`, um evento por requisição, com `request_id` gerado pelo servidor; **nunca** logar corpo XML, PDF, querystring, IDs fiscais ou headers de autenticação.
- Respostas `5xx` genéricas, sem `err.Error()`; cliente não deve receber detalhe interno.
- Health checks: `/health/live` para liveness e `/health/ready` para readiness; sinalize `unavailable` **antes** do graceful shutdown.
- Telemetria OTel é opt-in; configuração inválida deve falhar no startup, mas falha de exportação é assíncrona e não muda a resposta.
- Probes ficam fora de spans/telemetria.

### 7. Feche a trilha

Use o template `fiscal-calculation-record` para guardar: regime, data, versões, modo, itens, códigos de erro, validação XML/XSD, PDF gerado, responsável e aprovação. A trilha deve permitir responder "qual regra produziu este número?" meses depois.

## Examples

### Example 1: Fail-fast vs observabilidade

```text
Estrito: item 2 falha → nenhum resultado publicado; corrigir e recalcular.
Observabilidade: item 2 falha com VSN-001; itens 1 e 3 seguem válidos, mas
open_items=1 e approved_for_posting=false até resolução.
```

### Example 2: Reprodução

```text
Documento 2025-11: recalcular com rule_date=2025-11 e database_version daquele mês.
Se a base atual for usada, registrar reclassificação e aprovar a mudança.
```

## Guardrails

- Este skill é contrato de integração, **não parecer tributário**; a decisão de enquadramento cabe ao profissional responsável.
- Não vendore código, banco de dados, XSD, binários, ícones ou docs longos dos repositórios oficiais.
- Não trate `400` vs `5xx` como classificação definitiva: o próprio gerador DANFSe marca a distinção fina como follow-up upstream.
- Não faça log de dados fiscais sensíveis; use `request_id` para correlação.
- Não promova o ativo a `stable` sem revisão de qualidade e confirmação da licença/versão na rodada atual.

## References

- Mapping doc: `docs/FISCAL_ENGINE_CAPABILITIES.md`
- Kit companions: `tax-compliance`, `accounting-basics`, `financial-statements`, `controllership-close`
- Agent companions: `fiscal`, `contador`, `controladoria`
- Template: `fiscal-calculation-record`
