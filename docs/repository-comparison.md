# Análise comparativa — Repositórios similares ao OpenCode Engineering Kit

> Documento de análise para decisão. Data da coleta: 2026-08-11.
> Comparação baseada nos dados públicos do GitHub e na documentação de cada projeto.

## O que é o OpenCode Engineering Kit (este repositório)

Biblioteca open source de **recursos reutilizáveis** para agentes de código (OpenCode e compatíveis):
skills, agents (personas), prompts, templates, playbooks, recipes, comandos, bundles, composições e
prompt-chains, com **infraestrutura de núcleo** própria (registry, discovery, resolver/lockfile, version,
plugin, marketplace, security, quality), CLI npm (`npx opencode-engineering-kit`), interface web de
marketplace e testes automatizados.

- **Estado atual:** 150 skills (42 categorias), 103 agents (personas em 38 categorias), 10 prompts,
  4 templates, 3 playbooks, 2 recipes, 4 comandos, 2 bundles, 2 composições, 2 prompt-chains,
  25 suítes de teste, quality gates 8/8, typecheck 5/5.
- **Licença:** MIT. **Versão:** 0.1.0.- **Diferencial:** combina **biblioteca de conteúdo de domínio** (inclusive personas em português:
  educação, direito, política, saúde, comércio...) com **infraestrutura de engenharia** e procedência
  rastreável de cada asset.

---

## Tabela geral

