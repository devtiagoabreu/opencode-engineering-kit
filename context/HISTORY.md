---
name: history
description: Histórico de mudanças, decisões e adições do kit (sempre atualizado a cada alteração)
type: decisions
version: 0.1.0
author: devtiagoabreu
---

# Histórico do Kit

## O que é

Este arquivo é o **histórico de contexto** do kit. A cada mudança relevante
(nova persona, nova skill, novo template, decisão de arquitetura), uma entrada
é adicionada aqui para que a IA sempre tenha contexto do que foi criado e por
quê.

## Entradas

### 2026-11-25 (2) — Web/UI acessível, Vercel/JS e Python moderno

- **Pesquisa:** curadoria de três eixos em `docs/WEB_UI_VERCEL_PYTHON_RESEARCH.md` — UI/SaaS (acessibilidade, intuitividade, beleza), JS/TS na Vercel e Python moderno. Stars aproximados (GitHub API 403); licenças confirmadas quando possível.
- **7 skills novas (`beta`):** `frontend/a11y-audit`, `design/ui-visual-craft`, `design/design-review-critic`, `design/design-tokens-pipeline`, `devops/vercel-runtime-and-cache`, `security/nextjs-web-security`, `languages/python-modern-tooling`.
- **1 persona nova (`beta`):** `design/design-reviewer` — crítica renderizada em 1280/390 e light/dark; gates verdes não bastam para aprovar.
- **Atualizações:** `accessibility` (WCAG 2.2), `python-best-practices` (uv/ruff), `vercel-deployment`, `nextjs-development`, `shadcn-ui` e oito agents de tecnologia passaram a referenciar as novas skills.
- **Decisão:** adaptar gates verificáveis (axe/Lighthouse/browser) e separar "correção" de "qualidade"; rejeitar dark patterns, UI gerada por IA sem revisão, telemetria involuntária do plugin Vercel e padrões deprecados (`middleware.ts`, `runtime='edge'`, `vercel env add --value`).
- **Publicação:** pacote npm `opencode-engineering-kit` na pasta `cli/` preparado para `npx opencode-engineering-kit install`.

### 2026-11-25 — Psicologia, crise e governança de pessoas

- **Pesquisa de repositórios:** curadoria de 30 repositórios/fontes com skills e agents de psicologia clínica, neurodiversidade e people ops (C-SSRS/SAFE-T, Stanley-Brown, WHO mhGAP, Edmondson, Deci & Ryan, JD-R, ISO 30414, SHRM, NIST AI RMF, EU AI Act). O mapeamento está em `docs/APRENDA_REPOSITORIOS.md`, `docs/REFERENCE_CAPABILITIES.md` e no relatório completo `docs/PSYCHOLOGY_AGENT_RESEARCH.md`.
- **5 skills novas (`beta`):** `mental-health-crisis-protocol`, `evidence-based-scales`, `counseling-frameworks`, `adhd-executive-function`, `people-governance-psychology`.
- **1 persona nova (`beta`):** `management/psicologo-organizacional` — diagnóstico sistêmico, não de pessoas; decisão de emprego sempre humana e nomeada.
- **Agents de saúde atualizados:** `psicologo`, `psiquiatra`, `especialista-em-autismo` e `especialista-em-tdah` passaram a referenciar o gate de crise e as skills de escalas/frameworks; `maturity` adicionado ao `metadata.json`.
- **Segurança:** `evals/evals.md` com 8 prompts e critérios de reprovação (ideação com plano, sinal ambíguo, pedido de medicação, item 9 do PHQ-9, meltdown com autolesão, TDAH com sofrimento agudo, pedido de dado individual de RH, speak-up com medo de retaliação).
- **Decisão:** manter postura estritamente informativa/educacional — sem diagnóstico, prescrição, terapia ou decisão de RH automatizada. Licenças ausentes/ambíguas (OpenClaw-Medical-Skills, polar-bear-org, borghei, rhavekost, salikkhann) foram usadas somente como referência de ideias, sem cópia de texto.

### 2026-08-10 — Educação, cultura, comércio, direito, política e qualidade

- **Adicionadas 39 personas** em novas categorias: `education` (11 professores
  + alfabetização + vestibular), `music` (músico, método Suzuki), `arts`
  (maquiador, estilista, cabeleireiro, bailarina, coreógrafo, roteirista),
  `sports` (personal-trainer), `automotive` (mecânico, mecânico de avião),
  `commercial` (tecelagem, plásticos, e-commerce, relacionamento com cliente),
  `languages` (professor de idiomas), `ai` (especialista em LLMs gratuitos) e
  nas existentes `humanities` (geopolítica, análise política, advogado
  trabalhista, criminalista), `marketing` (marketeiro político, criador de
  jingles políticos), `planner` (orquestrador).
- **Adicionadas 35 skills** em novas categorias: `education` (planejamento de
  aulas, métodos, avaliação, evidências, vestibular), `music`, `arts`, `sports`,
  `automotive`, `commercial`, `languages` e `ai` (LLMs gratuitos), além de
  `health/nutrition` e `humanities` (geopolítica, análise política, marketing
  político, jingles políticos).
- **Orquestrador:** novo agente `planner/orquestrador` que planeja, delega aos
  agentes certos, mostra a procedência das ferramentas e pergunta ao usuário.
- **Procedência (provenance):** frontmatter com `provenance` (fonte, URL,
  licença MIT, data de verificação) em todos os 208 assets; script
  `scripts/add-provenance.sh` + índice `context/provenance.md`.
- **Módulo de testes de qualidade:** `tests/quality/test-asset-quality.sh`
  cobrindo 6 dimensões (Acessibilidade, Segurança, Intuitividade, UI,
  Eficiência, Eficácia) para skills e agents.
- **Decisão:** personas jurídicas e políticas com caráter educativo/informativo
  (sem substituir OAB, legislação eleitoral do TSE respeitada); conteúdo em
  português com cabeçalhos compatíveis com os testes do kit.

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
