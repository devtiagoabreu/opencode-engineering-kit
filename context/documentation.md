---
name: documentation-context
description: Convenções de documentação do OpenCode Engineering Kit
type: conventions
version: 1.0.0
author: OpenCode Community
---

# Convenções de Documentação

## Tipos de Documentação

| Tipo | Localização | Objetivo |
|------|-------------|----------|
| README | Raiz do projeto | Visão geral |
| CONTRIBUTING | Raiz do projeto | Como contribuir |
| CHANGELOG | Raiz do projeto | Histórico |
| PROJECT_SPEC | Raiz do projeto | Especificação |
| ROADMAP | Raiz do projeto | Roadmap |
| API Docs | docs/api.md | Referência API |
| Skills Docs | Em cada skill | Uso da skill |
| Agent Docs | Em cada agent | Uso do agent |

## Padrões de Documentação

### README.md

```markdown
# Nome do Projeto

> Breve descrição

## Visão Geral

Descrição detalhada...

## Instalação

### Pré-requisitos

- Requisito 1
- Requisito 2

### Instalação

```bash
comando
```

## Uso

### Exemplo Básico

```bash
comando
```

### Exemplo Avançado

```bash
comando
```

## Contribuindo

Leia [CONTRIBUTING.md](./CONTRIBUTING.md)

## Licença

[MIT](./LICENSE)
```

### CONTRIBUTING.md

```markdown
# Contribuindo

## Como Contribuir

1. Fork o projeto
2. Crie uma branch
3. Implemente sua feature
4. Adicione testes
5. Atualize documentação
6. Crie um PR

## Branch Naming

- `feature/<nome>` - Nova feature
- `bugfix/<nome>` - Correção de bug
- `hotfix/<nome>` - Correção urgente

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new skill
fix: correct typo in README
docs: update installation guide
```

## Code Review

Todo PR precisa de pelo menos 1 aprovação.

## Testes

Execute testes antes de submeter PR:

```bash
./scripts/test.sh
```
```

## Geração de Documentação

| Ferramenta | Uso | Automação |
|------------|-----|-----------|
| Markdown lint | Verificar formatação | GitHub Actions |
| Link checker | Verificar links | GitHub Actions |
| Spell check | Verificar ortografia | Manual |
| Screenshot | Capturar imagens | Manual |

## Manutenção de Documentação

1. **Atualização automática:** CHANGELOG via commits
2. **Revisão manual:** README e CONTRIBUTING
3. **Validação:** Links e exemplos
4. **Versionamento:** Sincronizado com releases

## Formato de Arquivos

### Skills

```markdown
---
name: skill-name
description: Descrição
category: categoria
version: 1.0.0
author: Autor
tags: [tag1, tag2]
compatible:
  - opencode
  - claude-code
  - cursor
---

# Nome da Skill

## Visão Geral
## Pré-requisitos
## Instruções de Uso
## Exemplos
## Referências
## Notas
```

### Agents

```markdown
---
name: agent-name
description: Descrição
version: 1.0.0
author: Autor
tags: [tag1, tag2]
compatible:
  - opencode
  - claude-code
  - cursor
skills: []
personas: []
---

# Nome do Agent

## Persona
## Capacidades
## Contexto
## Exemplos de Uso
## Referências
```

### Templates

```markdown
---
name: template-name
description: Descrição
category: categoria
version: 1.0.0
author: Autor
tags: [tag1, tag2]
compatible:
  - opencode
  - claude-code
  - cursor
variables: []
---

# Nome do Template

## Visão Geral
## Uso
## Estrutura
## Variáveis
## Exemplo
## Referências
```
