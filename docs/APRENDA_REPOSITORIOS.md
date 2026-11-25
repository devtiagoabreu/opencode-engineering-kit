# Fila de aprendizado contínuo (`aprenda`)

**Idioma:** português  
**Status:** ativo — esta é a lista canônica a ser usada sempre que o usuário disser `aprenda`.  
**Última verificação:** 2026-11-25 — 32 repositórios/fontes na fila + curadoria de UI/SaaS, Vercel/JS e Python em `docs/WEB_UI_VERCEL_PYTHON_RESEARCH.md` (API do GitHub em 403; stars aproximados e licenças confirmadas na página dos repositórios)

## Protocolo

Quando o usuário disser **“aprenda”**:

1. Leia este arquivo antes de pesquisar qualquer coisa.
2. Para **todos** os repositórios abaixo, verifique mudanças desde a `Última verificação`: releases, `README`, `AGENTS.md`, diretórios de skills/commands, licenças e novos padrões reutilizáveis.
3. Compare com os ativos já existentes em `assets/skills`, `assets/templates` e `assets/commands`. Não duplique skills como `shadcn-ui`, `multi-tenant-saas`, `postgresql-database`, `authentication`, `llm-multi-provider`, `rag-llm`, `docker-best-practices` ou `monitoring-observability`.
4. Adapte **ideias, fluxos e checklists**. Não vendore código, documentação longa, ícones, logos, screenshots nem templates upstream.
5. Todo ativo novo continua `beta` e precisa de `provenance.source`, `source_url`, `license` e `verified` no frontmatter. Licenças com condições extras (ex.: OpenViking/AGPL-3.0, Dify Open Source License) entram apenas no nível de ideia.
6. Atualize os mapas `docs/REFERENCE_CAPABILITIES.md` e/ou `docs/PLATFORM_REFERENCE_CAPABILITIES.md`, `context/provenance.md`, READMEs e `CHANGELOG.md`.
7. Regere índices, lockfile, matriz de compatibilidade e manifest; rode `python scripts/validate_assets.py --root . --check-manifest --check-links --strict-policy`, `python scripts/check_utf8.py .`, `python scripts/sync_readme_counts.py --root . --check` e `npm test` em `cli/`.
8. Relate o que mudou, o que foi intencionalmente não copiado e atualize a `Última verificação` deste arquivo. Se o 12º repositório citado pelo usuário ainda não tiver nome, pergunte qual é.

## Repositórios — obrigatórios em toda rodada

