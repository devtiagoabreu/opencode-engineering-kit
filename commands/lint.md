---
name: lint
description: Comando para verificar linting de código
version: 1.0.0
author: OpenCode Community
tags: [linting, code-quality]
compatible:
  - opencode
  - claude-code
  - cursor
---

# /lint

## Uso

```
/lint [arquivo_ou_diretorio]
```

## Descrição

Executa ferramentas de linting no código, verificando formatação,
estilo e possíveis erros.

## Argumentos

| Argumento | Obrigatório | Descrição | Padrão |
|-----------|-------------|-----------|--------|
| arquivo | Não | Arquivo ou diretório a verificar | Todo o projeto |

## Exemplos

```bash
/lint
/lint src/main.py
/lint ./src/
```

## Notas

- Detecta automaticamente as ferramentas de linting disponíveis
- Reporta erros e warnings
- Sugere correções quando possível
