---
name: api-design
description: Guia completo de design de APIs RESTful
category: backend
version: 1.0.0
author: OpenCode Community
tags: [api, rest, backend, design]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Conhecimento básico de HTTP
provides:
  - Padrões de design de API
  - Convenções REST
  - Melhores práticas
---

# API Design

## Visão Geral

Esta skill fornece guia completo para design de APIs RESTful, incluindo
convenções, padrões e melhores práticas.

## Pré-requisitos

- Conhecimento básico de HTTP
- Entender verbos HTTP
- Conhecimento de status codes

## Instruções de Uso

### 1. Convenções de URL

```
# Recursos no plural
GET    /api/v1/usuarios
GET    /api/v1/usuarios/123
POST   /api/v1/usuarios
PUT    /api/v1/usuarios/123
DELETE /api/v1/usuarios/123

# Sub-recursos
GET    /api/v1/usuarios/123/posts
GET    /api/v1/usuarios/123/posts/456

# Ações específicas
POST   /api/v1/usuarios/123/ativar
POST   /api/v1/usuarios/123/desativar
```

### 2. Verbos HTTP

| Verbo | Uso | Idempotente |
|-------|-----|-------------|
| GET | Ler recurso | Sim |
| POST | Criar recurso | Não |
| PUT | Atualizar recurso completo | Sim |
| PATCH | Atualizar parcialmente | Não |
| DELETE | Deletar recurso | Sim |

### 3. Status Codes

| Código | Uso |
|--------|-----|
| 200 | Sucesso |
| 201 | Criado |
| 204 | Sem conteúdo |
| 400 | Bad Request |
| 401 | Não autenticado |
| 403 | Não autorizado |
| 404 | Não encontrado |
| 409 | Conflito |
| 422 | Unprocessable Entity |
| 500 | Erro interno |

### 4. Formato de Resposta

```json
// Sucesso
{
  "data": {
    "id": 123,
    "nome": "João",
    "email": "joao@email.com"
  },
  "meta": {
    "timestamp": "2026-07-18T10:00:00Z"
  }
}

// Lista
{
  "data": [
    {"id": 1, "nome": "João"},
    {"id": 2, "nome": "Maria"}
  ],
  "meta": {
    "total": 2,
    "page": 1,
    "per_page": 10
  }
}

// Erro
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email inválido",
    "details": [
      {
        "field": "email",
        "message": "Formato de email inválido"
      }
    ]
  }
}
```

### 5. Versionamento

```
# Via URL (recomendado)
/api/v1/usuarios
/api/v2/usuarios

# Via header
Accept: application/vnd.api.v1+json
```

### 6. Paginação

```
GET /api/v1/usuarios?page=2&per_page=10

# Resposta
{
  "data": [...],
  "meta": {
    "total": 100,
    "page": 2,
    "per_page": 10,
    "total_pages": 10
  },
  "links": {
    "self": "/api/v1/usuarios?page=2&per_page=10",
    "next": "/api/v1/usuarios?page=3&per_page=10",
    "prev": "/api/v1/usuarios?page=1&per_page=10"
  }
}
```

### 7. Filtros e Busca

```
# Filtros
GET /api/v1/usuarios?status=ativo&role=admin

# Busca
GET /api/v1/usuarios?search=joao

# Ordenação
GET /api/v1/usuarios?sort=nome&order=asc

# Campos específicos
GET /api/v1/usuarios?fields=id,nome,email
```

## Exemplos

### Exemplo 1: CRUD Completo

```python
# routes/usuarios.py
from fastapi import APIRouter, HTTPException

router = APIRouter(prefix="/api/v1/usuarios", tags=["usuarios"])

@router.get("/")
async def listar_usuarios():
    return {"data": usuarios}

@router.get("/{id}")
async def obter_usuario(id: int):
    usuario = buscar_usuario(id)
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")
    return {"data": usuario}

@router.post("/")
async def criar_usuario(usuario: CriarUsuario):
    novo_usuario = criar(usuario)
    return {"data": novo_usuario}, 201

@router.put("/{id}")
async def atualizar_usuario(id: int, usuario: AtualizarUsuario):
    usuario_atualizado = atualizar(id, usuario)
    return {"data": usuario_atualizado}

@router.delete("/{id}")
async def deletar_usuario(id: int):
    deletar(id)
    return None, 204
```

## Referências

- [Microsoft REST API Guidelines](https://github.com/microsoft/api-guidelines)
- [JSON:API Specification](https://jsonapi.org/)
- [RESTful API Design - Best Practices](https://hackernoon.com/restful-api-designing-guidelines-the-best-practices-60e1d954e7c9)

## Notas

- Use nouns, não verbos nas URLs
- Mantenha consistência em nomes
- Documente tudo com OpenAPI/Swagger
- Use versionamento desde o início
- Implemente rate limiting
- Valide todos os inputs
