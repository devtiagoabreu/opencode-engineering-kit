---
name: coding-rules-context
description: Regras de código do OpenCode Engineering Kit
type: conventions
version: 1.0.0
author: OpenCode Community
---

# Regras de Código

## Geral

1. **Simplicidade:** Manter código simples e legível
2. **Consistência:** Seguir o guia de estilo
3. **Modularidade:** Componentes independentes
4. **Testabilidade:** Fácil de testar
5. **Documentabilidade:** Fácil de documentar

## Markdown

### Regras

1. Máximo 80 caracteres por linha
2. Parágrafos separados por linha em branco
3. Usar `-` para bullets
4. Sempre especificar linguagem em code blocks
5. Usar links de referência quando possível

### Exemplo

```markdown
# Título

Parágrafo com **negrito** e *itálico*.

- Item 1
- Item 2

```python
def hello():
    print("Hello, World!")
```
```

## YAML

### Regras

1. Indentação de 2 espaços
2. Usar aspas apenas quando necessário
3. Usar formato flow para listas curtas
4. Comentários para explicar decisões

### Exemplo

```yaml
---
name: skill-name
description: Descrição da skill
tags: [tag1, tag2]
compatible:
  - opencode
  - claude-code
---
```

## Bash

### Regras

1. Shebang `#!/bin/bash`
2. `set -euo pipefail` no início
3. Indentação de 2 espaços
4. Variáveis com `${VAR}`
5. Strings com aspas duplas
6. Funções para cada tarefa
7. Variáveis locais com `local`
8. Tratar erros explicitamente

### Exemplo

```bash
#!/bin/bash
set -euo pipefail

function main() {
    local input="${1:?Uso: $0 <input>}"
    echo "Processando: ${input}"
}

main "$@"
```

## Anti-Padrões

| Anti-Padrão | Padrão Correto | Razão |
|-------------|----------------|-------|
| Hardcoded secrets | Variáveis de ambiente | Segurança |
| Código duplicado | Funções reutilizáveis | Manutenção |
| Nomes genéricos | Nomes descritivos | Legibilidade |
| Funções longas | Funções pequenas | Compreensão |
| Comentários excessivos | Código autoexplicativo | Manutenção |
| Erros silenciosos | Tratamento explícito | Depuração |
| Magic numbers | Constantes nomeadas | Legibilidade |

## Qualidade

### Métricas

| Métrica | Mínimo | Ideal |
|---------|--------|-------|
| Cobertura de testes | 80% | 90%+ |
| Complexidade ciclomática | < 10 | < 5 |
| Duplicação | < 5% | 0% |
| Documentação | 100% | 100% |

### Checklist

- [ ] Código é legível
- [ ] Nomes são descritivos
- [ ] Funções são pequenas
- [ ] Não há código duplicado
- [ ] Tratamento de erros adequado
- [ ] Testes presentes
- [ ] Documentação atualizada
