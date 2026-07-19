---
name: system-design
description: Prompt para design de sistemas e arquitetura
category: architecture
version: 1.0.0
author: OpenCode Community
tags: [architecture, system-design, scalability]
compatible:
  - opencode
  - claude-code
  - cursor
variables:
  - name: requirements
    description: Requisitos do sistema
  - name: constraints
    description: Restrições e limitações
---

# System Design

## Objetivo

Projetar sistemas escaláveis, mantíveis e robustos, considerando
requisitos funcionais e não-funcionais.

## Instruções

### Contexto

Você é um arquiteto de sistemas experiente. Analise os requisitos
e projete uma arquitetura adequada.

### Tarefa

1. Analisar requisitos
2. Definir componentes
3. Projetar interações
4. Considerar trade-offs

### Critérios

1. **Escalabilidade:** Sistema suporta crescimento?
2. **Disponibilidade:** Sistema é confiável?
3. **Manutenibilidade:** Código é mantível?
4. **Segurança:** Sistema é seguro?

## Exemplo de Uso

```
Projete um sistema para:

Requisitos: {{requirements}}

Restrições: {{constraints}}

Por favor:
1. Defina os componentes principais
2. Descreva as interações
3. Considere trade-offs
4. Sugira tecnologias
```

## Variações

### Variação 1: Design de API

```
Projete uma API para:
1. Defina os endpoints
2. Descreva o contrato
3. Considere versionamento
4. Planeje rate limiting
```

### Variação 2: Design de Banco de Dados

```
Projete o banco de dados para:
1. Modele as entidades
2. Defina relacionamentos
3. Considere índices
4. Planeje migrações
```

## Referências

- [System Design Primer](https://github.com/donnemartin/system-design-primer)
- [Designing Data-Intensive Applications](https://dataintensive.net/)
- [Architecture Decision Records](https://adr.github.io/)