| # | Repositório | URL | Licença verificada | Ativos já derivados | Foco da próxima leitura |
|---|---|---|---|---|---|
| 1 | Awesome Harness Engineering | https://github.com/ai-boost/awesome-harness-engineering | CC0-1.0 | `harness-engineering-patterns`, `/harness-review`, `harness-checklist` | Novos padrões de harness, avaliações e portas de verificação |
| 2 | OpenViking | https://github.com/volcengine/OpenViking | AGPL-3.0 (somente ideias) | `context-filesystem-memory` | Memória em sistema de arquivos, camadas de contexto e recuperação — sem copiar texto/código |
| 3 | Browser Use | https://github.com/browser-use/browser-use | MIT | `browser-use-automation` | Automação de navegador, estabilidade de seletores e observabilidade |
| 4 | agentmemory | https://github.com/rohitg00/agentmemory | Apache-2.0 | `memory-discipline` | Disciplina de memória de agentes, consolidação e recuperação |
| 5 | Scientific Agent Skills | https://github.com/K-Dense-AI/scientific-agent-skills | MIT | `scientific-data-retrieval`, `scientific-retrieval-ledger` | Fontes científicas, citação e rastreabilidade de evidências |
| 6 | Diagram Design | https://github.com/cathrynlavery/diagram-design | MIT | `diagram-design`, `/diagram` | Composição de diagramas — sem copiar ícones ou galeria |
| 7 | Open SaaS | https://github.com/wasp-lang/open-saas | MIT | `saas-blueprint-patterns`, `saas-launch-checklist` | Fatias verticais de SaaS, instruções para agentes e prontidão de deploy |
| 8 | shadcn/ui | https://github.com/shadcn-ui/ui | MIT | `registry-distribution` (o skill `shadcn-ui` já cobre componentes) | Registro copy-in, namespaces, validação de manifest e segurança de registry |
| 9 | Neon | https://github.com/neondatabase/neon | Apache-2.0 | `database-branching-workflows` | Branching copy-on-write, previews, TTL e restauração pontual |
| 10 | Supabase | https://github.com/supabase/supabase | Apache-2.0 | `rls-tenancy-pattern` | RLS, claims JWT, papéis privilegiados, storage e isolamento |
| 11 | Better Auth | https://github.com/better-auth/better-auth | MIT | `auth-plugin-architecture` | Plugins de autenticação, organizações/times, 2FA/passkeys e credenciais de agentes |
| 12 | AI SDK | https://github.com/vercel/ai | Apache-2.0 | `ai-sdk-agent-patterns` | API uniforme de providers, output validado, tools, streaming e limites de loop |
| 13 | Dify | https://github.com/langgenius/dify | Dify Open Source License (Apache-2.0 + condições extras; somente ideias) | `llm-workflow-orchestration` | DSL de workflow, gates humanos, caminhos de falha, traces e RAG |
| 14 | Polar | https://github.com/polarsource/polar | Apache-2.0 | `usage-based-billing`, `billing-meter-spec` | Eventos → meters → preços, créditos, idempotência e margem por cliente |
| 15 | React Email | https://github.com/resend/react-email | MIT | `transactional-email-patterns` | Templates tipados, preview, HTML + texto, acessibilidade e compatibilidade entre clientes |
| 16 | Umami | https://github.com/umami-software/umami | MIT | `privacy-first-analytics` | Eventos mínimos, sem cookies, UTC, features opcionais e auto-hospedagem |
| 17 | Coolify | https://github.com/coollabsio/coolify | Apache-2.0 | `self-host-deployment` | Control plane vs. workloads, previews, rollback, segredos e backups |
| 18 | Receita Federal — Calculadora RTC (Regime Geral) **← motor fiscal principal** | https://github.com/ReceitaFederal/calculadora-rtc-regime-regular | MIT | `fiscal-engine-integration`, `fiscal-calculation-record`, `docs/FISCAL_ENGINE_CAPABILITIES.md` | API oficial CBS/IBS/Imposto Seletivo; banco SQLite versionado por Flyway; modo observabilidade com erros por item; dados abertos (CST/cClassTrib, NCM/NBS, fundamentação, alíquotas); geração e validação XML/XSD |
| 19 | Receita Federal — Calculadora RTC (Simples Nacional) | https://github.com/ReceitaFederal/calculadora-rtc-simples-nacional | MIT | `fiscal-engine-integration`, `fiscal-calculation-record` | CBS/IBS no Simples Nacional; atividades vigentes por data com filtros; `/versao` e `/versao/status`; reusa o banco do repositório 18 |
| 20 | Receita Federal — Gerador DANFSe | https://github.com/ReceitaFederal/calculadora-rtc-gerador-danfse | MIT | `fiscal-engine-integration`, `fiscal-calculation-record` | PDF de NFS-e a partir de XML; limite de tamanho, sanitização, logs sem dados fiscais, health checks, OTel opt-in e fail-fast de configuração |
| 21 | safety-quotient-lab/psychology-agent | https://github.com/safety-quotient-lab/psychology-agent | Apache-2.0 | `mental-health-crisis-protocol` (somente ideias de *epistemic flags*/anti-sycophancy) | Alpha; nunca adotar `dangerouslySkipPermissions` |
| 22 | ironyjk/counsel-frameworks | https://github.com/ironyjk/counsel-frameworks | MIT | `counseling-frameworks` | 14 frameworks + roteador + anti-padrões |
| 23 | theneoai/awesome-skills | https://github.com/theneoai/awesome-skills | NOASSERTION | `counseling-frameworks` | Persona psychologist: safety screen, disclaimers, escopo |
| 24 | rhavekost/clinical-toolkit | https://github.com/rhavekost/clinical-toolkit | NOASSERTION | `evidence-based-scales`, `mental-health-crisis-protocol` | Pontuação/corte PHQ-9, GAD-7, PCL-5, C-SSRS; checar licença dos instrumentos |
| 25 | salikkhann/openmedskills | https://github.com/salikkhann/openmedskills | NOASSERTION | `people-governance-psychology` | `risk_class`, `phi_allowed`, `diagnosis: false`, revisão humana |
| 26 | FreedomIntelligence/OpenClaw-Medical-Skills | https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills | não declarada | `adhd-executive-function`, `mental-health-crisis-protocol` | Somente ideias; licença ausente — não copiar texto |
| 27 | robcushard-nth/autism_skills_suite | https://github.com/robcushard-nth/autism_skills_suite | MIT | `neurodiversity-support` | Revisão por adultos autistas e clínicos; verificar divergência de nome do fork |
| 28 | tuanductran/hr-skills | https://github.com/tuanductran/hr-skills | MIT | `people-governance-psychology` | Router-first, gate de jurisdição; evitar vigilância contínua de bem-estar |
| 29 | polar-bear-org/claude-skills | https://github.com/polar-bear-org/claude-skills | custom (sem revenda) | `people-governance-psychology` | `hr-dashboard`, concern log em duas passagens; somente ideias |
| 30 | msitarzewski/agency-agents | https://github.com/msitarzewski/agency-agents | MIT | `psicologo-organizacional`, `people-governance-psychology` | `organizational-psychologist`: evidência > pop psychology |
| 31 | Emo-gml/Awesome-Mental-Health-LLMs | https://github.com/Emo-gml/Awesome-Mental-Health-LLMs | MIT | referência bibliográfica | Survey revisado por pares (TAFFC) — fundamentar, não copiar prompts |
| 32 | Edmondson / Deci & Ryan / WHO / NICE / ISO 30414 / SHRM / EU AI Act / NIST | https://www.who.int/publications/i/item/9789240053052 | várias (normas pagas: referenciar) | `people-governance-psychology`, `psicologo-organizacional` | Segurança psicológica, motivação, JD-R, health at work, capital humano, alto risco em IA de emprego |

