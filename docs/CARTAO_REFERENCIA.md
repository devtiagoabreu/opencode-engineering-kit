# Cartão de Referência Rápida

> Referência de uma página para usar o OpenCode Engineering Kit

---

## Instalação

```bash
git clone https://github.com/opencode-ai/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

---

## Comandos Comuns

### Descoberta

```bash
# Buscar assets
./core/discovery/search.sh "docker"

# Filtrar por categoria
./core/discovery/filter.sh --category=devops

# Filtrar por compatibilidade
./core/discovery/filter.sh --compatible=opencode

# Gerar índice
./core/discovery/index.sh
```

### Validação

```bash
# Validar todos os assets
./core/validator/validate-all.sh

# Validar asset específico
./core/validator/validate.sh skills/devops/docker-best-practices
```

### Testes

```bash
# Executar todos os testes
./scripts/test.sh

# Executar categoria específica
./tests/skills/test-skill-content.sh
./tests/agents/test-agent-content.sh
./tests/discovery/test-discovery-system.sh
./tests/security/test-security.sh
./tests/performance/test-performance.sh
```

### Segurança

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

### Marketplace

```bash
# Buscar marketplace
./core/marketplace/search.sh "docker"

# Instalar asset
./core/marketplace/install.sh skill docker-best-practices

# Abrir interface web
open marketplace-web/index.html
```

### Resolução de Dependências

```bash
# Resolver dependências
./core/resolver/resolve.sh skills/devops/docker-best-practices

# Gerar gráfico de dependências
./core/resolver/graph.sh

# Validar dependências
./core/resolver/validate.sh
```

### Sistema de Plugins

```bash
# Carregar plugins
./core/plugin/loader.sh

# Instalar plugin
./core/plugin/installer.sh my-plugin

# Desinstalar plugin
./core/plugin/uninstaller.sh my-plugin
```

---

## Estrutura de Diretórios

```
opencode-engineering-kit/
├── skills/              # Skills organizadas por categoria
│   ├── devops/
│   ├── backend/
│   ├── frontend/
│   ├── testing/
│   └── security/
├── agents/              # Agents com personas
├── prompts/             # Prompts reutilizáveis
├── templates/           # Modelos de projeto
├── commands/            # Comandos customizados
├── playbooks/           # Passo a passo
├── recipes/             # Configurações completas
├── context/             # Contexto do projeto
├── core/                # Infraestrutura core
│   ├── registry/        # Registro de assets
│   ├── discovery/       # Descoberta de assets
│   ├── resolver/        # Resolução de dependências
│   ├── validator/       # Validação de schemas
│   ├── version/         # Sistema de versionamento
│   ├── plugin/          # Sistema de plugins
│   ├── marketplace/     # Marketplace
│   ├── security/        # Ferramentas de segurança
│   └── quality/         # Quality gates
├── marketplace-web/     # Interface web do marketplace
├── tests/               # Testes
├── scripts/             # Scripts de automação
└── docs/                # Documentação
```

---

## Estrutura de uma Skill

```
nome-skill/
├── SKILL.md            # Documentação principal da skill
├── metadata.json       # Metadados da skill
├── README.md           # Documentação adicional
└── examples/           # Exemplos de uso
```

---

## Estrutura de um Agent

```yaml
---
name: nome-agent
description: Descrição do agent
version: 0.1.0
author: Nome do Autor
tags: [tag1, tag2]
compatible:
  - opencode
  - claude-code
  - cursor
skills:
  - skill1
  - skill2
personas:
  - Persona 1
  - Persona 2
---

# Nome do Agent

## Persona
...

## Capacidades
...

## Contexto
...

## Exemplos de Uso
...
```

---

## Criando Novos Assets

### Criar uma Skill

1. Copie o modelo de skill:

```bash
cp -r templates/skill skills/categoria/nova-skill
```

2. Edite `SKILL.md` com seu conteúdo

3. Execute a validação:

```bash
./core/validator/validate.sh skills/categoria/nova-skill
```

### Criar um Agent

1. Copie o modelo de agent:

```bash
cp templates/agent/agent.md agents/novo-agent.md
```

2. Edite o arquivo do agent com seu conteúdo

3. Execute a validação:

```bash
./core/validator/validate.sh agents/novo-agent.md
```

---

## Quality Gates

Todos os assets devem passar:

- **Validação de schema** - Metadados válidos
- **Validação de conteúdo** - Seções obrigatórias
- **Linting** - Padrões Markdown
- **Testes** - Testes automatizados

Execute verificações de qualidade:

```bash
./core/quality/validate.sh
```

---

## Suporte

- **GitHub Issues**: https://github.com/opencode-ai/opencode-engineering-kit/issues
- **Documentação**: Veja o diretório `docs/`
- **Exemplos**: Veja o diretório `examples/`