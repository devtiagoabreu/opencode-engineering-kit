---
name: review
description: Comando para revisar código atual
version: 1.0.0
author: OpenCode Community
tags: [code-review, quality]
compatible:
  - opencode
  - claude-code
  - cursor
---

# /review

## Uso

```
/review [arquivo_ou_diretorio]
```

## Descrição

Revisa o código especificado ou o código atual, fornecendo feedback
sobre qualidade, segurança e boas práticas.

## Argumentos

| Argumento | Obrigatório | Descrição | Padrão |
|-----------|-------------|-----------|--------|
| arquivo | Não | Arquivo ou diretório a revisar | Código atual |

## Exemplos

```bash
/review
/review src/main.py
/review ./src/
```

## Notas

- Se nenhum arquivo for especificado, revisa o código atual
- Usa o checklist de code review
- Fornece feedback estruturado
