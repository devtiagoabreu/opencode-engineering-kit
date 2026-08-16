# Cartão de Referência Rápida

> Referência de uma página para usar o OpenCode Engineering Kit

---

## Instalação

```bash
# Em um projeto existente (recomendado)
npx opencode-engineering-kit install

# Instalação global
curl -fsSL https://raw.githubusercontent.com/devtiagoabreu/opencode-engineering-kit/main/install.sh | bash

# Clonar o repositório
git clone https://github.com/devtiagoabreu/opencode-engineering-kit.git
cd opencode-engineering-kit
./scripts/bootstrap.sh
```

---

## Uso Automático

Depois de instalar no projeto, o OpenCode **verifica e usa sozinho** a skill/persona relevante (registrado via `context/AUTO_USAGE.md` → `opencode.json > instructions`). Sem comandos — apenas um aviso curto do que foi usado.

- `Implementar endpoint Next.js` → skill `nextjs-development`
- `Query lenta` → persona `postgresql-dba`
- `API em C#` → skill `csharp-best-practices` + persona `csharp-developer`
- `Revisar PR` → persona `qa-engineer`
- Desativar: remover `.opencode/context/auto_usage.md` de `instructions` e reiniciar

---

## CLI

```bash
npx opencode-engineering-kit install                  # instalar no projeto atual
npx opencode-engineering-kit install --global         # instalar global (~/.config/opencode/)
npx opencode-engineering-kit install --only skills    # só skills
npx opencode-engineering-kit status                   # ver onde está instalado e se está ativo
npx opencode-engineering-kit start                    # reativar o kit
npx opencode-engineering-kit stop                     # desativar (mantém arquivos)
npx opencode-engineering-kit list --type skills       # listar skills
npx opencode-engineering-kit search "docker"          # buscar assets
npx opencode-engineering-kit doctor                   # verificar integridade do kit
npx opencode-engineering-kit upgrade                  # reinstalar com --force
npx opencode-engineering-kit export claude            # exportar para Claude Code
npx opencode-engineering-kit export cursor            # exportar para Cursor
npx opencode-engineering-kit export opencode          # exportar nativo OpenCode
```

---

## Descoberta

```bash
./core/discovery/search.sh "docker"                    # buscar por palavra-chave
./core/discovery/filter.sh --category=devops           # filtrar por categoria
./core/discovery/filter.sh --compatible=opencode       # filtrar por compatibilidade
./core/discovery/related.sh docker-best-practices      # assets relacionados
./core/discovery/recommend.sh                          # recomendações
./core/discovery/index.sh                              # gerar índice
```

### SkillPointer / Vault

```bash
./core/discovery/pointer.sh resolve repo-to-llm        # conteúdo completo (sob demanda)
./core/discovery/pointer.sh vault repo-to-llm          # meta + tokens (JSON)
./core/discovery/pointer.sh tokens <arquivo>           # estimativa de tokens
./core/discovery/pointer.sh list                       # listar entradas do vault
./core/discovery/pointer.sh list --pointer             # listar skills ponteiro
./core/discovery/pointer.sh is-pointer repo-to-llm     # é ponteiro? (true/false)
```

---

## Validação e Qualidade

```bash
./core/validator/validate-all.sh                       # validar todos os assets
./core/validator/validate.sh assets                     # validar diretório (skills/ + agents/)
./core/quality/validate.sh                             # quality gates
./scripts/typecheck.sh                                 # type checks
```

---

## Testes

```bash
./scripts/test.sh                                      # rodar todos os testes
./tests/skills/test-skill-content.sh                   # testes de skills
./tests/agents/test-agent-content.sh                   # testes de agents
./tests/discovery/test-pointer.sh                      # testes do SkillPointer/vault
./tests/security/test-skill-scan.sh                    # testes do scan de segurança
```

---

## Segurança

```bash
./core/security/skill-scan.sh                          # scan de conteúdo de skills (PASS/WARN/FAIL)
./core/security/dependency-audit.sh                    # auditoria de dependências
./core/security/secret-scan.sh                         # busca de secrets
./core/security/vulnerability-scan.sh                  # busca de vulnerabilidades
./core/security/access-control.sh                      # controle de acesso
./core/security/audit-log.sh                           # logging de auditoria
```

---

## Marketplace

```bash
./core/marketplace/search.sh "docker"                  # buscar marketplace
./core/marketplace/install.sh skill docker-best-practices
./core/marketplace/rate.sh add --asset <nome> --reviewer <usuario> --rating <1-5>
./core/marketplace/publish.sh --type skill --path ./assets/skills/minha-skill
open marketplace-web/index.html                        # interface web
```

---

## Resolução de Dependências

