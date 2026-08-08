#!/bin/bash
set -euo pipefail

# Persona Scaffold Script
# Cria uma nova persona (agent) com contexto e registra no histórico.
# Uso: ./scripts/persona-scaffold.sh <categoria> <nome> <descricao>

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ $# -lt 3 ]; then
    echo "Uso: $0 <categoria> <nome-kebab-case> <descricao>"
    echo "Ex.: $0 construction pedreiro 'Execução de obras civis'"
    exit 1
fi

CATEGORY="$1"
NAME="$2"
DESCRIPTION="$3"
DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

AGENT_DIR="$ROOT_DIR/assets/agents/$CATEGORY/$NAME"
AGENT_FILE="$AGENT_DIR/$NAME.md"

mkdir -p "$AGENT_DIR"

if [[ -f "$AGENT_FILE" ]]; then
    echo "ERRO: $AGENT_FILE já existe"
    exit 1
fi

cat > "$AGENT_FILE" << EOF
---
name: $NAME
description: $DESCRIPTION
version: 0.1.0
author: OpenCode Community
tags: [$CATEGORY, $NAME]
compatible:
  - opencode
  - claude-code
  - cursor
skills: []
personas:
  - $DESCRIPTION
---

# $NAME

## Pessoa

### Quem é este Agente?

Preencher: contexto do agente, experiência e especialização.

### Papel e Responsabilidades

- Preencher responsabilidade 1
- Preencher responsabilidade 2

### Estilo de Comunicação

Preencher estilo de comunicação.

## Habilidades e Capacidades

- Preencher habilidade 1
- Preencher habilidade 2

## Contexto

### Conhecimento Técnico

- Preencher conhecimento técnico

### Boas Práticas

- Preencher boas práticas

## Como ajuda as personas de tecnologia

Preencher: como esta persona passa parâmetros técnicos da sua área para
backend-developer, frontend-developer, devops-engineer etc., sempre olhando
o que o usuário está querendo criar.

## Exemplos de Uso

### Exemplo 1: Título

\`\`\`bash
exemplo
\`\`\`

## Referências

- Preencher referência
EOF

cat > "$AGENT_DIR/metadata.json" << EOF
{
  "schema_version": "1.0.0",
  "generated_at": "$DATE",
  "validated_at": null,
  "validation_passed": false,
  "warnings": [],
  "dependencies_resolved": true,
  "dependencies": [],
  "name": "$NAME",
  "version": "0.1.0",
  "category": "$CATEGORY",
  "description": "$DESCRIPTION"
}
EOF

echo "### $(date +%Y-%m-%d) — Persona $NAME" >> "$ROOT_DIR/context/HISTORY.md"
echo "" >> "$ROOT_DIR/context/HISTORY.md"
echo "- **Adicionada persona:** $CATEGORY/$NAME — $DESCRIPTION" >> "$ROOT_DIR/context/HISTORY.md"
echo "- **Arquivos:** \`$AGENT_FILE\` + \`metadata.json\` (contexto em \`## Contexto\` e \`## Como ajuda as personas de tecnologia\`)" >> "$ROOT_DIR/context/HISTORY.md"
echo "" >> "$ROOT_DIR/context/HISTORY.md"

echo "Persona criada: $AGENT_FILE"
echo "Histórico atualizado: $ROOT_DIR/context/HISTORY.md"