> Os repositórios 18–20 são oficiais: organize GitHub [@ReceitaFederal](https://github.com/ReceitaFederal). Foram adicionados à fila de aprendizado e seus padrões estão mapeados em [docs/FISCAL_ENGINE_CAPABILITIES.md](./FISCAL_ENGINE_CAPABILITIES.md); nenhum código, banco, XSD ou binário foi instalado neste kit.

## Temas prioritários (pedido do usuário)

O usuário pediu que `aprenda` também cubra conciliação de extrato, montagem de DRE, finanças, analista financeiro e controladoria. Correção de digitação: **extrato** (não “estrato”).

| Tema | Status | Ativos de apoio |
|---|---|---|
| Conciliação de extrato bancário | Coberto | `bank-reconciliation`, skill `accounting-basics`, agente `contador` |
| Montar DRE / demonstrações contábeis | Coberto | `financial-statements`, `accounting-basics`, agente `analista-financeiro` |
| Finanças / FP&A / fluxo de caixa / KPIs | Coberto em nível gerencial | `analista-financeiro`, `business-intelligence`, `usage-based-billing` |
| Analista financeiro | Coberto | agente `analista-financeiro` |
| Controladoria / fechamento / provisões | Coberto | agente `controladoria`, skill `controllership-close`, template `monthly-close-checklist` |
| Auditoria e evidências de fechamento | Coberto | `controllership-close`, `monthly-close-checklist` |
| Integração com motor fiscal oficial (RTC/DANFSe) | Coberto | `fiscal-engine-integration`, `fiscal-calculation-record`, `docs/FISCAL_ENGINE_CAPABILITIES.md` |

Em cada rodada `aprenda`, verifique também se esses temas evoluíram: novas normas contábeis, requisitos de SPED, formatos de extrato e práticas de fechamento. Novos ativos continuam `beta` com proveniência explícita.

## Pendência

O usuário mencionou **“12 repositórios”** na segunda leitura, mas nomeou apenas **11** (Open SaaS, shadcn/ui, NeonDB, Supabase, Better Auth, AI SDK, Dify, Polar, React Email, Umami, Coolify). Os 11 estão acima. Pergunte qual é o 12º antes de encerrar uma rodada `aprenda`.

## Saída esperada de uma rodada

- Lista de mudanças relevantes por repositório (ou “sem mudanças” com a data verificada).
- Ativos novos/atualizados com proveniência e maturidade.
- Validação executada com resultado (`ok`/`failing`).
- Próxima pergunta em aberto — atualmente: nome do 12º repositório.
