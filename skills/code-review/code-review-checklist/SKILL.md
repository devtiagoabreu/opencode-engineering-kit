---
name: code-review-checklist
description: Checklist completo para revisão de código de alta qualidade
category: code-review
version: 1.0.0
author: OpenCode Community
tags: [code-review, quality, checklist]
compatible:
  - opencode
  - claude-code
  - cursor
requires: []
provides:
  - Checklist de review
  - Critérios de avaliação
  - Melhores práticas
---

# Code Review Checklist

## Visão Geral

Esta skill fornece um checklist completo e abrangente para revisão de código,
ajudando a garantir qualidade, consistência e ausência de bugs.

## Pré-requisitos

- Acesso ao código a ser revisado
- Conhecimento da stack tecnológica
- Entender os requisitos do ticket/issue

## Instruções de Uso

### 1. Checklist Funcional

- [ ] Código atende aos requisitos especificados
- [ ] A lógica está correta
- [ ] Edge cases são tratados
- [ ] Erros são tratados adequadamente
- [ ] Validação de input presente
- [ ] Tratamento de exceções adequado

### 2. Checklist Qualidade

- [ ] Código é legível e compreensível
- [ ] Nomes são descritivos e consistentes
- [ ] Funções são coesas e pequenas
- [ ] Não há código duplicado
- [ ] Princípio DRY aplicado
- [ ] Princípio SRP aplicado

### 3. Checklist Segurança

- [ ] Não há hardcoded secrets
- [ ] Input está validado
- [ ] Output está sanitizado
- [ ] SQL injection prevenido
- [ ] XSS prevenido
- [ ] Autenticação adequada

### 4. Checklist Performance

- [ ] Não há N+1 queries
- [ ] Cache é usado adequadamente
- [ ] Não há memory leaks
- [ ] Queries são otimizadas
- [ ] Assets são comprimidos
- [ ] Lazy loading implementado

### 5. Checklist Testes

- [ ] Testes unitários presentes
- [ ] Testes de integração presentes
- [ ] Cobertura de código adequada
- [ ] Testes são independentes
- [ ] Testes são reproduzíveis
- [ ] Mocks são adequados

### 6. Checklist Documentação

- [ ] Código é autoexplicativo
- [ ] Comentários explicam "porquê", não "o quê"
- [ ] README atualizado
- [ ] API documentada
- [ ] Changelog atualizado
- [ ] Examples atualizados

### 7. Checklist Estilo

- [ ] Segue o guia de estilo
- [ ] Formatação está correta
- [ ] Indentação é consistente
- [ ] Espaçamento está adequado
- [ ] Linhas não excedem 80 caracteres
- [ ] Imports são organizados

## Exemplos

### Exemplo 1: Review de Pull Request

```markdown
## Code Review - PR #123

### Resumo
Implementa autenticação JWT para a API.

### Checklist

#### Funcionalidade
- [x] Requisitos atendidos
- [x] Lógica correta
- [x] Edge cases tratados

#### Qualidade
- [x] Código legível
- [x] Nomes descritivos
- [x] Funções coesas

#### Segurança
- [x] Secrets não hardcoded
- [x] Input validado
- [x] Output sanitizado

### Comentários
- Sugestão: usar constante para tempo de expiração
- Poderia extrair lógica de validação para função separada

### Aprovação
✅ Aprovado com minor changes
```

### Exemplo 2: Comentários de Review

```markdown
**Blocker:** Esta função não trata erro de rede.

```javascript
// Ruim
fetch(url).then(data => processData(data));

// Bom
fetch(url)
  .then(data => processData(data))
  .catch(error => handleError(error));
```

**Major:** Função muito longa, sugerir refatoração.

**Minor:** Estilo - espaço extra após vírgula.

**Nit:** Nome da variável poderia ser mais descritivo.
```

## Referências

- [Google Code Review Guide](https://google.github.io/eng-practices/review/)
- [Best Practices for Code Reviews](https://smartbear.com/best-practices-for-code-reviews/)
- [Code Review Checklist](https://www.pullrequest.com/blog/code-review-checklist/)

## Notas

- Foque no código, não na pessoa
- Seja construtivo e respeitoso
- Priorize issues por severidade
- Documente decisões importantes
- Use ferramentas de linting quando possível