| Repositório | Criador | Estrelas | Forks | Licença | Tipo |
|---|---|---|---|---|---|
| [obra/superpowers](https://github.com/obra/superpowers) | Jesse Vincent (Prime Radiant) | ~270k | ~24k | MIT | Metodologia + skills + plugins |
| [openclaw/openclaw](https://github.com/openclaw/openclaw) | Peter Steinberger (OpenClaw Foundation) | ~386k | ~81k | MIT | Assistente pessoal (runtime/agente) |
| [sickn33/agentic-awesome-skills](https://github.com/sickn33/agentic-awesome-skills) | Nick (sickn33) | ~45k | ~6,6k | MIT + CC BY 4.0 | Biblioteca instalável de 1.800+ skills |
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | Ali Reza Zavani | ~24k | ~3,4k | MIT (por-skill) | Coleção 345 skills + 30 agents |
| [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) | VoltAgent | ~30k | ~3,2k | MIT | Diretório curado 1.497+ skills |
| [anthropics/skills](https://github.com/anthropics/skills) | Anthropic | n/d | n/d | Source-available | Skills oficiais (~20) |
| [EliasOulkadi/shokunin](https://github.com/EliasOulkadi/shokunin) | Elias Oulkadi | 110 | 14 | MIT | Kit 62 skills + memória + MCP |
| [FrancoStino/opencode-skills-collection](https://github.com/FrancoStino/opencode-skills-collection) | Franco Stino | n/d (npm) | — | MIT | Plugin npm 1.000+ skills (SkillPointer) |
| [jshsakura/awesome-opencode-skills](https://github.com/jshsakura/awesome-opencode-skills) | jshsakura | 22 | 2 | MIT | Port de 136+ subagents → SKILL.md |
| [open-hax/opencode-skills](https://github.com/open-hax/opencode-skills) | open-hax | 6 | 0 | MIT | Coleção pequena de skills OpenCode |
| [hirefrank/skills](https://github.com/hirefrank/skills) | Frank (hirefrank) | 0 | 0 | MIT | Coleção de agent skills (pequena) |

> Nota: os dois "Shokunin" citados no nosso README — o link `hirefrank/shokunin` **não existe**
> (404); o repositório real com esse nome é `EliasOulkadi/shokunin`. O `hirefrank/skills` é uma
> coleção separada e pequena. Vale corrigir o link de inspiração no README.

---

## Análise individual + comparação com este kit

### 1. obra/superpowers — Jesse Vincent (Prime Radiant)

**Resumo:** a referência do ecossistema de *agentic skills*. Não é uma biblioteca de conhecimento —
é uma **metodologia completa de desenvolvimento** implementada como skills composáveis e auto-disparadas:
`brainstorming` → `using-git-worktrees` → `writing-plans` → `subagent-driven-development` →
`test-driven-development` → `requesting-code-review` → `finishing-a-development-branch`. Roda como
plugin em 11 harnesses (Claude Code, Codex, Cursor, Gemini CLI, GitHub Copilot, OpenCode, Pi,
Antigravity, Kimi, Factory Droid). Tem testes de skill-behavior (harness `superpowers-evals`),
pre-commit, versionamento e telemetria opcional.

**Comparação com este kit:**
- **Onde o Superpowers é melhor:** profundidade de *metodologia de engenharia* (TDD, subagents,
  worktrees, revisão em duas etapas), qualidade de execução e adoção massiva (~270k estrelas).
- **Onde este kit é melhor:** amplitude de **conteúdo de domínio** (150 skills e 103 personas, inclusive
  personas pt-BR de educação/direito/política/saúde), prompts/templates/playbooks/composições, e
  **infraestrutura própria** (registry, resolver com lockfile, version, plugin, marketplace, security,
  quality gates). O Superpowers não tem personas de domínio nem gerenciamento de versão de assets.
- **Complementaridade:** os dois são complementares — o Superpowers oferece o *workflow*, este kit
  oferece o *conteúdo*. O kit poderia adotar skills de metodologia (TDD, worktrees, planos) no estilo
  Superpowers e expor o Superpowers como plugin opcional na instalação.

---

### 2. VoltAgent/awesome-agent-skills — VoltAgent

**Resumo:** diretório **curado** (não gerado em massa — "hand-picked, not AI-slop generated") de
1.497+ skills provenientes de times oficiais (Anthropic, Google, Vercel, Stripe, Cloudflare, Netlify,
Trail of Bits, Sentry, Expo, Hugging Face, Figma, Microsoft, OpenAI, Supabase, HashiCorp, TestMu,
Angular, Composio e outros) e da comunidade. Compatível com Claude Code, Codex, Gemini CLI, Cursor,
OpenCode, Windsurf etc. Mantido pela VoltAgent (org por trás do framework TypeScript `voltagent`).

**Comparação com este kit:**
- **Onde o VoltAgent é melhor:** credibilidade das fontes (skills oficiais de grandes times) e
  atualização contínua; é o "portal" de descoberta do ecossistema.
- **Onde este kit é melhor:** o VoltAgent é apenas um **índice/diretório** (só README + CONTRIBUTING);
  não tem CLI, schema, validação, testes, resolução de dependências, personas estruturadas, prompts,
  templates ou infraestrutura. Este kit é **instalável e autocontido** (CLI + índices + testes).
- **Complementaridade:** o kit pode usar o VoltAgent como **fonte de curadoria** para enriquecer
  categorias existentes e citar referências oficiais nas skills (já fazemos isso com fontes verificadas).

---

### 3. EliasOulkadi/shokunin — Elias Oulkadi

**Resumo:** o "kit" mais próximo em espírito deste repositório. **62 skills de engenharia** em 10
domínios (infra, backend, frontend, mobile, qualidade, conteúdo, documentos, produtividade, agentes,
sistema) com frontmatter validado por CI, tabelas de decisão e fontes citadas. Adiciona **memória
persistente** (ChromaDB com recall multi-estratégia: vetorial + BM25 + temporal + RRF), 12 ferramentas
MCP, auto-update declarativo com detecção de drift, instalador de 1 linha (Windows/Linux) e multi-runtime
(OpenCode nativo; Claude, Cline, Cursor, Continue, Windsurf via templates). v4.2.3, MIT.

**Comparação com este kit:**
- **Onde o Shokunin é melhor:** sistema de **memória persistente** entre sessões (inexistente no kit),
  auto-update/auto-instalação e suíte de testes de memória; skills de engenharia mais "densas"
  (checklists de produção, anti-patterns).
- **Onde este kit é melhor:** escala (150 vs 62 skills; 103 personas que o Shokunin não tem),
  categorias de **domínio de negócio** (educação, direito, política, saúde, comércio, construção...),
  infraestrutura completa (registry/schema, resolver com lockfile, plugin, marketplace, security,
  quality gates com 6 dimensões), procedência rastreável e suporte multi-idioma (pt-BR/EN).
- **Complementaridade:** forte. Inspiração para adicionar (a) módulo de memória opcional, (b) melhores
  scripts de instalação/auto-update, (c) skills de engenharia com anti-patterns e checklists.

---

### 4. sickn33/agentic-awesome-skills (ex-antigravity-awesome-skills) — Nick (sickn33)

**Resumo:** a maior biblioteca **instalável** de skills: 1.800–2.000+ skills (reagregadas de fontes
oficiais como Anthropic, OpenAI, Vercel, Supabase, Microsoft, Google, Apify e de autores independentes).
CLI npm (`npx antigravity-awesome-skills`), bundles especializados por área, workflows, plugins para
Claude Code e Codex, catálogo web estático e **scan de segurança de SKILL.md** (padrões `curl|bash`,
`irm|iex`, tokens em linha de comando). Licença MIT (código) + CC BY 4.0 (conteúdo).

**Comparação com este kit:**
- **Onde o agentic-awesome-skills é melhor:** volume e curadoria agregada; scan de segurança
  automatizado nos PRs; escala de adoção (~45k estrelas).
- **Onde este kit é melhor:** o Agentic é uma **agregação de terceiros** (conteúdo CC BY 4.0, não
  auditado item-a-item), sem personas estruturadas, sem schema próprio de validação, sem resolver/
  lockfile, sem compatibilidade declarada por asset e sem personas de domínio pt-BR. Este kit é
  **autoral e autocontido**, com qualidade verificada por testes e procedência por asset.
- **Complementaridade:** o scan de segurança de SKILL.md é uma **boa prática para adotar** no nosso
  `core/security` (já temos `skill-spector`/SkillSpector como skill; falta o scan de padrões perigosos).

---

### 5. anthropics/skills — Anthropic

**Resumo:** repositório oficial da Anthropic com ~20 skills de referência: `skill-creator`,
`docx`/`pdf`/`xlsx`/`pptx`, `frontend-design`, `canvas-design`, `webapp-testing`, `mcp-builder`,
`brand-guidelines`, `algorithmic-art`, `theme-factory`, entre outras. Define o padrão de qualidade do
formato `SKILL.md`. **Licença source-available** (não é open source: pode usar, mas **não redistribuir**).

**Comparação com este kit:**
- **Onde a Anthropic é melhor:** autoridade e qualidade de escrita das skills; ferramentas de
  criação/avaliação de skills (`skill-creator` com benchmarks).
- **Onde este kit é melhor:** licença realmente aberta (MIT, redistribuível), escala (150 vs ~20),
  infraestrutura e personas de domínio.
- **Complementaridade:** adotar a metodologia do `skill-creator` (descrição orientada a trigger,
  avaliação com baseline) para melhorar a qualidade das nossas skills.

---

### 6. alirezarezvani/claude-skills — Ali Reza Zavani

**Resumo:** maior coleção **single-maintainer** do ecossistema: 345 skills, 30+ agents, 70+ slash
commands e matriz de cobertura de 8 IDEs. Inclui `skill-security-auditor` (análise estática de skills).
Licença por-skill; sem auditoria de segurança publicada (auditoria independente apontou ~18% de skills
com dependências questionáveis).

**Comparação com este kit:**
- **Onde o Zavani é melhor:** volume de skills de engenharia e cobertura multi-IDE.
- **Onde este kit é melhor:** consistência (schema único validado, testes), personas de domínio,
  procedência, qualidade verificada por suíte própria e clareza de licença (MIT uniforme).
- **Complementaridade:** ideia do `skill-security-auditor` reforça a adoção de scan de segurança no kit.

---

### 7. FrancoStino/opencode-skills-collection — Franco Stino

**Resumo:** plugin npm para OpenCode (2.368 downloads/semana, 428 versões) que **pré-empacota 1.000+
skills** universais e as injeta via arquitetura **SkillPointer**: as skills vivem num "cofre" oculto e
só entram no contexto sob demanda (~255 tokens no startup contra ~80k). Elimina latência de rede e loops
de compactação. Foi o antigo `opencode-skills-antigravity`.

**Comparação com este kit:**
- **Onde o FrancoStino é melhor:** distribuição como plugin npm com carregamento **on-demand** —
  resolve o problema real de custo de contexto/tokens.
- **Onde este kit é melhor:** qualidade/curatela do conteúdo, personas, infraestrutura e transparência
  (1.000+ skills empacotadas sem catálogo público detalhado por item).
- **Complementaridade:** o conceito de **carregamento sob demanda / catálogo em cofre** é a evolução
  natural do nosso `core/registry` + `core/discovery`.

---

### 8. jshsakura/awesome-opencode-skills — jshsakura

**Resumo:** port **automático 1:1** dos 136+ Codex subagents (de `VoltAgent/awesome-codex-subagents`)
para o formato nativo `SKILL.md` do OpenCode, com auto-sync semanal via GitHub Actions e instalação em
1 comando (PowerShell/bash/python).

**Comparação com este kit:**
- **Onde o jshsakura é melhor:** velocidade de conversão e sincronização automatizada com a fonte.
- **Onde este kit é melhor:** conteúdo autoral e auditado (não tradução automática), personas, schema,
  testes, infraestrutura completa.
- **Complementaridade:** inspiração para automatizar sync/port entre formatos (ex.: converter skills
  para `.claude/skills`, `.cursor/rules` — o kit já declara compatibilidade em cada asset).

---

### 9. open-hax/opencode-skills — open-hax

**Resumo:** coleção pequena (6 estrelas) de skills OpenCode organizadas por domínio, com foco em
descoberta de infraestrutura DevSecOps gratuita (workflow `devsecops-free-discovery`).

**Comparação:** projetos de natureza e escala bem diferentes — este kit é um ecossistema completo;
o open-hax é um conjunto temático. Relevância apenas como exemplo de formato `SKILL.md`.

---

### 10. hirefrank/skills — Frank (hirefrank)

**Resumo:** coleção pequena (0 estrelas, 7 commits) de agent skills com scripts e build em TypeScript
(`npx skills add https://github.com/hirefrank/skills`). É o projeto citado no nosso README como
"Shokunin" — mas o link `hirefrank/shokunin` está quebrado; o verdadeiro Shokunin é o do Elias Oulkadi.

**Comparação:** relevância baixa; não possui infraestrutura nem escala. Serve como lembrete para corrigir
a citação de inspiração no README do kit.

---

## Deep dive — os 3 mais relevantes

Critério: grau de sobreposição com o propósito do kit (biblioteca de assets + infraestrutura para
coding agents) e potencial de aprendizado.

### A. obra/superpowers — o "padrão-ouro" de metodologia

- **Arquitetura:** skills como "superpoderes" auto-disparados + bootstrap em `CLAUDE.md`/`AGENTS.md` +
  plugins por harness. O agente **checa skills antes de qualquer tarefa** (workflows obrigatórios,
  não sugestões).
- **O que o diferencia:** ciclo completo e fechado de engenharia (ideia → brainstorm → plan → execução
  por subagents → TDD → review → merge), com dois estágios de revisão (conformidade com o spec e depois
  qualidade de código).
- **Números:** ~270k estrelas, ~24k forks, 680 commits, 17+ skills.
- **Lições para o kit:**
  1. Skills de **metodologia/processo** (não só de domínio) — criar `tdd`, `git-worktrees`,
     `writing-plans`, `executing-plans`, `code-review` de 2 estágios no formato do kit.
  2. **Auto-disparo** via instruções de bootstrap e "checar skill antes de cada tarefa".
  3. **Testes de comportamento de skills** com harness de avaliação (nossa suíte cobre formato/
     qualidade; falta avaliar o *comportamento* disparado pela skill).
  4. **Plugin por harness** — o kit declara compatibilidade em cada asset, mas o Superpowers entrega
     empacotamento pronto por agente (`.claude-plugin`, `.codex-plugin`, `.opencode`...).

### B. VoltAgent/awesome-agent-skills — o "portal de descoberta"

- **Arquitetura:** README único como índice por time oficial + comunidade; cada skill linka para a
  fonte; sem código de runtime.
- **O que o diferencia:** credibilidade (skills de equipes reais: Stripe, Vercel, Cloudflare,
  HashiCorp, Trail of Bits...) e curadoria "não-AI-slop".
- **Números:** ~30k estrelas, ~3,2k forks, 442 commits, 1.497+ skills.
- **Lições para o kit:**
  1. **Atribuição de fonte por skill** — o kit já tem `provenance`; estender com link para a fonte
     oficial quando aplicável (ex.: `cloudflare` skill referenciando `cloudflare/skills`).
  2. **Estratégia de curadoria explícita** — declarar no CONTRIBUTING que skills são curadas e
     verificadas (não geradas em massa), como diferencial de segurança/qualidade.
  3. **Seções "oficiais"** por time na documentação (agrupar skills por autor oficial) — melhora
     confiança e navegação no marketplace-web.

### C. EliasOulkadi/shokunin — o "kit irmão"

- **Arquitetura:** 62 skills + memória ChromaDB (recall multi-estratégia: vetorial + BM25 + temporal +
  RRF) + 12 MCP tools + auto-update declarativo + instalador 1 linha + multi-runtime via templates
  (OpenCode nativo; Claude/Cursor/Cline/Continue/Windsurf por cópia de config).
- **O que o diferencia:** ser um "kit de uso" completo — instala, mantém (drift detection) e dá memória
  de longo prazo ao agente; é o mais parecido com o espírito deste repositório.
- **Números:** 110 estrelas, 14 forks, 176 commits, v4.2.3.
- **Lições para o kit:**
  1. **Memória persistente** (ChromaDB/SQLite local) como feature opcional — sessões contínuas sem
     re-explicar o projeto.
  2. **Auto-update com detecção de drift** — nosso `scripts/update.sh` e CLI ganham um manifesto
     declarativo + diff de versões.
  3. **Instalador 1-linha** (`bash <(curl -sL ...)`) com modo não-interativo (`-y`) e healthcheck.
  4. **Skills de engenharia "densas"** (checklists de produção, anti-patterns, fontes citadas) — o kit
     pode enriquecer as categorias `quality`, `devops`, `testing` com esse estilo.

---

## Comparação final: este repositório vs openclaw

### openclaw/openclaw — Peter Steinberger (Molty) / OpenClaw Foundation

**O que é:** um **assistente pessoal de IA autônomo e self-hosted** — não uma biblioteca de assets.
Roda como um runtime (Gateway local) que conecta modelos (hosted ou locais) a **50+ canais de
mensagem** (WhatsApp, Telegram, Slack, Discord, Signal, iMessage...) e **executa ações reais** no seu
hardware: limpar inbox, gerenciar calendário, shell, automação de browser, tarefas agendadas 24/7.
Inclui UI de controle (web/CLI/TUI), apps de voz/câmera, plugins, skills e o marketplace **ClawHub**
(~13k+ skills). Escrito em TypeScript/Node.js.

**Números:** ~386k estrelas, ~81k forks, 78k+ commits, criado nov/2025. É o repositório de crescimento
mais rápido da história do GitHub. História: Clawdbot → Moltbot → OpenClaw (renomeado para evitar
conflito de marca com a Anthropic). Fundado por Peter Steinberger; hoje governado pela OpenClaw
Foundation (não-lucrativa), com sponsors OpenAI, GitHub, NVIDIA, Vercel, Convex, Blacksmith.

**Aspectos de segurança:** sofreu com CVE-2026-33579 (RCE via WebSocket malicioso, CVSS 9.8) e com
instâncias expostas sem autenticação (~63%); mercado ClawHub teve skills maliciosas (auditoria da Snyk
encontrou 76 payloads confirmados). A resposta foi sandboxing por padrão + processo de vetting no
ClawHub + `openclaw doctor` para diagnóstico.

### Quadro comparativo

| Critério | OpenCode Engineering Kit | OpenClaw |
|---|---|---|
| **Natureza** | Biblioteca de assets (skills/agents/prompts/templates) + infraestrutura de núcleo | Runtime de assistente pessoal autônomo (Gateway + canais + execução) |
| **O que você instala** | Assets + CLI + market-place web (conteúdo para o seu agente) | Um agente que roda 24/7 no seu hardware |
| **Interface primária** | CLI `npx opencode-engineering-kit`, arquivos `SKILL.md`, `.opencode/` | CLI/TUI/Control UI, canais de mensagem, apps |
| **Execução de ações** | Instruções para o agente executar (não executa sozinho) | Executa de fato (shell, browser, arquivos, agendamentos) |
| **Conteúdo** | 150 skills autorais + 103 personas (pt-BR/EN) com procedência e testes | Consome skills do ClawHub (~13k, curadoria ainda em maturação) |
| **Modelos** | Agnóstico (OpenCode e compatíveis) | Multi-provider (hosted + local via Ollama), roteamento |
| **Memória persistente** | Contexto via `context/` (personas, HISTORY, provenance) | Memória de longo prazo entre sessões (vetorial + markdown) |
| **Marketplace** | `marketplace-web/` + `core/marketplace` (próprio) | ClawHub (externo, com vetting em desenvolvimento) |
| **Qualidade** | Schema + testes (25 suítes) + quality gates (8) + typecheck | QA/segurança: sandboxing, `openclaw doctor`, vetting ClawHub |
| **Licença** | MIT (totalmente redistribuível) | MIT |
| **Adoção** | Novo (0.1.0) | ~386k estrelas |
| **Risco principal** | Baixo (conteúdo estático, não executa nada) | Alto (agente autônomo com acesso ao host → histórico de CVEs) |

### Conclusões da comparação

1. **Não são concorrentes — são camadas complementares.** O kit fornece **conteúdo e padrões**
   (skills/personas/prompts) que qualquer agente usa; o OpenClaw é um **runtime autônomo** que consome
   skills. As skills do kit seguem o formato universal `SKILL.md`, que o OpenClaw também lê — ou seja,
   o kit pode alimentar um OpenClaw.
2. **Escala não é comparável em natureza:** ~386k estrelas de um projeto de 9 meses que virou fenômeno
   viral vs. um kit de engenharia novo; números de estrelas não medem o mesmo produto.
3. **Forças do kit sobre o OpenClaw:** (a) **qualidade verificada** — conteúdo autoral, testado e com
   procedência, contra um marketplace com histórico de skills maliciosas; (b) **licença limpa** (MIT
   autoral vs. skills de terceiros com licenças mistas); (c) **personas de domínio em pt-BR** que o
   ecossistema OpenClaw não tem; (d) **superfície de risco mínima** (conteúdo estático).
4. **Forças do OpenClaw sobre o kit:** (a) execução autônoma real e canais de mensagem; (b) memória de
   longo prazo; (c) adoção e comunidade; (d) modelo de marketplace com vetting e sandboxing.
5. **Lições para o kit a partir do OpenClaw:**
   - **Vetting/sandbox** no nosso `core/security`: scan de padrões perigosos em `SKILL.md`
     (`curl|bash`, `irm|iex`, tokens), como o agentic-awesome-skills já faz.
   - **Memória de longo prazo** (opcional, local-first) para o agente do kit.
   - **Governança** via fundação/organização e **política de segurança** pública (`SECURITY.md` +
     runbook de exposição) — o OpenClaw aprendeu isso na marra; o kit pode nascer já com isso.

---

## Recomendações prioritárias para o kit

1. **Corrigir o README:** trocar o link de inspiração `hirefrank/shokunin` (404) por
   `EliasOulkadi/shokunin`.
2. **Skills de metodologia** no estilo Superpowers (TDD, worktrees, plans, review em 2 estágios) —
   cobre a lacuna de *processo* (hoje o kit cobre domínio).
3. **Scan de segurança de SKILL.md** em `core/security` (padrões perigosos) + política `SECURITY.md`.
4. **Memória persistente opcional** (local-first, ChromaDB/SQLite) para sessões contínuas.
5. **Instalador 1-linha** e **auto-update com manifesto/drift** no CLI.
6. **Catálogo/marketplace com carregamento sob demanda** (SkillPointer) para reduzir tokens no startup.
7. **Atribuição de fonte oficial** por skill (link para times como Stripe/Vercel/Cloudflare quando a
   skill espelhar boas práticas oficiais).
8. **Documentar a estratégia de curadoria** ("hand-picked, verificado, com procedência") como
   diferencial de segurança em relação a marketplaces como ClawHub.

---

## Fontes

- github.com/obra/superpowers — Jesse Vincent (Prime Radiant), blog.fsck.com
- github.com/openclaw/openclaw — Peter Steinberger, docs.openclaw.ai, VISION.md, SECURITY.md
- github.com/VoltAgent/awesome-agent-skills — VoltAgent (voltagent)
- github.com/sickn33/agentic-awesome-skills — Nick (sickn33) (ex-antigravity-awesome-skills)
- github.com/EliasOulkadi/shokunin — Elias Oulkadi (docs/Shokunin-Technical-Overview)
- github.com/alirezarezvani/claude-skills — Ali Reza Zavani
- github.com/anthropics/skills — Anthropic
- github.com/FrancoStino/opencode-skills-collection — Franco Stino (npm)
- github.com/jshsakura/awesome-opencode-skills — jshsakura
- github.com/open-hax/opencode-skills — open-hax
- github.com/hirefrank/skills — hirefrank
- Dados de estrelas/forks via API do GitHub em 2026-08-11
