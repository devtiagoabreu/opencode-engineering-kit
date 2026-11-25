# OpenCode Engineering Kit

> Kit de engenharia para acelerar o trabalho com OpenCode: Skills, Agents, Prompts, Templates, Playbooks, Comandos e Contexto prontos para uso — instaláveis em qualquer repositório em segundos.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/devtiagoabreu/opencode-engineering-kit)
[![OpenCode](https://img.shields.io/badge/OpenCode-compatible-brightgreen.svg)](https://opencode.ai)
[![CI](https://github.com/devtiagoabreu/opencode-engineering-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/devtiagoabreu/opencode-engineering-kit/actions/workflows/ci.yml)

## Sobre o projeto

O **OpenCode Engineering Kit** é uma biblioteca open source de recursos reutilizáveis para desenvolvedores que usam o [OpenCode](https://opencode.ai) (e ferramentas compatíveis). Ele resolve um problema comum: em vez de recriar do zero configs, prompts e fluxos de trabalho a cada projeto, você instala o kit e ganha de imediato um conjunto padronizado e testado de **skills, agents, prompts, templates, playbooks, comandos e contexto**.

Inspirado em projetos como [Shokunin](https://github.com/EliasOulkadi/shokunin) e [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill), o kit é **simples (markdown puro), modular, portátil e agnóstico de modelo**.

> **Status:** em evolução ativa. Diagnóstico e direção de execução em [docs/AUDIT_AND_PR_PLAN.md](./docs/AUDIT_AND_PR_PLAN.md).

### Estado atual

| Item | Quantidade |
|------|-----------|
| Skills | 190 (42 categorias) |
| Agents | 108 (38 categorias) |
| Prompts | 10 |
| Templates | 11 |
| Playbooks | 3 |
| Recipes | 2 |
| Comandos | 7 |
| Bundles | 2 |
| Composições | 2 |
| Prompt chains | 2 |
| Contexto | 17 arquivos |
| Plugins de exemplo | 1 (`asset-linter`) |
| Suítes de teste | 26 shell + 3 CLI (26 testes `node:test`) |

> Contagens sincronizadas de `core/registry/manifest.json` via `python scripts/sync_readme_counts.py --root .` (verificado em CI).

### Compatibilidade

| Plataforma | Status |
|------------|--------|
| OpenCode | ✅ Primária (formato nativo) |
| Claude Code | ✅ Compatível (via `CLAUDE.md`) |
| Cursor | ✅ Compatível (via `.cursor/rules/`) |
| GitHub Copilot | ⚠️ Parcial (via instruções) |

---

## Quick start (5 minutos)

```bash
cd /caminho/para/seu-projeto
npx opencode-engineering-kit install
npx opencode-engineering-kit status
npx opencode-engineering-kit list --type skills
npx opencode-engineering-kit search docker
```

Depois, reinicie o OpenCode. O kit fica em `.opencode/` e o `opencode.json` é mesclado (não sobrescrito).

> **Nota:** o pacote npm `opencode-engineering-kit@0.1.0` está publicado no registry. Os comandos `npx ...` abaixo funcionam diretamente. Para usar um checkout local (desenvolvimento), adicione `--source /caminho/para/opencode-engineering-kit`. O procedimento de publicação está no [playbook npm](./docs/NPM_PUBLISH_PLAYBOOK.md).

## Instalação

### Pré-requisitos

- **Git 2.0+** — para clonar e instalar via script
- **Bash 4.0+** — para os scripts de instalação (Linux/macOS/WSL)
- **Node.js 18+** — para instalar via CLI (`npx`)
- **`tar`** disponível no PATH (usado pela CLI; Linux/macOS já trazem; Git for Windows inclui)

---

### Método 1 — CLI: instalar em um repositório existente (recomendado)

A forma mais rápida de usar o kit dentro de **qualquer projeto que você já tem**. A CLI baixa o kit, copia os assets para `.opencode/` e atualiza o `opencode.json` do projeto — sem clonar nada manualmente.

```bash
cd /caminho/para/seu-projeto
npx opencode-engineering-kit install
```

O que acontece:

```
seu-projeto/
├── .opencode/
│   ├── skills/        # assets/skills (todas as categorias)
│   ├── agents/        # assets/agents (nomes achatados: backend-developer.md)
│   ├── commands/      # assets/commands
│   ├── context/       # context/*.md (registrados em instructions)
│   ├── assets/        # prompts, playbooks, recipes, templates (referência)
│   ├── core/          # índices, registry, resolver, segurança, qualidade
│   ├── scripts/       # validação, geração e testes (usados pelo doctor)
│   └── docs/          # documentação e mapeamentos de proveniência
└── opencode.json      # skills.paths + instructions (mesclado com o que já existia)
```

Depois é só **reiniciar o OpenCode** para a nova configuração ser carregada.

#### Comandos da CLI

| Comando | Descrição |
|---------|-----------|
| `install` | Instala skills, agents, commands, context, assets, `core/`, `scripts/` e `docs/` (ou global com `--global`) |
| `status` | Mostra onde o kit está instalado e se está ativo |
| `start` | Reativa o kit (restaura o wiring gravado em `.kit-install.json`) |
| `stop` | Desativa o kit (mantém arquivos, remove wiring do `opencode.json`) |
| `list` | Lista assets do checkout ou do projeto instalado |
| `search` | Busca assets por palavra-chave em nome/descrição |
| `doctor` | Valida schema, links, política, UTF-8, contagens, índices, lockfile, security scan, vault e testes opcionais |
| `upgrade` | Reinstala com `--force`, reaproveitando `--profile`/`--only` do manifesto quando omitidos |
| `export` | Gera pacote: `export <claude\|cursor\|opencode\|claude-md> --target <dir> [--dry-run]` |

#### Opções do `install`

| Opção | Descrição |
|-------|-----------|
| `--target <dir>` | Diretório do projeto alvo (padrão: diretório atual) |
| `--global` | Instala no config global do OpenCode (`~/.config/opencode/`) |
| `--source <dir>` | Usa um checkout local do kit em vez de baixar do GitHub |
| `--repo <repo>` | Repositório GitHub do kit (padrão: `devtiagoabreu/opencode-engineering-kit`) |
| `--branch <b>` | Branch/tag do kit (padrão: `main`) |
| `--profile <nome>` | Perfil curado: `core`, `backend`, `frontend`, `devops`, `ai`, `brasil`, `full` |
| `--only <lista>` | Subconjunto: `skills,agents,commands,context,assets,core,scripts,docs` (padrão: todos) |
| `--force` | Sobrescreve arquivos existentes em `.opencode/` |
| `--dry-run` | Mostra o que seria feito sem tocar no disco |
| `--verbose` | Lista cada arquivo copiado |

#### Perfis curados

| Perfil | Uso recomendado | Seleção |
|--------|------------------|---------|
| `core` | Setup mínimo e confiável | Skills/agents/commands/context curados |
| `backend` | API/dados | Skills por categorias backend/data + agents/commands/context completos |
| `frontend` | UI/web | Skills por categorias frontend/design + agents/commands/context completos |
| `devops` | Plataforma/CI/cloud | Skills por categorias devops/cloud/security + agents/commands/context completos |
| `ai` | LLM/RAG/visão | Skills por categorias ai/analytics/vision/tools + agents/commands/context completos |
| `brasil` | Domínios BR | Skills de categorias de domínio BR + agents/commands/context completos |
| `full` | Catálogo completo | `*` em todos os grupos |

#### Exemplos de uso

```bash
# Instalar perfil curado (menos ruído de contexto)
npx opencode-engineering-kit install --profile core

# Instalar só skills e agents, forçando sobrescrita
npx opencode-engineering-kit install --only skills,agents --force

# Instalar globalmente (válido para todos os projetos)
npx opencode-engineering-kit install --global

# Modo offline / desenvolvimento: usar um checkout local do kit
npx opencode-engineering-kit install --source /caminho/para/opencode-engineering-kit

# Simular sem alterar nada
npx opencode-engineering-kit install --dry-run

# Ciclo de vida: consultar estado, desativar e reativar
npx opencode-engineering-kit status
npx opencode-engineering-kit stop
npx opencode-engineering-kit start

# Descoberta e diagnóstico
npx opencode-engineering-kit list --type skills
npx opencode-engineering-kit search "docker kubernetes"
npx opencode-engineering-kit doctor --fast
npx opencode-engineering-kit doctor --dir . --target . --fast
npx opencode-engineering-kit doctor --dir . --target . --fast --json  # contrato estável para CI
npx opencode-engineering-kit upgrade --dry-run
```

> `list`, `search` e `doctor` detectam automaticamente um projeto instalado: rodam a partir da raiz do projeto porque o instalador copia `core/`, `scripts/` e `docs/` para `.opencode/`.

---

### Método 2 — Script de instalação global (via curl)

Instala uma cópia do kit em `~/.opencode-engineering-kit`, útil para consultar skills e rodar os scripts do núcleo de qualquer lugar.

```bash
curl -fsSL https://raw.githubusercontent.com/devtiagoabreu/opencode-engineering-kit/main/install.sh | bash
```

Para usar os scripts no PATH:

```bash
export PATH="$PATH:$HOME/.opencode-engineering-kit/scripts"
```

**Atualizar** a instalação global:

```bash
~/.opencode-engineering-kit/scripts/update.sh
# ou, dentro do repo clonado:
./update.sh
```

**Remover** a instalação global:

```bash
./uninstall.sh
```

---

### Método 3 — Clonar o repositório

```bash
git clone https://github.com/devtiagoabreu/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

O `bootstrap.sh` cria a estrutura de diretórios e as categorias esperadas.

---

## Confiança e modelo de instalação

- **O que a CLI faz:** copia assets para `.opencode/` e mescla `opencode.json` (`skills.paths`, `instructions`). Não apaga sua configuração existente.
- **Auditoria antes de instalar:** use `--dry-run` e/ou `--source <checkout-local>` para inspecionar a origem. Rode `npx opencode-engineering-kit doctor --fast` no checkout do kit.
- **Drift após instalar:** rode `npx opencode-engineering-kit doctor --dir <kit> --target <projeto> --fast` para checar wiring e drift de arquivos rastreados (`.opencode/.kit-install.json`). Se houver `modified/missing`, reinstale com `--force` ou `upgrade`.
- **Diagnóstico no projeto instalado:** `list`, `search` e `doctor` detectam automaticamente `.opencode/`; não é preciso apontar para o checkout do kit.
- **Contrato JSON do doctor:** `doctor --json` expõe `checks[].code` estável, `checks[].skipped` (distingue "não executado" de "passou") e `recommendations[]` acionáveis; útil para CI e automações.
- **Desativar com segurança:** `stop` remove apenas o wiring do kit no `opencode.json`; `start` restaura exatamente o que o install registrou (respeitando perfis e `--only`).
- **Limites atuais:** a verificação de supply chain ainda está evoluindo (schema/scan/provenance/lock). Veja [docs/AUDIT_AND_PR_PLAN.md](./docs/AUDIT_AND_PR_PLAN.md) para o plano PR-02/PR-05 e [docs/QUALITY_POLICY.md](./docs/QUALITY_POLICY.md) para as regras aplicadas hoje (maturidade, proveniência e links).
- **Integrações referenciadas:** capacidades adaptadas de vinte repositórios externos nomeados estão mapeadas em [docs/REFERENCE_CAPABILITIES.md](./docs/REFERENCE_CAPABILITIES.md), [docs/PLATFORM_REFERENCE_CAPABILITIES.md](./docs/PLATFORM_REFERENCE_CAPABILITIES.md) e [docs/FISCAL_ENGINE_CAPABILITIES.md](./docs/FISCAL_ENGINE_CAPABILITIES.md), com licenças e escopo explicitados.
- **Aprendizado contínuo:** o comando `/aprenda` segue a fila canônica de 20 repositórios em [docs/APRENDA_REPOSITORIOS.md](./docs/APRENDA_REPOSITORIOS.md), incluindo os motores fiscais oficiais da Receita Federal, e regera ativos `beta` com proveniência.
- **Segurança:** reporte vulnerabilidades conforme [SECURITY.md](./SECURITY.md).

## Core vs opcional/experimental

| Área | Papel | Maturidade recomendada |
|------|-------|------------------------|
| `assets/skills`, `agents`, `commands`, `context` | Uso direto no projeto via CLI | Núcleo (caminho padrão) |
| `cli/` | Instalação e lifecycle | Núcleo |
| `core/quality`, `core/security`, `core/registry` | Validação, scan, metadados | Núcleo em endurecimento |
| `core/plugin`, `core/marketplace`, `core/resolver`, `core/version` | Infra de plataforma | Opcional/avançado |
| `marketplace-web/`, `plugins/` | Descoberta e extensões | Opcional/experimental |

---

## O que o kit contém (detalhado)

### Skills — 183 guias prontos

Skills são **guias completos** (instruções + exemplos + referências) para que a IA execute tarefas específicas. Cada skill tem frontmatter YAML validado (nome, descrição, categoria, versão, autor, compatibilidade) e limite de 600 linhas.

| Categoria | Exemplos |
|-----------|----------|
| `ai` | Deep Learning, RAG/LLM, Evolution API, LLM Multi-Provider, Free LLMs, Context Filesystem Memory, Memory Discipline, AI SDK Agent Patterns |
| `analytics` | Business Intelligence, Privacy-First Analytics |
| `automation` | n8n Workflow Automation, LLM Workflow Orchestration |
| `design` | Design System, UI/UX, Design Tokens (DTCG), UI Visual Craft, Design Review Critic, Diagram Design |
| `documentation` | Doc → Markdown (MarkItDown) |
| `robotics` | ROS 2, controle e simulação |
| `embedded` | Arduino, ESP32, ESP8266, Raspberry Pi, RTOS |
| `devops` | Docker, Kubernetes, CI/CD, Terraform, Monitoring, Incident Response, **On-Premise**, Self-Host Deployment, Vercel Runtime & Cache |
| `backend` | API Design, Auth, Caching, GraphQL, REST, Database, **FastAPI** |
| `frontend` | React, State Management, CSS, Acessibilidade, **A11y Audit (WCAG 2.2)**, Registry Distribution, Transactional Email Patterns |
| `testing` | Unit, Integration, E2E, Python Testing |
| `security` | OWASP Top 10, Secure Coding, SkillSpector (scan de skills), **RBAC**, Auth Plugin Architecture, **Next.js Web Security** |
| `git` | Git Workflow |
| `vision` | OpenCV, **ONNX Object Detection**, **RTSP/ONVIF Cameras** |
| `languages` | Python, **Python Modern Tooling (uv/ruff)**, TypeScript, **C#**, **C++**, **C**, **PHP**, **Delphi** |
| `iot` | MQTT, Sensores |
| `tools` | Git avançado, Terminal, Repo → LLM, Grafo de código (Graphify) |
| `quality` | Code Review, Refactoring, Otimização de contexto/tokens |
| `construction` | Execução de obras, estruturas civis |
| `finance` | Contabilidade, tributos (Simples Nacional), Usage-Based Billing, Bank Reconciliation, Financial Statements/DRE, Controllership Close, Fiscal Engine Integration |
| `marketing` | Marketing digital, gestão de tráfego, marketing político (lei eleitoral) |
| `science` | Matemática aplicada, física, química, Scientific Data Retrieval |
| `engineering` | Mecatrônica, automação industrial, automação residencial, planejamento de produção |
| `logistics` | Supply chain, **Route Optimization** |
| `web` | Web scraping, Google Workspace/Looker Studio, Browser Use Automation |
| `management` | Metodologia Lean, Psicologia para Governança de Pessoas |
| `health` | Protocolo de crise, escalas de rastreio, frameworks de psicoeducação, funções executivas TDAH, suporte à neurodiversidade, nutrição, podologia |
| `cloud` | Arquitetura AWS e Google Cloud |
| `education` | Planejamento de aulas, métodos de ensino, avaliação, evidências, vestibular (ENEM/FUVEST/VUNESP) |
| `music` | Teoria musical, método Suzuki |
| `arts` | Desenho, moda, maquiagem, roteiro |
| `sports` | Preparação física |
| `automotive` | Diagnóstico e reparo automotivo |
| `commercial` | E-commerce, CRM, plásticos, tecelagem |
| `humanities` | Geopolítica, análise política, direito trabalhista, direito penal |
| `architecture` | Clean Architecture, Microservices, Plugin System, Harness Engineering Patterns |
| `database` | PostgreSQL, RLS Tenancy, Database Branching Workflows |
| `projects` | Project Setup, SaaS Blueprint Patterns |
| + code-review, community | — |

**Foco em contexto para LLMs:** 4 skills novas cobrem o ecossistema de
contexto/gerenciamento de tokens em alta no GitHub — `doc-to-markdown`
([MarkItDown](https://github.com/microsoft/markitdown)), `repo-to-llm`
([gittomd](https://gittomd.com) / `llms.txt`), `code-knowledge-graph`
([Graphify](https://github.com/Graphify-Labs/graphify)) e `context-optimization`
([Repomix](https://github.com/yamadashy/repomix) + compactação/cache). A
`skill-spector` integra o scanner de segurança
[NVIDIA SkillSpector](https://github.com/NVIDIA/SkillSpector) ao fluxo de
instalação de plugins.

Todas as skills são copiadas automaticamente para `.opencode/skills/` na
instalação via CLI (`npx opencode-engineering-kit install`) — novas categorias
são detectadas recursivamente, sem configuração extra.

### Agents — 107 personas prontas

Agents são **personas** (papel + contexto + estilo de comunicação) para papéis específicos. Exemplos:

| Agent | Descrição |
|-------|-----------|
| `backend-developer` | APIs e backend |
| `frontend-developer` | UI/UX e frontend |
| `devops-engineer` | Infraestrutura e CI/CD |
| `site-reliability-engineer` | SRE |
| `security-engineer` | Segurança e hardening |
| `ai-engineer` | RAG, integração de LLMs |
| `data-scientist` | ML / deep learning e análise de dados |
| `automation-engineer` | Workflows n8n e bots WhatsApp |
| `bi-analyst` | Dashboards, KPIs e relatórios |
| `robotics-engineer` | ROS 2 e robótica |
| `orquestrador` | Planeja tarefas, delega aos agentes certos e mostra a procedência das ferramentas |
| + architect, planner, reviewer, qa, performance, documentation, database, embedded, vision | — |

#### Personas de domínio (construção, finanças, design, marketing, ciências, humanas, engenharia, logística, web, saúde, gestão, cloud, educação, música, artes, esporte, comércio, direito e idiomas)

Cada persona de domínio **colabora com as personas de tecnologia**, fornecendo
parâmetros técnicos da sua área sempre olhando o que o usuário está querendo
criar (seção "Como ajuda as personas de tecnologia" em cada arquivo). Conteúdo
em português, com cabeçalhos compatíveis com os testes do kit.

| Categoria | Personas |
|-----------|----------|
| `construction` | pedreiro, engenheiro-civil, arquiteto, desenhista-tecnico, pintor |
| `finance` | contador, fiscal, analista-financeiro, controladoria |
| `design` | designer-de-interiores, designer-de-tecidos, designer-digital, design-reviewer |
| `marketing` | marketing-digital, gestor-de-trafego, marketeiro-politico, criador-de-jingles-politicos |
| `science` | matematico, fisico, quimico |
| `humanities` | historiador, filosofo, analista-geopolitico, analista-politico, advogado-trabalhista, criminalista |
| `engineering` | engenheiro-mecatronico, engenheiro-de-producao, especialista-em-automacao-industrial, especialista-em-automacao-residencial |
| `logistics` | especialista-em-logistica |
| `web` | webscraper, especialista-google-workspace |
| `health` | psicologo, psiquiatra, especialista-em-autismo, especialista-em-tdah, nutricionista, podologo |
| `management` | metodologia-lean, psicologo-organizacional |
| `cloud` | arquiteto-aws-cloud, arquiteto-google-cloud |
| `education` | professor-de-historia, professor-de-geografia, professor-de-matematica, professor-de-fisica, professor-de-quimica, professor-de-filosofia, professor-de-etica, professor-de-sociologia, professor-de-robotica, professor-de-artes, professor-de-educacao-fisica, especialista-em-alfabetizacao, preparador-vestibular |
| `music` | musico, especialista-metodo-suzuki |
| `arts` | maquiador, estilista, cabeleireiro, bailarina, coreografo, roteirista |
| `sports` | personal-trainer |
| `automotive` | mecanico, mecanico-de-aviao |
| `commercial` | equipe-comercial-tecelagem, especialista-comercial-plasticos, equipe-comercial-ecommerce, relacoes-com-o-cliente |
| `languages` | professor-de-idiomas |
| `planner` | product-manager, orquestrador |
| `ai` | ai-engineer, data-scientist, especialista-em-llms |

> **Nota sobre saúde:** as personas de saúde têm foco **educacional e de
> apoio**, não substituem profissionais de saúde e não emitem diagnósticos nem
> prescrições.
>
> **Nota sobre direito:** as personas jurídicas têm caráter **educativo e
> informativo**, não substituem a orientação de um(a) advogado(a) inscrito(a) na
> OAB para casos concretos.
>
> **Nota sobre política:** as personas políticas apresentam análise factual e
> plural, respeitam a legislação eleitoral (TSE) e rejeitam desinformação e
> discurso de ódio.

### Prompts — 10 reutilizáveis

Prompts focados para interações únicas: code review, debugging, refatoração, planejamento, arquitetura (system design), documentação de API, estratégia de testes, auditoria de segurança, RAG e performance review. Usam placeholders `{{variavel}}`.

### Templates — 11 para projetos e componentes

`new-project`, `agent`, `skill`, `prompt`, `agent-session-handoff`, `harness-checklist`, `scientific-retrieval-ledger`, `monthly-close-checklist`, `saas-launch-checklist`, `billing-meter-spec` e `fiscal-calculation-record`.

### Playbooks e Recipes

- **Playbooks** (fluxos de múltiplas etapas): `code-review-process`, `new-project-setup`, `whatsapp-bot-setup`
- **Recipes** (soluções completas): `python-project-setup`, `react-project-setup`

### Comandos

- `/lint`, `/review`, `/test` — documentação de comandos nativos do OpenCode
- `/ocekit` — instalar e gerenciar o kit (install, status, start, stop) direto no chat
- `/aprenda` — executar a fila canônica de aprendizado de repositórios de referência
- `/harness-review` — revisar um fluxo de engenharia de harness contra os padrões adaptados
- `/diagram` — gerar diagramas a partir do skill `diagram-design`

### Bundles, Composições e Prompt chains

- **Bundles**: `backend-starter`, `devops-starter` (pacotes prontos de assets)
- **Composições**: `full-stack-team`, `platform-team`
- **Prompt chains**: `feature-delivery`, `incident-response`

### Contexto (`context/`)

17 arquivos de contexto otimizados para IA: `project`, `stack`, `architecture`, `conventions`, `decisions`, `documentation`, `git`, `glossary`, `naming`, `performance`, `security`, `style_guide`, `coding_rules`, **`personas`** (índice de todas as personas), **`HISTORY`** (histórico de mudanças do kit) e **`AUTO_USAGE`** (uso automático de skills/personas — o OpenCode verifica e usa os assets relevantes sozinho, informando você com um aviso curto). O script `scripts/persona-scaffold.sh` cria uma persona nova com contexto e registra automaticamente no histórico.

### Plugins

O kit tem um **sistema de plugins** com hooks (veja [docs/PLUGIN_GUIDE.md](./docs/PLUGIN_GUIDE.md)):

```bash
# Instalar um plugin
./core/plugin/installer.sh asset-linter

# Validar e carregar plugins
./core/plugin/loader.sh

# Listar hooks registrados
./core/plugin/hooks.sh --list

# Criar um plugin novo
source core/plugin/sdk.sh
sdk_init_plugin my-validator plugins/community/my-validator
```

### Núcleo (`core/`)

| Módulo | O que faz |
|--------|-----------|
| `registry` | Registro e geração de metadados/index dos assets (com JSON Schema) |
| `discovery` | Busca, filtros, recomendação e relacionados |
| `resolver` | Resolução de dependências entre assets + lockfile |
| `version` | Versionamento semver + matriz de compatibilidade |
| `plugin` | Sistema de plugins com hooks (instalar/carregar/remover) |
| `marketplace` | Publicação, busca e avaliação de assets |
| `security` | Scan de segredos, auditoria de dependências, controle de acesso |
| `quality` | Validação, relatório e dashboard de qualidade |

### Marketplace web

O kit inclui uma interface web estática (`marketplace-web/`) para descobrir e buscar skills, agents, prompts e templates.

---

## Estrutura de diretórios

```
opencode-engineering-kit/
├── assets/              # Todos os recursos reutilizáveis
│   ├── skills/          # 183 skills em 42 categorias (SKILL.md)
│   ├── agents/          # 107 personas por categoria
│   ├── prompts/         # 10 prompts reutilizáveis
│   ├── templates/       # 11 templates
│   ├── commands/        # 7 comandos documentados
│   ├── playbooks/       # 3 fluxos de múltiplas etapas
│   ├── recipes/         # 2 soluções completas
│   ├── bundles/         # 2 pacotes prontos
│   ├── compositions/    # 2 equipes de agentes
│   └── prompt-chains/   # 2 cadeias de prompts
├── context/             # 17 arquivos de contexto para IA (inclui personas + HISTORY + AUTO_USAGE)
├── core/                # Infraestrutura do kit
│   ├── registry/        # Registro + schema + índices
│   ├── discovery/       # Busca e descoberta
│   ├── resolver/        # Dependências + lockfile
│   ├── version/         # Semver + compatibilidade
│   ├── plugin/          # Plugins e hooks
│   ├── marketplace/     # Marketplace CLI
│   ├── security/        # Scans de segurança
│   └── quality/         # Gates de qualidade + dashboard
├── cli/                 # CLI npm (npx opencode-engineering-kit)
├── plugins/             # Plugins de exemplo (community, enterprise)
├── marketplace-web/     # Interface web do marketplace
├── scripts/             # bootstrap, test, deploy, monitor, persona-scaffold, dashboards
├── tests/               # 26 suítes de teste automatizadas
├── docs/                # Documentação (EN + PT)
├── examples/            # Exemplos de uso
├── install.sh           # Instalação global
├── uninstall.sh         # Remoção
└── update.sh            # Atualização
```

---

## Uso rápido

```bash
# Ver uma skill
cat assets/skills/devops/docker-best-practices/SKILL.md

# Copiar uma skill para o seu projeto
cp -r assets/skills/devops/docker-best-practices/ /seu/projeto/

# Ver a persona de um agent
cat assets/agents/devops/devops-engineer/devops-engineer.md

# Criar uma persona de domínio nova com contexto e histórico
./scripts/persona-scaffold.sh construction mestre-de-obras "Gestão de obras"

# Criar um projeto a partir de um template
cp -r assets/templates/new-project/ /seu/novo-projeto/

# Buscar assets por termo
./core/discovery/search.sh "docker"

# Validar todos os assets
./core/quality/validate.sh
```

---

## Qualidade e testes

O projeto usa **quality gates** automatizados (lint de Markdown/YAML/Shell, validação de formato e conteúdo) com CI via GitHub Actions.

```bash
# Rodar todas as 26 suítes de teste (shell)
./scripts/test.sh

# Rodar os testes da CLI (26 casos node:test)
cd cli && npm test

# Rodar os gates de qualidade
./core/quality/validate.sh

# Ver o relatório de qualidade
cat core/quality/quality-report.json
```

---

## Contribuindo

Contribuições são bem-vindas! Veja [CONTRIBUTING.md](./CONTRIBUTING.md) e o [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md).

Tipos de contribuição: nova skill, novo agent, novo template, melhoria, correção de bug.

## Roadmap

Veja [ROADMAP.md](./ROADMAP.md) e [docs/ROADMAP_V3.md](./docs/ROADMAP_V3.md). A evolução de arquitetura v3.0 está em [docs/ARCHITECTURE_EVOLUTION.md](./docs/ARCHITECTURE_EVOLUTION.md).

## Segurança

Veja [SECURITY.md](./SECURITY.md) para políticas e como reportar vulnerabilidades.

## Documentação

**Inglês:** [User Guide](./docs/USER_GUIDE.md) · [Quick Reference](./docs/QUICK_REFERENCE.md) · [API Reference](./docs/API_REFERENCE.md) · [Plugin Guide](./docs/PLUGIN_GUIDE.md)

**Português:** [Guia do Usuário](./docs/GUIA_USUARIO.md) · [Cartão de Referência](./docs/CARTAO_REFERENCIA.md)

**Planejamento:** [Audit & PR Plan](./docs/AUDIT_AND_PR_PLAN.md) · [Roadmap](./ROADMAP.md) · [Architecture Evolution](./docs/ARCHITECTURE_EVOLUTION.md) · [Handoff de sessão](./docs/SESSION_HANDOFF.md) · [Playbook de publicação npm](./docs/NPM_PUBLISH_PLAYBOOK.md) · [Repositórios Google Workspace](./docs/GOOGLE_WORKSPACE_REPOS.md)

## Licença

MIT — veja o [LICENSE](./LICENSE).

## Contato

- **Issues:** [GitHub Issues](https://github.com/devtiagoabreu/opencode-engineering-kit/issues)
- **Discussões:** [GitHub Discussions](https://github.com/devtiagoabreu/opencode-engineering-kit/discussions)

## Agradecimentos

- [OpenCode](https://opencode.ai) pela plataforma
- [Shokunin](https://github.com/EliasOulkadi/shokunin) pela inspiração
- [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill) pela inspiração
- Todas as pessoas que contribuem com o projeto
