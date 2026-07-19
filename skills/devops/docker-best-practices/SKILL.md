---
name: docker-best-practices
description: Guia completo de boas práticas para Docker e containers em produção
category: devops
version: 1.0.0
author: OpenCode Community
tags: [docker, containers, devops, production]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Docker 20.10+ instalado
  - Docker Compose v2+ (opcional)
provides:
  - Dockerfile otimizado
  - docker-compose.yml
  - .dockerignore
---

# Docker Best Practices

## Visão Geral

Esta skill fornece guia completo de boas práticas para criar, otimizar e
gerenciar containers Docker em ambiente de produção.

## Pré-requisitos

- Docker 20.10 ou superior
- Docker Compose v2 ou superior (opcional, para multi-container)
- Conhecimento básico de containers

## Instruções de Uso

### 1. Criando Dockerfile Otimizado

Use multi-stage builds para reduzir o tamanho da imagem:

```dockerfile
# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### 2. Usando .dockerignore

```
node_modules
.git
.env
*.md
docker-compose*.yml
```

### 3. Gerenciando Variáveis de Ambiente

```bash
# Nunca hardcode secrets
docker run -e DATABASE_URL=$DATABASE_URL myapp
```

### 4. Health Checks

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```

### 5. Segurança

```dockerfile
# Executar como usuário não-root
RUN addgroup -g 1001 -S appgroup
RUN adduser -S appuser -u 1001 -G appgroup
USER appuser
```

## Exemplos

### Exemplo 1: Node.js API

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
USER node
CMD ["node", "server.js"]
```

### Exemplo 2: Python Flask

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```

### Exemplo 3: Docker Compose Multi-Service

```yaml
version: '3.8'
services:
  api:
    build: ./api
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=${DATABASE_URL}
    depends_on:
      - db
  db:
    image: postgres:14-alpine
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data
volumes:
  postgres_data:
```

## Referências

- [Docker Official Docs](https://docs.docker.com/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Docker Security](https://docs.docker.com/engine/security/)

## Notas

- Sempre use imagens base oficiais
- Execute como usuário não-root
- Use health checks em produção
- Minimize camadas do Dockerfile
- Use .dockerignore para ignorar arquivos desnecessários