```bash
./core/resolver/resolve.sh assets/skills/devops/docker-best-practices
./core/resolver/graph.sh                               # gráfico de dependências
./core/resolver/validate.sh                            # validar dependências
./core/resolver/lock.sh                                # gerar lockfile
```

---

## Plugins

```bash
./core/plugin/loader.sh                                # carregar plugins
./core/plugin/installer.sh asset-linter                # instalar plugin
./core/plugin/uninstaller.sh meu-plugin                # desinstalar plugin
./core/plugin/hooks.sh --list                          # listar hooks
source core/plugin/sdk.sh                              # SDK para criar plugins
```

---

## Memória de Sessão

```bash
export KIT_MEMORY=1
python3 context/memory/memory.py init                  # inicializar memória (SQLite)
python3 context/memory/memory.py --help                # salvar/buscar/healthcheck
```

---

## Estrutura de Diretórios

```
opencode-engineering-kit/
├── assets/              # Todos os recursos reutilizáveis
│   ├── skills/          # 150 skills em 42 categorias (SKILL.md)
│   ├── agents/          # 103 personas em 38 categorias
│   ├── prompts/         # 10 prompts reutilizáveis
│   ├── templates/       # 16 templates
│   ├── commands/        # 4 comandos documentados
│   ├── playbooks/       # 3 fluxos de múltiplas etapas
│   ├── recipes/         # 2 soluções completas
│   ├── bundles/         # 2 pacotes prontos
│   ├── compositions/    # 2 equipes de agentes
│   ├── prompt-chains/   # 2 cadeias de prompts
│   └── vault/           # Conteúdo curado carregado sob demanda
├── context/             # Contexto para IA (projeto, stack, personas...)
├── core/                # Infraestrutura do kit
│   ├── registry/        # Registro + schema + manifest
│   ├── discovery/       # Busca, filtros, pointer (vault)
│   ├── resolver/        # Dependências + lockfile
│   ├── version/         # Semver + compatibilidade
│   ├── plugin/          # Plugins e hooks
│   ├── marketplace/     # Marketplace CLI
│   ├── security/        # Scans de segurança
│   ├── quality/         # Gates de qualidade + dashboard
│   └── validator/       # Validação de assets
├── cli/                 # CLI npm (npx opencode-engineering-kit)
├── plugins/             # Plugins de exemplo
├── marketplace-web/     # Interface web do marketplace
├── scripts/             # bootstrap, test, deploy, monitor...
├── tests/               # 25 suítes de teste
├── docs/                # Documentação (EN + PT)
├── install.sh           # Instalação global
├── uninstall.sh         # Remoção
└── update.sh            # Atualização
```

---

## Estrutura de uma Skill

```
assets/skills/<categoria>/<nome-skill>/
├── SKILL.md            # Documentação principal da skill (frontmatter YAML)
└── metadata.json       # Metadados gerados
```

Skills "ponteiro" (`pointer: true`) apontam para `assets/vault/<categoria>/<skill>/` com `content.md` + `meta.json`.

---

## Estrutura de um Agent

```
assets/agents/<categoria>/<nome-agent>/
├── <nome-agent>.md     # Persona (frontmatter YAML + conteúdo)
└── metadata.json       # Metadados gerados
```

---

## Criando Novos Assets

### Criar uma Skill

1. Copie o modelo de skill:

    ```bash
    cp -r assets/templates/skill assets/skills/categoria/nova-skill
    ```

2. Edite `SKILL.md` com seu conteúdo (inclua o bloco `provenance` com `source_url`)

3. Execute a validação:

    ```bash
    ./core/validator/validate-all.sh
    ./core/quality/validate.sh
    ./scripts/test.sh
    ```

### Criar um Agent

1. Use o scaffolder:

    ```bash
    ./scripts/persona-scaffold.sh construction mestre-de-obras "Gestão de obras"
    ```

2. Edite o arquivo da persona e registre no histórico

3. Execute a validação:

    ```bash
    ./core/validator/validate-all.sh
    ```

---

## Quality Gates

Todos os assets devem passar:

- **Validação de schema** — metadados válidos (JSON Schema)
- **Validação de conteúdo** — seções obrigatórias
- **Scan de segurança** — `core/security/skill-scan.sh` (PASS/WARN/FAIL)
- **Provenance** — bloco `provenance` com `source`, `source_url`, `license`, `verified`
- **Testes** — testes automatizados (`./scripts/test.sh`)
- **Linting** — Markdown/YAML/Shell

---

## Suporte

- **GitHub Issues**: <https://github.com/devtiagoabreu/opencode-engineering-kit/issues>
- **Documentação**: Veja o diretório `docs/`
- **Exemplos**: Veja o diretório `examples/`
