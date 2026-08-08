---
name: history
description: Histórico de mudanças, decisões e adições do kit (sempre atualizado a cada alteração)
type: decisions
version: 0.1.0
author: OpenCode Community
---

# Histórico do Kit

## O que é

Este arquivo é o **histórico de contexto** do kit. A cada mudança relevante
(nova persona, nova skill, novo template, decisão de arquitetura), uma entrada
é adicionada aqui para que a IA sempre tenha contexto do que foi criado e por
quê.

## Entradas

### 2026-08-08 — Personas de domínio e certificações

- **Adicionadas 31 personas** em 12 novas categorias (construction, finance,
  marketing, science, humanities, engineering, logistics, web, health,
  management, cloud) e na categoria existente `design`.
- **Foco:** cada persona de domínio colabora com as personas de tecnologia,
  fornecendo parâmetros técnicos da sua área de acordo com o que o usuário
  está criando (seção "Como ajuda as personas de tecnologia").
- **Skills novas** para as áreas: construção, finanças, marketing, ciências,
  engenharia, web/scraping, looker studio, logística, lean, saúde, AWS e
  Google Cloud.
- **Decisão:** conteúdo em português para personas de domínio (público BR),
  mantendo os cabeçalhos compatíveis com os testes do kit
  (Persona/Pessoa, Habilidades/Capacidades, Exemplos/Exemplos de Uso).

### 2026-08-08 — Skills de contexto LLM

- **Adicionadas 5 skills** de contexto/LLM: `doc-to-markdown` (MarkItDown),
  `repo-to-llm` (gittomd/llms.txt), `code-knowledge-graph` (Graphify),
  `context-optimization` (Repomix/token economy), `skill-spector`
  (NVIDIA SkillSpector).
- **Decisão:** incluir automaticamente na instalação via `assets/skills/**`
  (o CLI copia recursivamente, sem configuração extra).

### 2026-07-18 — Fundação

- Estrutura inicial: skills, agents, prompts, templates, context, core
  (registry/discovery/resolver/version/plugin/security/quality), CI e testes.
- Versão 0.1.0 (semver).
