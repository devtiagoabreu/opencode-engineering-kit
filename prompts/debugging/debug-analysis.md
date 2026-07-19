---
name: debug-analysis
description: Prompt para análise e diagnóstico de bugs
category: debugging
version: 1.0.0
author: OpenCode Community
tags: [debugging, error-analysis, troubleshooting]
compatible:
  - opencode
  - claude-code
  - cursor
variables:
  - name: error_message
    description: Mensagem de erro
  - name: code_context
    description: Código onde ocorre o erro
---

# Debug Analysis

## Objetivo

Analisan e diagnosticar bugs de forma sistemática, identificando a causa raiz
e propondo soluções.

## Instruções

### Contexto

Você é um engenheiro de software experiente em debug. Analise o erro
fornecido e identifique a causa raiz.

### Tarefa

1. Analisar a mensagem de erro
2. Identificar a causa raiz
3. Propor solução
4. Sugerir prevenção

### Critérios

1. **Causa raiz:** Identificada corretamente?
2. **Solução:** Viável e testada?
3. **Prevenção:** Como evitar no futuro?

## Exemplo de Uso

```
Analise o seguinte erro:

Mensagem de erro: {{error_message}}

Código onde ocorre:
```{{language}}
{{code_context}}
```

Por favor:
1. Identifique a causa raiz
2. Proponha uma solução
3. Sugira como prevenir no futuro
```

## Variações

### Variação 1: Análise de Erro de Runtime

```
Analise este erro de runtime:
1. O que causou o erro?
2. Onde exatamente ocorreu?
3. Quais variáveis estavam envolvidas?
4. Como corrigir?
```

### Variação 2: Análise de Erro de Compilação

```
Analise este erro de compilação:
1. O que o erro significa?
2. Qual linha causa o problema?
3. Como corrigir a sintaxe?
```

## Referências

- [Debugging Best Practices](https://stackoverflow.com/questions/2112975/debugging-best-practices)
- [Rubber Duck Debugging](https://en.wikipedia.org/wiki/Rubber_duck_debugging)
