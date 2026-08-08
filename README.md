# OpenCode Engineering Kit

> Kit de engenharia para acelerar o trabalho com OpenCode: Skills, Agents, Prompts, Templates, Playbooks, Comandos e Contexto prontos para uso — instaláveis em qualquer repositório em segundos.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/devtiagoabreu/opencode-engineering-kit)
[![OpenCode](https://img.shields.io/badge/OpenCode-compatible-brightgreen.svg)](https://opencode.ai)
[![CI](https://github.com/devtiagoabreu/opencode-engineering-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/devtiagoabreu/opencode-engineering-kit/actions/workflows/ci.yml)

## Sobre o projeto

O **OpenCode Engineering Kit** é uma biblioteca open source de recursos reutilizáveis para desenvolvedores que usam o [OpenCode](https://opencode.ai) (e ferramentas compatíveis). Ele resolve um problema comum: em vez de recriar do zero configs, prompts e fluxos de trabalho a cada projeto, você instala o kit e ganha de imediato um conjunto padronizado e testado de **skills, agents, prompts, templates, playbooks, comandos e contexto**.

Inspirado em projetos como [Shokunin](https://github.com/hirefrank/shokunin) e [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill), o kit é **simples (markdown puro), modular, portátil e agnóstico de modelo**.

### Estado atual

| Item | Quantidade |
|------|-----------|
| Skills | 60 (em 23 categorias) |
| Agents | 23 (personas em 17 categorias) |
| Prompts | 10 (em 13 categorias) |
| Templates | 16 |
| Playbooks | 3 |
| Recipes | 2 |
| Comandos | 3 |
| Bundles | 2 |
| Composições | 2 |
| Prompt chains | 2 |
| Plugins de exemplo | 1 (`asset-linter`) |
| Scripts de núcleo (core) | 35 |
| Testes automatizados | 20 |

### Compatibilidade

| Plataforma | Status |
|------------|--------|
| OpenCode | ✅ Primária (formato nativo) |
| Claude Code | ✅ Compatível (via `CLAUDE.md`) |
| Cursor | ✅ Compatível (via `.cursor/rules/`) |
| GitHub Copilot | ⚠️ Parcial (via instruções) |

---

## Instalação

### Pré-requisitos

- **Git 2.0+** — para clonar e instalar via script
- **Bash 4.0+** — para os scripts de instalação (Linux/macOS/WSL)
- **Node.js 18+** — para instalar via CLI (`npx`)
- **`tar`** disponível no PATH (usado pela CLI; Linux/macOS já trazem)

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
│   └── assets/        # prompts, playbooks, recipes, templates (referência)
└── opencode.json      # skills.paths + instructions (mesclado com o que já existia)
```

Depois é só **reiniciar o OpenCode** para a nova configuração ser carregada.

#### Opções da CLI

| Opção | Descrição |
|-------|-----------|
| `--target <dir>` | Diretório do projeto alvo (padrão: diretório atual) |
| `--source <dir>` | Usa um checkout local do kit em vez de baixar do GitHub |
| `--repo <repo>` | Repositório GitHub do kit (padrão: `devtiagoabreu/opencode-engineering-kit`) |
| `--branch <b>` | Branch/tag do kit (padrão: `main`) |
| `--only <lista>` | Subconjunto: `skills,agents,commands,context,assets` (padrão: todos) |
| `--force` | Sobrescreve arquivos existentes em `.opencode/` |
| `--dry-run` | Mostra o que seria feito sem tocar no disco |
| `--verbose` | Lista cada arquivo copiado |
| `--version` | Mostra a versão |
| `--help` | Ajuda |

#### Exemplos de uso

```bash
# Instalar só skills e agents, forçando sobrescrita
npx opencode-engineering-kit install --only skills,agents --force

# Modo offline / desenvolvimento: usar um checkout local do kit
npx opencode-engineering-kit install --source /caminho/para/opencode-engineering-kit

# Simular sem alterar nada
npx opencode-engineering-kit install --dry-run
```

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

## O que o kit contém (detalhado)

### Skills — 55 guias prontos

Skills são **guias completos** (instruções + exemplos + referências) para que a IA execute tarefas específicas. Cada skill tem frontmatter YAML validado (nome, descrição, categoria, versão, autor, compatibilidade) e limite de 500 linhas.

| Categoria | Exemplos |
|-----------|----------|
| `ai` | Deep Learning, RAG/LLM, Evolution API, LLM Multi-Provider |
| `analytics` | Business Intelligence |
| `automation` | n8n Workflow Automation |
| `design` | Design System, UI/UX |
| `documentation` | Doc → Markdown (MarkItDown) |
| `robotics` | ROS 2, controle e simulação |
| `embedded` | Arduino, ESP32, ESP8266, Raspberry Pi, RTOS |
| `devops` | Docker, Kubernetes, CI/CD, Terraform, Monitoring, Incident Response |
| `backend` | API Design, Auth, Caching, GraphQL, REST, Database |
| `frontend` | React, State Management, CSS, Acessibilidade |
| `testing` | Unit, Integration, E2E, Python Testing |
| `security` | OWASP Top 10, Secure Coding, SkillSpector (scan de skills) |
| `git` | Git Workflow |
| `vision` | OpenCV |
| `languages` | Python, TypeScript |
| `iot` | MQTT, Sensores |
| `tools` | Git avançado, Terminal, Repo → LLM, Grafo de código (Graphify) |
| `quality` | Code Review, Refactoring, Otimização de contexto/tokens |
| + architecture, code-review, community, database, projects | — |

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

### Agents — 23 personas prontas

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
| + architect, planner, reviewer, qa, performance, documentation, database, embedded, vision | — |

### Prompts — 10 reutilizáveis

Prompts focados para interações únicas: code review, debugging, refatoração, planejamento, arquitetura (system design), documentação de API, estratégia de testes, auditoria de segurança, RAG e performance review. Usam placeholders `{{variavel}}`.

### Templates — 16 para projetos e componentes

`new-project`, `react`, `nextjs`, `api`, `docker`, `docker-compose`, `github-actions`, `postgresql`, `mqtt`, `esp32`, `opencv`, `adr`, `agent`, `skill`, `prompt` e `readme`.

### Playbooks e Recipes

- **Playbooks** (fluxos de múltiplas etapas): `code-review-process`, `new-project-setup`, `whatsapp-bot-setup`
- **Recipes** (soluções completas): `python-project-setup`, `react-project-setup`

### Comandos

- `/lint`, `/review`, `/test` — documentação de comandos nativos do OpenCode

### Bundles, Composições e Prompt chains

- **Bundles**: `backend-starter`, `devops-starter` (pacotes prontos de assets)
- **Composições**: `full-stack-team`, `platform-team`
- **Prompt chains**: `feature-delivery`, `incident-response`

### Contexto (`context/`)

13 arquivos de contexto otimizados para IA: `project`, `stack`, `architecture`, `conventions`, `decisions`, `documentation`, `git`, `glossary`, `naming`, `performance`, `security`, `style_guide`, `coding_rules`.

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
│   ├── skills/          # 60 skills em 23 categorias (SKILL.md)
│   ├── agents/          # 23 personas por categoria
│   ├── prompts/         # 10 prompts reutilizáveis
│   ├── templates/       # 16 templates
│   ├── commands/        # 3 comandos documentados
│   ├── playbooks/       # 3 fluxos de múltiplas etapas
│   ├── recipes/         # 2 soluções completas
│   ├── bundles/         # 2 pacotes prontos
│   ├── compositions/    # 2 equipes de agentes
│   └── prompt-chains/   # 2 cadeias de prompts
├── context/             # 13 arquivos de contexto para IA
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
├── scripts/             # bootstrap, test, deploy, monitor, dashboards
├── tests/               # 20 suítes de teste automatizadas
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
cat assets/agents/devops/devops-engineer.md

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
# Rodar todas as 20 suítes de teste
./scripts/test.sh

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

## Licença

MIT — veja o [LICENSE](./LICENSE).

## Contato

- **Issues:** [GitHub Issues](https://github.com/devtiagoabreu/opencode-engineering-kit/issues)
- **Discussões:** [GitHub Discussions](https://github.com/devtiagoabreu/opencode-engineering-kit/discussions)

## Agradecimentos

- [OpenCode](https://opencode.ai) pela plataforma
- [Shokunin](https://github.com/hirefrank/shokunin) pela inspiração
- [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill) pela inspiração
- Todas as pessoas que contribuem com o projeto
