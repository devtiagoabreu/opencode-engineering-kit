# Guia do Usuário - OpenCode Engineering Kit

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
9. [Playbooks](#playbooks)
10. [Recipes](#recipes)
11. [Sistema de Descoberta](#sistema-de-descoberta)
12. [Marketplace](#marketplace)
13. [Segurança](#segurança)
14. [Solução de Problemas](#solução-de-problemas)

---

## Introdução

O **OpenCode Engineering Kit** é uma biblioteca open source fornecendo recursos reutilizáveis para acelerar a produtividade com assistentes de codificação baseados em IA. Ele funciona com:

- **OpenCode** (principal)
- **Claude Code**
- **Cursor**
- **GitHub Copilot** (parcial)

### O que está incluído

- **25 Skills** - Melhores práticas e guias para várias tecnologias
- **13 Agents** - Pessoas de IA especializadas para diferentes funções
- **3 Prompts** - Modelos de prompts reutilizáveis
- **4 Templates** - Modelos para projetos e assets
- **2 Playbooks** - Passo a passo para tarefas comuns
- **2 Recipes** - Configurações completas de projetos

---

## Instalação

### Opção 1: Clonar Repositório

```bash
git clone https://github.com/opencode-ai/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

### Opção 2: Baixar Arquivo Compactado

1. Baixe a última versão do GitHub
2. Extraia o arquivo compactado
3. Execute o script de bootstrap:

```bash
./scripts/bootstrap.sh
```

### Pré-requisitos

- Git 2.0+
- Bash 4.0+
- OpenCode (recomendado)

---

## Início Rápido

### Usando uma Skill

1. Navegue até o diretório de skills:

```bash
cd skills/devops/docker-best-practices
```

2. Leia o arquivo SKILL.md:

```bash
cat SKILL.md
```

3. Siga as instruções na skill

### Usando um Agent

1. Navegue até o diretório de agents:

```bash
cd agents
```

2. Leia o arquivo do agent:

```bash
cat devops-engineer.md
```

3. Use a persona do agent nas suas conversas

### Usando um Template

1. Navegue até o diretório de templates:

```bash
cd templates/new-project
```

2. Copie o template para seu projeto:

```bash
cp -r * /seu/projeto/
```

3. Customize os arquivos conforme necessário

---

## Skills

Skills são melhores práticas e guias para tecnologias ou tarefas específicas.

### Skills Disponíveis

#### DevOps
- **docker-best-practices** - Melhores práticas para Docker e containers
- **kubernetes-best-practices** - Orquestração com Kubernetes
- **ci-cd-pipeline** - Design de pipelines CI/CD
- **terraform-aws** - Terraform com AWS
- **monitoring-observability** - Monitoramento e observabilidade
- **incident-response** - Gestão de incidentes

#### Backend
- **rest-api-design** - Design de APIs REST
- **graphql-api** - Design de APIs GraphQL
- **database-design** - Design de banco de dados
- **caching-strategies** - Estratégias de cache
- **authentication** - Melhores práticas de autenticação

#### Frontend
- **react-patterns** - Padrões e arquitetura React
- **css-best-practices** - Arquitetura CSS
- **performance** - Performance frontend
- **accessibility** - Acessibilidade web
- **state-management** - Gerenciamento de estado

#### Testing
- **unit-testing** - Testes unitários
- **integration-testing** - Testes de integração
- **e2e-testing** - Testes end-to-end

#### Security
- **owasp-top-10** - OWASP Top 10
- **secure-coding** - Práticas de codificação segura

### Como Usar uma Skill

1. **Encontre a skill** que você precisa:

```bash
./core/discovery/search.sh "docker"
```

2. **Leia a documentação** da skill:

```bash
cat skills/devops/docker-best-practices/SKILL.md
```

3. **Siga as instruções** na skill

4. **Aplique as melhores práticas** ao seu projeto

---

## Agents

Agents são personas de IA especializadas para diferentes funções.

### Agents Disponíveis

| Agent | Descrição |
|-------|-----------|
| **devops-engineer** | Especialista em infraestrutura e CI/CD |
| **backend-developer** | Especialista em APIs e backend |
| **frontend-developer** | Especialista em UI/UX e frontend |
| **fullstack-developer** | Especialista full-stack |
| **mobile-developer** | Especialista em desenvolvimento mobile |
| **security-engineer** | Especialista em segurança |
| **qa-engineer** | Especialista em garantia de qualidade |
| **data-engineer** | Especialista em pipelines de dados |
| **ml-engineer** | Especialista em machine learning |
| **technical-writer** | Especialista em documentação |
| **product-manager** | Especialista em gestão de produtos |
| **ui-designer** | Especialista em design de UI |
| **site-reliability-engineer** | Especialista em SRE |

### Como Usar um Agent

1. **Encontre o agent** que você precisa:

```bash
./core/discovery/search.sh "backend"
```

2. **Leia a documentação** do agent:

```bash
cat agents/backend-developer.md
```

3. **Use a persona** nas suas conversas com assistentes de IA

4. **Aplique a expertise** ao seu projeto

---

## Prompts

Prompts são modelos reutilizáveis para tarefas comuns.

### Prompts Disponíveis

- **code-review-checklist** - Checklist abrangente para revisão de código
- **debug-analysis** - Prompt para análise de debug
- **system-design** - Prompt para design de sistemas

### Como Usar um Prompt

1. **Encontre o prompt** que você precisa:

```bash
./core/discovery/search.sh "code review"
```

2. **Leia o prompt**:

```bash
cat prompts/code-review/code-review-checklist.md
```

3. **Copie o prompt** para sua área de transferência

4. **Cole o prompt** no seu assistente de IA

---

## Templates

Templates são pontos de partida para novos projetos e assets.

### Templates Disponíveis

- **new-project** - Template para novos projetos
- **skill** - Template para criar skills
- **agent** - Template para criar agents
- **prompt** - Template para criar prompts

### Como Usar um Template

1. **Encontre o template** que você precisa:

```bash
ls templates/
```

2. **Copie o template** para seu projeto:

```bash
cp -r templates/new-project /seu/projeto/
```

3. **Customize** os arquivos conforme necessário

---

## Commands

Commands são ações rápidas para tarefas comuns.

### Commands Disponíveis

- **review** - Command para revisão de código
- **test** - Command para executar testes
- **lint** - Command para executar linting

### Como Usar um Command

1. **Encontre o command** que você precisa:

```bash
ls commands/
```

2. **Leia a documentação** do command:

```bash
cat commands/review/review.md
```

3. **Execute o command** conforme descrito

---

## Playbooks

Playbooks são passo a passo para tarefas comuns.

### Playbooks Disponíveis

- **new-project-setup** - Guia completo de configuração de projeto
- **code-review-process** - Processo de revisão de código

### Como Usar um Playbook

1. **Encontre o playbook** que você precisa:

```bash
ls playbooks/
```

2. **Leia o playbook**:

```bash
cat playbooks/new-project-setup.md
```

3. **Siga os passos** no playbook

---

## Recipes

Recipes são configurações completas de projetos com todos os componentes necessários.

### Recipes Disponíveis

- **react-project-setup** - Configuração de projeto React
- **python-project-setup** - Configuração de projeto Python

### Como Usar um Recipe

1. **Encontre o recipe** que você precisa:

```bash
ls recipes/
```

2. **Leia o recipe**:

```bash
cat recipes/react-project-setup.md
```

3. **Siga os passos** para configurar seu projeto

---

## Sistema de Descoberta

O sistema de descoberta ajuda a encontrar assets por palavra-chave, categoria ou compatibilidade.

### Buscar Assets

```bash
# Buscar por palavra-chave
./core/discovery/search.sh "docker"

# Buscar por categoria
./core/discovery/filter.sh --category=devops

# Buscar por compatibilidade
./core/discovery/filter.sh --compatible=opencode
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

## Marketplace

O marketplace permite navegar e instalar assets.

### Navegar Assets

1. Abra a interface web do marketplace:

```bash
open marketplace-web/index.html
```

2. Use a busca e filtros para encontrar assets

3. Clique em "Instalar" para instalar um asset

### Instalar Assets via CLI

```bash
# Instalar uma skill
./core/marketplace/install.sh skill docker-best-practices

# Instalar um agent
./core/marketplace/install.sh agent backend-developer
```

### Buscar Assets

```bash
./core/marketplace/search.sh "docker"
```

---

## Segurança

O kit inclui ferramentas de segurança para auditar seu projeto.

### Executar Auditorias de Segurança

```bash
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

1. **Nunca commite secrets** - Use variáveis de ambiente
2. **Execute auditorias de segurança** regularmente
3. **Mantenha dependências atualizadas**
4. **Siga práticas de codificação segura**

---

## Solução de Problemas

### Problemas Comuns

#### Problema: Scripts não executáveis

**Solução:**

```bash
chmod +x scripts/*.sh
chmod +x core/**/*.sh
chmod +x tests/**/*.sh
```

#### Problema: Sistema de descoberta não encontrando assets

**Solução:**

```bash
# Regenerar o índice
./core/discovery/index.sh
```

#### Problema: Testes falhando

**Solução:**

```bash
# Executar todos os testes
./scripts/test.sh

# Executar teste específico
./tests/skills/test-skill-content.sh
```

#### Problema: Erros de validação

**Solução:**

```bash
# Executar validação
./core/validator/validate-all.sh
```

### Obter Ajuda

- **GitHub Issues**: https://github.com/opencode-ai/opencode-engineering-kit/issues
- **Documentação**: Veja o diretório `docs/`
- **Exemplos**: Veja o diretório `examples/`

---

## Contribuindo

Nós damos as boas-vindas a contribuições! Por favor veja [CONTRIBUTING.md](./CONTRIBUTING.md) para detalhes.

### Guia Rápido de Contribuição

1. Faça um fork do repositório
2. Crie uma branch de feature
3. Faça suas alterações
4. Execute os testes
5. Submeta um pull request

---

## Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](./LICENSE) para detalhes.

---

## Agradecimentos

- [OpenCode](https://opencode.ai) pela plataforma
- [Shokunin](https://github.com/hirefrank/shokunin) pela inspiração
- [The Hive Skill](https://github.com/beingaivanshoo/the-hive-skill) pela inspiração
- Todos os contribuidores que ajudam a melhorar este projeto