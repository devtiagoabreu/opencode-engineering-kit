# Handoff de sessão — estado para continuar na próxima sessão

**Registrado em:** 2026-11-24  
**Branch:** `main` · **HEAD:** `b820ea2` · **27 commits à frente de `origin/main`** · **sem push**  
**Árvore de trabalho:** limpa no momento deste registro.

Este documento é o ponto de partida da próxima sessão. Ele registra o que foi feito, por que, o que já passou nos gates e o que ainda está em aberto. Atualize-o ao final da próxima sessão.

---

## 1. Objetivo geral

Integrar capacidades reutilizáveis de repositórios de referência ao kit como ativos **adaptados**, com proveniência explícita, sem copiar código upstream. Manter a fila canônica de aprendizado (`/aprenda`), aprender também com os motores fiscais oficiais da Receita Federal e preservar o estado para continuidade entre sessões.

## 2. Regras que governam o trabalho

- `stable` **somente** via `profiles/core.json`. Todo ativo novo entra como `beta`.
- Todo ativo novo precisa de `provenance.source`, `provenance.source_url`, `provenance.license` e `provenance.verified` no frontmatter.
- Adaptar ideias, contratos e fluxos. **Não** vendorear código-fonte, docs longas, ícones, logos, screenshots, bancos de dados, XSDs ou binários.
- Dify e OpenViking permanecem como **ideias** (o OpenViking virou o skill `context-filesystem-memory`; nada foi copiado).
- Trabalho fiscal oficial usa **somente** repositórios da organização [`ReceitaFederal`](https://github.com/ReceitaFederal) no GitHub.
- Gates obrigatórios antes de commit: validador estrito, checagem UTF-8, checagem de contagens do README e `npm test`.
- **Não fazer push** salvo pedido explícito do usuário.

## 3. Commits desta sessão

| Commit | Assunto |
|---|---|
| `228522c` | `quality+ci: enforce explicit asset maturity/provenance/link policy` — base de política (PR-02) |
| `7a928ec` | `feat: integrate reference capabilities and finance learning assets` — integrações de referência, finanças/controladoria e entrada dos motores fiscais na fila |
| `b820ea2` | `feat: learn official fiscal engine integration patterns` — skill/template fiscais e mapeamento oficial |

## 4. Ativos criados/adaptados

### 4.1 Integrações de referência (6 repos)

Skill `beta`: `harness-engineering-patterns`, `context-filesystem-memory`, `browser-use-automation`, `memory-discipline`, `scientific-data-retrieval`, `diagram-design`.  
Comando: `/harness-review`, `/diagram`. Templates: `agent-session-handoff`, `harness-checklist`, `scientific-retrieval-ledger`.  
Mapeamento: `docs/REFERENCE_CAPABILITIES.md`.

### 4.2 Plataforma (11 repos nomeados)

Skills `beta`: `saas-blueprint-patterns`, `registry-distribution`, `database-branching-workflows`, `rls-tenancy-pattern`, `auth-plugin-architecture`, `ai-sdk-agent-patterns`, `llm-workflow-orchestration`, `usage-based-billing`, `transactional-email-patterns`, `privacy-first-analytics`, `self-host-deployment`.  
Templates: `saas-launch-checklist`, `billing-meter-spec`.  
Mapeamento: `docs/PLATFORM_REFERENCE_CAPABILITIES.md`.

### 4.3 Finanças / controladoria (pedido do `/aprenda`)

- Skills `beta`: `bank-reconciliation` (**extrato bancário** — interpretação adotada para “estrato”), `financial-statements` (DRE), `controllership-close` (fechamento, provisões, reconciliações).
- Agents `beta`: `analista-financeiro` (FP&A), `controladoria`.
- Template `beta`: `monthly-close-checklist`.
- Prioridades registradas em `docs/APRENDA_REPOSITORIOS.md`: extrato, DRE, FP&A e fechamento.

### 4.4 Motores fiscais oficiais (3 repos, todos MIT, verificados em 2026-11-24)

| # | Repositório | URL | Papel |
|---|---|---|---|
| 18 | Calculadora RTC — Regime Geral | https://github.com/ReceitaFederal/calculadora-rtc-regime-regular | CBS/IBS/Imposto Seletivo; base SQLite versionada por Flyway; modo observabilidade; XML/XSD |
| 19 | Calculadora RTC — Simples Nacional | https://github.com/ReceitaFederal/calculadora-rtc-simples-nacional | Vigência por data, filtros por anexo/tipo/`cClassTrib`, `/versao` e `/versao/status` |
| 20 | Gerador DANFSe | https://github.com/ReceitaFederal/calculadora-rtc-gerador-danfse | NFS-e → PDF; limite de XML, sanitização, logs sem dados fiscais, health checks, OTel opt-in |

Ativos derivados:
- Skill `beta`: `assets/skills/finance/fiscal-engine-integration/SKILL.md` — modo estrito vs. observabilidade, códigos de erro estáveis (`REG-011`, `VSN-001`), `engine_version`/`database_version`/`rule_date`, `open_items`, `approved_for_posting`, validação XML/XSD antes do DANFSe, redaction de logs.
- Template `beta`: `assets/templates/fiscal-calculation-record/README.md` — trilha de auditoria do cálculo com versões, itens, erros, validação e aprovação.
- Documento: `docs/FISCAL_ENGINE_CAPABILITIES.md` — fontes, licenças, padrões adaptados e, explicitamente, o que **não** foi copiado.

Nada de código Java/Go, SQL, banco SQLite, XSD, PDF, binário, logo ou documentação longa foi trazido para o kit.

## 5. Documentação e índices atualizados

- `docs/APRENDA_REPOSITORIOS.md`: fila canônica com **20 repositórios** (17 anteriores + 3 oficiais), protocolo do `/aprenda`, coberturas mapeadas e data de verificação 2026-11-24.
- `docs/FISCAL_ENGINE_CAPABILITIES.md`, `docs/REFERENCE_CAPABILITIES.md`, `docs/PLATFORM_REFERENCE_CAPABILITIES.md`.
- `context/provenance.md`: linhas de proveniência de skills **e** nova seção `## Templates`, incluindo `fiscal-calculation-record` (MIT, ReceitaFederal, 2026-11-24).
- `README.md` / `README_EN.md`: contagens, links de integrações (agora 20 repos) e linha da categoria `finance` com Fiscal Engine Integration.
- `CHANGELOG.md` e `docs/AUDIT_AND_PR_PLAN.md`: entradas para finanças e motores fiscais.
- Regenerados: `core/discovery/index/*`, `core/registry/index/*`, `core/registry/manifest.json`, `core/resolver/lockfile.json`, `core/resolver/dependency-graph.txt`, `core/version/compatibility-matrix.json`.

## 6. Estado validado

Contagens finais: **171 skills · 105 agents · 10 prompts · 11 templates · 7 commands**.

| Gate | Resultado |
|---|---|
| `python scripts/validate_assets.py --root . --check-manifest --check-links --strict-policy --json` | `ok: true`, `errors: []`, política `schema_version: 1`, `maturity_default: beta`, 5 links aspiracionais em allowlist |
| `python scripts/check_utf8.py .` | ok |
| `python scripts/sync_readme_counts.py --root . --check` | ok |
| `npm test` (em `cli/`) | **22/22 pass**, 0 falhas |

Avisos não bloqueantes: 5 links aspiracionais de arquitetura permitidos até 2026-12-31 e placeholders de templates ignorados pela checagem de links.

## 7. Particularidades do ambiente (importante)

- Unidade `C:` sem espaço livre. `npm test` e scripts Python precisam de `TEMP`, `TMP`, `TMPDIR` e `npm_config_cache` apontando para `E:/dev/opencode-engineering-kit/references/`.
- Comandos bash passam por `C:\Program Files\Git\bin\bash.exe`; o Python no Windows não entende caminhos Git Bash (`/e/...`) — usar caminhos `E:/...` nas variáveis de ambiente.
- `scripts/test.sh` tem **4 falhas pré-existentes/de ambiente** (paths Git Bash no Python Windows e limiares de performance com `C:` cheio). Não são regressões deste trabalho.
- Logs e scripts auxiliares de validação ficam em `references/` (gitignored): `fiscal_finalize.sh`, `fiscal-validate.log`, `fiscal-npm-test.log`, `precommit_check.sh`, `precommit.log`, `commit_fiscal.sh`, `verify_commit.sh`, `verify-commit.txt`.

### Sequência de regeneração

```bash
bash core/discovery/index.sh
bash core/registry/generate.sh
bash core/resolver/lock.sh
bash core/resolver/graph.sh > /dev/null
bash core/version/compatibility.sh
bash scripts/generate-manifest.sh
python scripts/sync_readme_counts.py --root .
```

### Validação

```bash
python scripts/validate_assets.py --root . --check-manifest --check-links --strict-policy --json
python scripts/check_utf8.py .
python scripts/sync_readme_counts.py --root . --check
# npm test com TEMP/TMP/TMPDIR/npm_config_cache em E:/
```

## 8. Em aberto / próximos passos

1. **Pergunta não respondida:** o usuário citou “12 repositórios” de plataforma, mas nomeou 11. Falta o nome do 12º. Ao retomar, perguntar e, se fornecido, adicionar à fila e ao mapeamento.
2. Continuar a fila `/aprenda` a partir do que ainda não foi convertido em ativo; revalidar versões/endpoints dos motores fiscais a cada rodada (o documento registra o estado em 2026-11-24).
3. Promover ativos a `stable` **somente** após revisão de qualidade e confirmação de licença/versão, sempre via `profiles/core.json`.
4. Corrigir `scripts/test.sh` para paths Windows e limiares realistas, se o usuário quiser abrir esse escopo.
5. **Não push** sem autorização explícita (27 commits locais aguardando).

## 9. Frases-chave para localizar no repo

- `docs/APRENDA_REPOSITORIOS.md` — fila canônica e protocolo do `/aprenda`.
- `docs/SESSION_HANDOFF.md` — este documento.
- `docs/FISCAL_ENGINE_CAPABILITIES.md` — mapeamento fiscal oficial e exclusões.
- `/aprenda` — gatilho do aprendizado contínuo.
- `context/provenance.md` — proveniência de skills e templates.
