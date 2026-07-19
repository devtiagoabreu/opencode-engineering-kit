---
name: performance-context
description: Contexto de performance do OpenCode Engineering Kit
type: project
version: 1.0.0
author: OpenCode Community
---

# Contexto de Performance

## Objetivos de Performance

| Métrica | Meta | Medição |
|---------|------|---------|
| Tempo de carregamento | < 1s | Medição manual |
| Tamanho de arquivo | < 1MB | wc -c |
| Complexidade | O(n) | Análise de código |
| Memória | < 100MB | top/htop |

## Limites

| Recurso | Limite | Ação |
|---------|--------|------|
| Tamanho de skill | 500 linhas | Dividir em múltiplas |
| Tamanho de agent | 200 linhas | Simplificar |
| Tamanho de prompt | 100 linhas | Simplificar |
| Total de skills | 100+ | Organizar melhor |
| Total de agents | 50+ | Consolidar |

## Otimizações

### Arquivos

- Usar compressão para arquivos grandes
- Dividir arquivos muito longos
- Usar lazy loading quando possível

### Scripts

- Evitar loops desnecessários
- Usar comandos eficientes do shell
- Minimizar chamadas ao sistema

### Documentação

- Usar links de referência
- Evitar imagens grandes
- Comprimir assets quando necessário

## Benchmarks

```bash
# Medir tempo de execução
time ./scripts/bootstrap.sh

# Medir tamanho
du -sh skills/
du -sh agents/
du -sh templates/

# Medir complexidade
find . -name "*.md" | wc -l
find . -name "*.sh" | wc -l
```

## Monetização

### Performance

- Monitorar tempo de carregamento
- Rastrear tamanho dos arquivos
- Medir uso de memória

### Qualidade

- Verificar cobertura de testes
- Medir taxa de erros
- Rastrear satisfação do usuário
