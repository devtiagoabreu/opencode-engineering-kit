# Guia do Usuário — OpenCode Engineering Kit

> Guia completo para usar o OpenCode Engineering Kit

---

## Índice

1. [Introdução](#introdução)
2. [Instalação](#instalação)
3. [Início Rápido](#início-rápido)
4. [Skills](#skills)
5. [Agents](#agents)
6. [Prompts](#prompts)
7. [Templates](#templates)
8. [Commands](#commands)
9. [Playbooks e Recipes](#playbooks-e-recipes)
10. [Sistema de Descoberta](#sistema-de-descoberta)
11. [CLI](#cli)
12. [SkillPointer e Vault](#skillpointer-e-vault)
13. [Memória de Sessão](#memória-de-sessão)
14. [Marketplace](#marketplace)
15. [Segurança](#segurança)
16. [Solução de Problemas](#solução-de-problemas)

---

## Introdução

O **OpenCode Engineering Kit** é uma biblioteca open source de recursos reutilizáveis para acelerar a produtividade com assistentes de codificação baseados em IA. Ele funciona com:

- **OpenCode** (principal)
- **Claude Code**
- **Cursor**
- **GitHub Copilot** (parcial)

### O que está incluído

- **123 Skills** — guias completos em 42 categorias
- **93 Agents** — personas de IA especializadas em 38 categorias
- **10 Prompts** — modelos de prompts reutilizáveis
- **16 Templates** — modelos para projetos e componentes
- **3 Commands** — ações documentadas para tarefas comuns
- **3 Playbooks** — fluxos de múltiplas etapas
- **2 Recipes** — configurações completas de projeto
- **2 Bundles**, **2 Composições**, **2 Prompt chains**
- **15 arquivos de contexto** + memória persistente opcional (SQLite)
- **SkillPointer/Vault** — carregamento sob demanda de conteúdo curado

---

## Instalação

### Método 1 — CLI (recomendado)

Instala o kit em **qualquer projeto existente**, copiando os assets para `.opencode/`:

```bash
cd /caminho/para/seu-projeto
npx opencode-engineering-kit install
```

Depois de instalar, **reinicie o OpenCode** para carregar a configuração.

### Método 2 — Instalação global via curl

```bash
curl -fsSL https://raw.githubusercontent.com/devtiagoabreu/opencode-engineering-kit/main/install.sh | bash
```

Para usar os scripts no PATH:

```bash
export PATH="$PATH:$HOME/.opencode-engineering-kit/scripts"
```

Atualizar: `~/.opencode-engineering-kit/scripts/update.sh` (ou `./update.sh` dentro do repositório). Remover: `./uninstall.sh`.

### Método 3 — Clonar o repositório

```bash
git clone https://github.com/devtiagoabreu/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

### Pré-requisitos

- **Git 2.0+**
- **Bash 4.0+**
- **Node.js 18+** (para a CLI via `npx`)
- **OpenCode** (recomendado)

---

## Início Rápido

### Usando uma Skill

1. Navegue até a skill:

    ```bash
    cd assets/skills/devops/docker-best-practices
    ```

2. Leia o arquivo `SKILL.md` e siga as instruções:

    ```bash
    cat SKILL.md
    ```

### Usando um Agent

1. Navegue até o agent:

    ```bash
    cd assets/agents/backend/backend-developer
    ```

2. Leia o arquivo da persona:

    ```bash
    cat backend-developer.md
    ```

3. Use a persona do agent nas suas conversas.

### Copiando uma skill para o seu projeto

```bash
cp -r assets/skills/devops/docker-best-practices/ /seu/projeto/
```

---

## Skills

Skills são **guias completos** (instruções + exemplos + referências) para que a IA execute tarefas específicas. Cada skill tem frontmatter YAML validado (nome, descrição, categoria, versão, autor, compatibilidade) e limite de 500 linhas.

### Categorias

| Categoria | Exemplos |
|-----------|----------|
| `devops` | Docker, Kubernetes, CI/CD, Terraform, Monitoring, Incident Response |
| `backend` | API Design, Auth, Caching, GraphQL, REST, Database |
| `frontend` | React, State Management, CSS, Acessibilidade |
| `testing` | Unit, Integration, E2E, Python Testing |
| `security` | OWASP Top 10, Secure Coding, SkillSpector |
| `methodology` | Brainstorming, Writing/Executing Plans, TDD, Git Worktrees, Code Review |
| `ai` | Deep Learning, RAG/LLM, LLM Multi-Provider |
| `tools` | Git avançado, Terminal, Repo → LLM, Graphify, Session Memory |
| + 34 outras | construction, finance, marketing, education, health, cloud, music, arts... |

### Como Usar uma Skill

1. **Encontre a skill** que você precisa:

    ```bash
    ./core/discovery/search.sh "docker"
    ```

2. **Leia a documentação** da skill:

    ```bash
    cat assets/skills/devops/docker-best-practices/SKILL.md
    ```

3. **Siga as instruções** e **aplique as melhores práticas** ao seu projeto.

---

## Agents

Agents são **personas** (papel + contexto + estilo de comunicação) para papéis específicos. Cada persona de domínio colabora com as personas de tecnologia (seção "Como ajuda as personas de tecnologia" em cada arquivo).

### Agents Disponíveis

| Agent | Descrição |
|-------|-----------|
| **devops-engineer** | Especialista em infraestrutura e CI/CD |
| **backend-developer** | Especialista em APIs e backend |
| **frontend-developer** | Especialista em UI/UX e frontend |
| **fullstack-developer** | Especialista full-stack |
| **security-engineer** | Especialista em segurança |
| **qa-engineer** | Especialista em garantia de qualidade |
| **data-scientist** | ML / deep learning e análise de dados |
| **ai-engineer** | RAG e integração de LLMs |
| **technical-writer** | Especialista em documentação |
| **product-manager** | Especialista em gestão de produtos |
| **orquestrador** | Planeja tarefas, delega aos agentes certos e mostra a procedência das ferramentas |
| + 80 outras | construction, finance, marketing, science, health, education, music... |

### Como Usar um Agent

1. **Encontre o agent** que você precisa:

    ```bash
    ./core/discovery/search.sh "backend"
    ```

2. **Leia a documentação** do agent:

    ```bash
    cat assets/agents/backend/backend-developer/backend-developer.md
    ```

3. **Use a persona** nas suas conversas com assistentes de IA.

---

## Prompts

Prompts são modelos reutilizáveis para tarefas comuns (com placeholders `{{variavel}}`): code review, debugging, refatoração, planejamento, arquitetura (system design), documentação de API, estratégia de testes, auditoria de segurança, RAG e performance review.

### Como Usar um Prompt

```bash
# Encontre o prompt
./core/discovery/search.sh "code review"

# Leia o prompt
cat assets/prompts/code-review/code-review-checklist.md
```

Copie o prompt para a área de transferência e cole no seu assistente de IA.

---

## Templates

Templates são pontos de partida para novos projetos e componentes: `new-project`, `react`, `nextjs`, `api`, `docker`, `docker-compose`, `github-actions`, `postgresql`, `mqtt`, `esp32`, `opencv`, `adr`, `agent`, `skill`, `prompt` e `readme`.

### Como Usar um Template

```bash
# Liste os templates
ls assets/templates/

# Copie um template para seu projeto
cp -r assets/templates/new-project /seu/projeto/
```

Customize os arquivos conforme necessário.

---

## Commands

Commands são ações documentadas para tarefas comuns do OpenCode: `/lint`, `/review`, `/test`. Ficam em `assets/commands/`.

```bash
ls assets/commands/
cat assets/commands/review.md
```

---

## Playbooks e Recipes

- **Playbooks** (fluxos de múltiplas etapas): `code-review-process`, `new-project-setup`, `whatsapp-bot-setup` — em `assets/playbooks/`
- **Recipes** (soluções completas): `python-project-setup`, `react-project-setup` — em `assets/recipes/`

```bash
ls assets/playbooks/
cat assets/playbooks/new-project-setup.md
```

---

## Sistema de Descoberta

O sistema de descoberta ajuda a encontrar assets por palavra-chave, categoria, compatibilidade ou afinidade.

### Buscar Assets

```bash
# Buscar por palavra-chave
./core/discovery/search.sh "docker"

# Buscar por categoria
./core/discovery/filter.sh --category=devops

# Buscar por compatibilidade
./core/discovery/filter.sh --compatible=opencode

# Encontrar assets relacionados
./core/discovery/related.sh docker-best-practices

# Recomendações
./core/discovery/recommend.sh
```

### Gerar Índice

```bash
./core/discovery/index.sh
```

### Visualizar Índice

```bash
cat core/discovery/index/skills.txt
cat core/discovery/index/agents.txt
```

---

## CLI

A CLI (`npx opencode-engineering-kit`) oferece comandos para instalar e gerenciar o kit:

| Comando | Descrição |
|---------|-----------|
| `install` | Instala skills, agents, commands e contexto em `.opencode/` |
| `list` | Lista assets (skills, agents, prompts, templates) |
| `search <termo>` | Busca assets por palavra-chave |
| `doctor` | Verifica a integridade do kit (schema, índices, scan de segurança, dependências) |
| `upgrade` | Reinstala com `--force` da última versão remota |
| `export <harness>` | Gera pacotes para outros harnesses (`.claude`, `.cursor`, `CLAUDE.md`, `.opencode`) |

### Exemplos

```bash
# Instalar no projeto atual
npx opencode-engineering-kit install

# Instalar só skills e agents, forçando sobrescrita
npx opencode-engineering-kit install --only skills,agents --force

# Usar um checkout local (modo offline)
npx opencode-engineering-kit install --source /caminho/para/opencode-engineering-kit

# Listar skills em JSON
npx opencode-engineering-kit list --type skills --json

# Exportar para Claude Code
npx opencode-engineering-kit export claude
```

---

## SkillPointer e Vault

Skills "ponteiro" são entradas mínimas de catálogo: o `SKILL.md` fica pequeno e o conteúdo completo vive em `assets/vault/<categoria>/<skill>/`. Isso **evita injeção de contexto**: o conteúdo é carregado sob demanda, apenas quando a tarefa precisa.

### Comandos do pointer

```bash
# Resolver o conteúdo completo de uma skill (SKILL.md ou entrada do vault)
./core/discovery/pointer.sh resolve repo-to-llm

# Informações do vault (meta + estimativa de tokens)
./core/discovery/pointer.sh vault repo-to-llm

# Estimativa de tokens de um arquivo
./core/discovery/pointer.sh tokens assets/vault/tools/repo-to-llm/content.md

# Listar entradas do vault (ou só as skills ponteiro com --pointer)
./core/discovery/pointer.sh list
./core/discovery/pointer.sh list --pointer

# Verificar se uma skill é ponteiro
./core/discovery/pointer.sh is-pointer repo-to-llm
```

### Entradas curadas atuais

| Skill | Vault | Tokens (aprox.) |
|-------|-------|-----------------|
| `repo-to-llm` | `tools/repo-to-llm` | 828 |
| `code-knowledge-graph` | `tools/code-knowledge-graph` | 767 |
| `skill-spector` | `security/skill-spector` | 779 |

O `cli doctor` verifica a consistência entre skills ponteiro e entradas do vault (links quebrados, entradas ausentes).

---

## Memória de Sessão

O kit tem memória persistente local-first, opcional (ativada com `KIT_MEMORY=1`). As notas ficam em SQLite (fora do repositório) e podem ser buscadas depois.

```bash
export KIT_MEMORY=1
python3 context/memory/memory.py init
```

Para recall vetorial (opcional):

```bash
pip install chromadb
export KIT_MEMORY_VECTOR=1
```

A skill `assets/skills/tools/session-memory/SKILL.md` documenta o fluxo completo (salvar, buscar, healthcheck).

---

## Marketplace

O marketplace permite publicar, buscar e avaliar assets.

### Navegar Assets

1. Abra a interface web do marketplace:

    ```bash
    open marketplace-web/index.html
    ```

2. Use a busca e os filtros para encontrar assets.

### Instalar Assets via CLI

```bash
# Instalar uma skill
./core/marketplace/install.sh skill docker-best-practices

# Instalar um agent
./core/marketplace/install.sh agent backend-developer
```

### Publicar e Avaliar

```bash
# Buscar assets
./core/marketplace/search.sh "docker"

# Avaliar um asset
./core/marketplace/rate.sh add --asset <nome> --reviewer <usuario> --rating <1-5>

# Publicar um asset
./core/marketplace/publish.sh --type skill --path ./assets/skills/minha-skill
```

---

## Segurança

O kit inclui ferramentas de segurança para auditar seu projeto e o conteúdo dos assets.

### Auditorias de Segurança

```bash
# Scan de conteúdo de skills (gate PASS/WARN/FAIL com allowlist)
./core/security/skill-scan.sh

# Auditoria de dependências
./core/security/dependency-audit.sh

# Busca de secrets
./core/security/secret-scan.sh

# Busca de vulnerabilidades
./core/security/vulnerability-scan.sh

# Verificação de controle de acesso
./core/security/access-control.sh

# Logging de auditoria
./core/security/audit-log.sh
```

### Melhores Práticas de Segurança

1. **Nunca commite secrets** — use variáveis de ambiente
2. **Execute auditorias de segurança** regularmente
3. **Mantenha dependências atualizadas**
4. **Siga práticas de codificação segura**
5. Antes de instalar uma skill de terceiros, rode o SkillSpector (skill `skill-spector`)

---

## Solução de Problemas

### Problemas Comuns

#### Problema: Scripts não executáveis

```bash
chmod +x scripts/*.sh
chmod +x core/**/*.sh
chmod +x tests/**/*.sh
```

#### Problema: Sistema de descoberta não encontrando assets

```bash
# Regenerar o índice
./core/discovery/index.sh
```

#### Problema: Testes falhando

```bash
# Executar todos os testes
./scripts/test.sh

# Executar um teste específico
./tests/skills/test-skill-content.sh
```

#### Problema: Erros de validação

```bash
# Executar validação de todos os assets
./core/validator/validate-all.sh

# Validar um diretório (espera skills/ e agents/ dentro)
./core/validator/validate.sh assets
```

#### Problema: Integridade do kit

```bash
# Verificar schema, índices, scan de segurança, dependências e vault
npx opencode-engineering-kit doctor
```

### Obter Ajuda

- **GitHub Issues**: <https://github.com/devtiagoabreu/opencode-engineering-kit/issues>
- **Documentação**: Veja o diretório `docs/`
- **Exemplos**: Veja o diretório `examples/`

---

## Contribuindo

Nós damos as boas-vindas a contribuições! Veja [CONTRIBUTING.md](./CONTRIBUTING.md) para detalhes.

### Guia Rápido de Contribuição

1. Faça um fork do repositório
2. Crie uma branch de feature
3. Faça suas alterações
4. Execute os testes (`./scripts/test.sh`)
5. Submeta um pull request

---

## Licença

Este projeto está licenciado sob a Licença MIT — veja o arquivo [LICENSE](./LICENSE) para detalhes.

---

## Agradecimentos

- [OpenCode](https://opencode.ai) pela plataforma
- [Shokunin](https://github.com/EliasOulkadi/shokunin) pela inspiração
- [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill) pela inspiração
- Todas as pessoas que contribuem com o projeto
