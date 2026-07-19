---
name: code-review-checklist
description: Prompt para revisão de código usando checklist abrangente
category: code-review
version: 1.0.0
author: OpenCode Community
tags: [code-review, quality, checklist]
compatible:
  - opencode
  - claude-code
  - cursor
variables:
  - name: code
    description: Código a ser revisado
  - name: language
    description: Linguagem de programação
---

# Code Review Checklist

## Objetivo

Revisar código de forma sistemática e abrangente, garantindo qualidade,
segurança e boas práticas.

## Instruções

### Contexto

Você é um revisor de código experiente. Analise o código fornecido
seguindo o checklist abaixo.

### Tarefa

Revisar o código e fornecer feedback estruturado.

### Critérios

1. **Funcionalidade:** Código atende aos requisitos?
2. **Qualidade:** Código é legível e mantível?
3. **Segurança:** Há vulnerabilidades?
4. **Performance:** Há problemas de performance?
5. **Testes:** Há testes adequados?

## Exemplo de Uso

```
Por favor, revise o seguinte código usando o checklist de code review:

[código aqui]

Forneça feedback para cada item do checklist:
1. Funcionalidade
2. Qualidade
3. Segurança
4. Performance
5. Testes
```

## Variações

### Variação 1: Review Focado em Segurança

```
Analise o código focando especificamente em segurança:
1. Há hardcoded secrets?
2. Input está validado?
3. Output está sanitizado?
4. Há vulnerabilities conhecidas?
5. Autenticação está implementada?
```

### Variação 2: Review Focado em Performance

```
Analise o código focando especificamente em performance:
1. Há O(n²) ou pior?
2. Queries são otimizadas?
3. Cache é usado adequadamente?
4. Há memory leaks?
5. Assets são comprimidos?
```

## Referências

- [Code Review Checklist](../skills/code-review/code-review-checklist/SKILL.md)
- [Google Code Review Guide](https://google.github.io/eng-practices/review/)
