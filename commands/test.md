---
name: test
description: Comando para executar testes
version: 1.0.0
author: OpenCode Community
tags: [testing, automation]
compatible:
  - opencode
  - claude-code
  - cursor
---

# /test

## Uso

```
/test [tipo] [filtro]
```

## Descrição

Executa testes do projeto, permitindo filtrar por tipo e/arquivo.

## Argumentos

| Argumento | Obrigatório | Descrição | Padrão |
|-----------|-------------|-----------|--------|
| tipo | Não | Tipo de teste (unit, integration, all) | all |
| filtro | Não | Filtro para testes específicos | Todos |

## Exemplos

```bash
/test
/test unit
/test integration
/test unit test_main
```

## Notas

- Detecta automaticamente o framework de testes
- Fornece relatório de cobertura
- Mostra testes que falharam
