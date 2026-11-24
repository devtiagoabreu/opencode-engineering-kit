# Capacidades adaptadas dos motores fiscais oficiais

**Verificado em:** 2026-11-24  
**Escopo:** padrões de engenharia e contrato de integração — **não** lógica tributária, não código copiado.

## Fontes oficiais

Todas as fontes abaixo pertencem à organização [ReceitaFederal](https://github.com/ReceitaFederal) no GitHub e foram confirmadas via API pública como `MIT` (arquivo `LICENSE` conferido nos repositórios de regime geral e DANFSe).

| # | Repositório | URL | Licença | Runtime observado |
|---|---|---|---|---|
| 18 | Calculadora RTC — Regime Geral | https://github.com/ReceitaFederal/calculadora-rtc-regime-regular | MIT | Java 25, Spring Boot 4.1.2, SQLite + Flyway, OpenAPI 3.1, API em `/api/calculadora` |
| 19 | Calculadora RTC — Simples Nacional | https://github.com/ReceitaFederal/calculadora-rtc-simples-nacional | MIT | Java 25, Spring Boot 4.1.2, SQLite + Flyway, OpenAPI 3.1, API em `/api` |
| 20 | Gerador DANFSe | https://github.com/ReceitaFederal/calculadora-rtc-gerador-danfse | MIT | Go 1.27+, Echo, PDF a partir de XML de NFS-e, logs JSON, OTel opt-in |

## Padrões adaptados

| Padrão observado na fonte oficial | Ativo derivado no kit | O que foi adaptado |
|---|---|---|
| Modo estrito (falha no primeiro erro) e modo de observabilidade (erro por item) | `fiscal-engine-integration`, `fiscal-calculation-record` | Dois modos explícitos; `open_items`; `approved_for_posting=false` enquanto houver erro |
| Códigos de erro estáveis com descrição consultável (`REG-011`, `VSN-001`) | `fiscal-engine-integration` | Dicionário de códigos, campo, ação, responsável e status no registro |
| `/versao` e `/versao/status`; base SQLite versionada com Flyway; perfil offline somente leitura | `fiscal-engine-integration` | `engine_version`, `database_version`, `rule_date` e perfil registrados em toda operação |
| Atividades vigentes por data com filtros por anexo, tipo de documento e `cClassTrib` | `fiscal-engine-integration` | Regra vigente na data da operação; recálculo com regra atual exige reclassificação aprovada |
| Dados abertos: CST/cClassTrib, fundamentações legais, NCM/NBS e alíquotas por ente federativo | `fiscal-engine-integration`, `fiscal-calculation-record` | `source_refs` por item; evidência anexada sem incorporar a base oficial |
| Geração e validação de XML contra XSD, distinguindo grupo de tributação e nota | `fiscal-engine-integration` | Gate de validação antes da geração do DANFSe; versão do XSD registrada |
| DANFSe: limite de XML, sanitização, `stc`, `canhoto`, health checks, OTel opt-in, fail-fast de configuração | `fiscal-engine-integration`, `fiscal-calculation-record` | Checklist operacional e de segurança, sem detector de PDF upstream |
| Logs JSON sem XML/PDF/IDs fiscais; `request_id` gerado pelo servidor; `5xx` genérico | `fiscal-engine-integration` | Regras de redaction e correlação no registro de cálculo |

## O que **não** foi copiado

- Código-fonte Java/Go, SQL de migração, banco SQLite, XSD, PDFs, binários ou WASM.
- Documentação longa, exemplos de requisição copiados, ícones, logos ou screenshots.
- Tabelas de alíquotas, CST/cClassTrib, NCM/NBS ou fundamentações legais — elas continuam na fonte oficial e devem ser consultadas pela API/documentação atual.
- Qualquer afirmação de que o kit substitui apuração, enquadramento ou parecer fiscal.

## Limites conhecidos

- O gerador DANFSe marca a distinção fina entre `400` e `5xx` como follow-up upstream; o kit não inventa essa classificação.
- Telemetria é opt-in nas fontes oficiais; configuração inválida falha o startup, mas falha de exportação não altera a resposta da requisição.
- Versões de runtime e endpoints devem ser reconfirmados a cada rodada `/aprenda`; este documento registra o estado verificado em 2026-11-24.

## Ativos derivados

- Skill: `fiscal-engine-integration` (`beta`)
- Template: `fiscal-calculation-record` (`beta`)
- Fila canônica: [docs/APRENDA_REPOSITORIOS.md](./APRENDA_REPOSITORIOS.md) — repositórios 18–20
