# Repositórios oficiais e curadoria — Google Workspace / Cloud / Skills & Agents

**Research date:** 2026-11-25 · **Status:** inventário para a fila `/aprenda` — nenhum código upstream foi copiado.

Este documento responde ao pedido por repositórios oficiais do Google (e de outros vendors) com
**skills e agents** para autenticação, Google Photos, Google Docs, Google Agenda/Calendar,
Google Console/Cloud, Google Drive e Google Sheets/planilhas.

Regras adotadas (iguais às do restante do kit):

- **Adaptar ideias, contratos e checklists; não vendorear** código, docs longas, ícones, logos ou binários.
- Todo ativo novo entra como `beta` com `provenance.source`, `source_url`, `license` e `verified`.
- Projetos **não oficiais** são marcados como tal e só entram no nível de ideia, com revisão de escopo/token.
- Links negados (404) ou repositórios arquivados ficam registrados para evitar retrabalho.

Legenda de relevância: **Auth** (OAuth/ADC/IAM/service account) · **Drive** · **Sheets** · **Docs** ·
**Cal** (Agenda) · **Photos** · **Console** (Cloud/CLI/UI) · **AI** (Gemini/GenAI) · **Skill-infra**.

---

## 1. Google oficial — skills, agents, MCP e frameworks

Todos os repos abaixo são das orgs `google`, `googleapis`, `GoogleCloudPlatform`,
`googleworkspace` ou `gemini-cli-extensions` (extensões oficiais do Gemini CLI).
Licenças verificadas: Apache-2.0, salvo indicação.

| Repositório | URL | Categoria | Relevância | Notas |
|---|---|---|---|---|
| `google/skills` | https://github.com/google/skills | Skill collection | Auth, Console, AI | Inclui `google-cloud-recipe-auth` (IAM, ADC, service accounts, API keys, escopos OAuth) e plugin marketplaces para Claude Code/Codex/Antigravity. Sem skill de Workspace/Photos. |
| `google/adk-python` | https://github.com/google/adk-python | Agent framework | Auth, AI | Agent Development Kit: agents, tools, sessions, memória, eval, deploy. |
| `google/adk-js` · `adk-go` · `adk-java` · `adk-kotlin` | https://github.com/google/adk-js | Agent framework (multi-língua) | Auth, AI | Mesmo ADK em TypeScript/Go/Java/Kotlin. |
| `google/adk-web` | https://github.com/google/adk-web | Dev UI | AI | UI de depuração de agentes; v2.15.0 removeu o Visual Agent Builder interativo. |
| `google/adk-docs` | https://github.com/google/adk-docs | Documentação | Auth, AI, Console | Inclui integrações MCP e Google Cloud. |
| `google/adk-recipes` | https://github.com/google/adk-recipes | Samples / skills | Auth, AI | **Antes `google/adk-samples`**. Receitas executáveis, plugins verticais e `SKILL.md`. Marcado como “not an officially supported Google product”. |
| `google-gemini/gemini-cli` | https://github.com/google-gemini/gemini-cli | CLI / agent framework | Auth, AI, Console | MCP servers, extensions e Agent Skills; descoberta em built-ins → extensions → `~/.gemini/skills`/`~/.agents/skills` → `.gemini/skills`/`.agents/skills`. |
| `gemini-cli-extensions/workspace` | https://github.com/gemini-cli-extensions/workspace | MCP / skill collection | Auth, Docs, Sheets, Cal, Drive, AI | Extensão/MCP oficial listada por `google/mcp` para Docs, Sheets, Slides, Drive, Calendar, Gmail, Chat e People. **Sem Photos**. Aviso de prompt injection indireto; suporta login OAuth headless. |
| `google/mcp` | https://github.com/google/mcp | Índice de MCP | Auth, Console, Workspace | Índice dos MCP servers oficiais e guia de deploy; disclaimer de demo. |
| `googleapis/mcp-toolbox` | https://github.com/googleapis/mcp-toolbox | MCP + `skills/` | Auth, Console | **Antes `googleapis/genai-toolbox`**. MCP Toolbox for Databases; prebuilt tools + custom tools. SDKs oficiais: `mcp-toolbox-sdk-python`, `-sdk-js`, `-sdk-go`, `-sdk-java`. |
| `googleapis/gcloud-mcp` | https://github.com/googleapis/gcloud-mcp | MCP | Auth, Console | `gcloud`, Cloud Storage e Observability toolsets. |
| `GoogleCloudPlatform/cloud-run-mcp` | https://github.com/GoogleCloudPlatform/cloud-run-mcp | MCP | Console | Deploy/gestão no Cloud Run. |
| `GoogleCloudPlatform/gke-mcp` | https://github.com/GoogleCloudPlatform/gke-mcp | MCP | Console | Operações GKE. |
| `GoogleCloudPlatform/gemini-cloud-assist-mcp` | https://github.com/GoogleCloudPlatform/gemini-cloud-assist-mcp | MCP | Console, AI | Troubleshooting de GCP via Gemini Cloud Assist (preview). |
| `google/mcp-security` | https://github.com/google/mcp-security | MCP | Auth, Console | Security Command Center, Chronicle etc. |
| `googleapis/python-genai` · `js-genai` · `java-genai` · `go-genai` · `dotnet-genai` · `kotlin-genai` | https://github.com/googleapis/python-genai | SDK GenAI | Auth, AI | SDK unificado Gemini API + Vertex AI. **`googleapis/nodejs-genai` não existe (404)** — use `js-genai`. |
| `googleworkspace/apps-script-samples` | https://github.com/googleworkspace/apps-script-samples | Samples | Auth, Docs, Sheets, Cal, Drive, AI | Inclui `ai/`, Docs, Sheets, Calendar, Drive e Gmail. |
| `googleworkspace/add-ons-samples` | https://github.com/googleworkspace/add-ons-samples | Samples | Auth, Docs, Sheets, Cal, Drive, AI | Add-ons com tópico `ai`. **`add-on-samples` (singular) é 404**. |
| `googleworkspace/gws-genai-addon-sample` | https://github.com/googleworkspace/gws-genai-addon-sample | Sample | Auth, Drive, AI | Add-on Node.js para Gmail/Drive com Vertex AI/Gemini. |
| `googleworkspace/ml-integration-samples` | https://github.com/googleworkspace/ml-integration-samples | Sample (arquivado) | Docs, AI | Arquivado em 2025-11-18. |
| `langchain-ai/langchain-google` | https://github.com/langchain-ai/langchain-google | SDK LangChain | Auth, AI, Console | `langchain-google-genai`, `-vertexai`, `-community`. **Não é repo do Google**. |

> **Endpoints MCP hospedados (Developer Preview):** não são repositórios, mas serviços
> `https://<produto>mcp.googleapis.com/mcp/v1` para Drive, Gmail, Calendar, Chat, People,
> Docs, Sheets, Slides e Universal Search. Requerem API ativada e `roles/mcp.toolUser`.

---

## 2. Google oficial — bibliotecas/auth e clientes de API

### 2.1 Autenticação (OAuth2, ADC, service accounts)

| Repositório | URL | Licença | Status | Notas |
|---|---|---|---|---|
| `googleapis/google-auth-library-nodejs` | https://github.com/googleapis/google-auth-library-nodejs | Apache-2.0 | **Arquivado em 2025-11-20** | Código atual em `googleapis/google-cloud-node` → `core/packages/google-auth-library-nodejs`. |
| `googleapis/google-auth-library-python` | https://github.com/googleapis/google-auth-library-python | Apache-2.0 | **Arquivado em 2026-03-06** | Código atual em `googleapis/google-cloud-python/packages/google-auth`. |
| `googleapis/google-auth-library-java` | https://github.com/googleapis/google-auth-library-java | BSD-3-Clause | **Arquivado em 2026-05-12** | Código atual em `googleapis/google-cloud-java/google-auth-library-java`. |
| `googleapis/google-auth-library-python-oauthlib` | https://github.com/googleapis/google-auth-library-python-oauthlib | Apache-2.0 | **Arquivado em 2026-02-24** | Fluxo browser/installed-app; agora em `google-cloud-python/packages/google-auth-oauthlib`. |
| `googleapis/google-auth-library-php` | https://github.com/googleapis/google-auth-library-php | Apache-2.0 | Ativo | OAuth2/ADC para PHP. |
| `googleapis/google-auth-library-ruby` | https://github.com/googleapis/google-auth-library-ruby | Apache-2.0 | Ativo | Gem `googleauth`. |
| `googleapis/google-oauth-java-client` | https://github.com/googleapis/google-oauth-java-client | Apache-2.0 | Ativo | OAuth 1.0/2.0 + helpers servlet. |
| `googleapis/signet` | https://github.com/googleapis/signet | Apache-2.0 | Ativo | Implementação Ruby OAuth 1.0/2.0 usada pelos clients. |
| `googleapis/google-cloud-go` | https://github.com/googleapis/google-cloud-go | Apache-2.0 | Ativo | Auth em `cloud.google.com/go/auth`. **Não existe `google-auth-library-go` (404)**. |
| `golang/oauth2` | https://github.com/golang/oauth2 | BSD-3-Clause | Ativo | `golang.org/x/oauth2/google`; oficial do Go, mas org `golang`, não Google. |
| `googleapis/google-cloud-node` · `-python` · `-java` · `-dotnet` | https://github.com/googleapis/google-cloud-node | Apache-2.0 | Ativos | Monorepos atuais que hospedam auth + GAX por linguagem. |

### 2.2 Clientes de API (Discovery) e artefatos gerados

| Repositório | URL | Licença | Cobertura | Notas |
|---|---|---|---|---|
| `googleapis/google-api-python-client` | https://github.com/googleapis/google-api-python-client | Apache-2.0 | Docs, Sheets, Cal, Drive, Photos | Oficial, em modo manutenção. |
| `googleapis/google-api-nodejs-client` | https://github.com/googleapis/google-api-nodejs-client | Apache-2.0 | Docs, Sheets, Cal, Drive, Photos | Inclui `OAuth2Client`, API keys e JWT; em modo manutenção. |
| `googleapis/google-api-java-client` | https://github.com/googleapis/google-api-java-client | Apache-2.0 | Docs, Sheets, Cal, Drive, Photos | Core Java. |
| `googleapis/google-api-go-client` | https://github.com/googleapis/google-api-go-client | BSD-3-Clause | Docs, Sheets, Cal, Drive, Photos | Clients Go gerados. |
| `googleapis/google-api-php-client` | https://github.com/googleapis/google-api-php-client | Apache-2.0 | Docs, Sheets, Cal, Drive, Photos | Cliente PHP. |
| `googleapis/google-api-ruby-client` | https://github.com/googleapis/google-api-ruby-client | Apache-2.0 | Docs, Sheets, Cal, Drive, Photos | Cliente Ruby REST. |
| `googleapis/google-api-dotnet-client` | https://github.com/googleapis/google-api-dotnet-client | Apache-2.0 | Docs, Sheets, Cal, Drive | Inclui `Google.Apis.Auth`. |
| `googleapis/google-api-java-client-services` | https://github.com/googleapis/google-api-java-client-services | Apache-2.0 | Docs, Sheets, Cal, Drive | Artefatos Maven `com.google.apis:google-api-services-<api>` em `clients/...`. **Não há cliente `photoslibrary` gerado aqui.** **Não é repo autônomo por serviço.** |
| `googleapis/discovery-artifact-manager` | https://github.com/googleapis/discovery-artifact-manager | Apache-2.0 | Todas | Publica documentos Discovery e artefatos gerados. |
| `googleapis/googleapis` | https://github.com/googleapis/googleapis | Apache-2.0 | APIs gRPC | Definições proto — não é a fonte REST Discovery. |
| `googleapis/api-common-protos` | https://github.com/googleapis/api-common-protos | Apache-2.0 | Protos | **Arquivado em 2025-09-15**, sem sucessor. |
| `googleapis/python-api-common-protos` | https://github.com/googleapis/python-api-common-protos | Apache-2.0 | Protos | **Arquivado em 2025-03-12**; mudou para `google-cloud-python`. |
| `googleapis/gax-go` · `gax-dotnet` | https://github.com/googleapis/gax-go | BSD-3-Clause | Clients | Ativos. |
| `googleapis/gax-nodejs` · `gax-java` · `sdk-platform-java` · `gax-python` | https://github.com/googleapis/gax-nodejs | Apache/BSD | Clients | Arquivados; ver monorepos atuais. |
| `googleapis/googleapis-discovery` | https://github.com/googleapis/googleapis-discovery | Apache-2.0 | Console | **Arquivado**. |
| `google/google-api-javascript-client` | https://github.com/google/google-api-javascript-client | Apache-2.0 | Auth, Docs, Sheets, Cal, Drive | Cliente `gapi` legado; **arquivado**. |
| `googleapis/google-api-services` | https://github.com/googleapis/google-api-services | — | — | **404 / inexistente** — usar os repos por linguagem. |

> **Discovery verificado em 2026-11-25:** Drive v3, Calendar v3, Sheets v4, Docs v1,
> Photos Library v1 e Gmail v1 (`https://www.googleapis.com/discovery/v1/apis/<api>/<ver>/rest`,
> `ownerName: Google`, revisões atuais).

### 2.3 Samples oficiais por linguagem (Workspace)

`googleworkspace/apps-script-samples` · `add-ons-samples` · `python-samples` · `node-samples` ·
`java-samples` · `go-samples` · `browser-samples` — todos Apache-2.0 e ativos, cobrindo Admin SDK,
Docs, Calendar, Drive, Sheets e Gmail. `php-samples` e `dotnet-samples` estão **arquivados desde
2025-11-18**. Não existem `googleworkspace/admin-sdk-samples` nem `gmail-api-samples` (404):
esses exemplos vivem dentro dos repos por linguagem/Apps Script.

> `googleworkspace/cli` (`gws`) **não é oficial** apesar do org: o README traz disclaimer e aponta
> para o `gwscli` suportado pela Google, cujo repo GitHub não foi verificado.

### 2.4 Google Photos — ressalva crítica

Scopes amplos (`photoslibrary`, `photoslibrary.readonly`, `photoslibrary.sharing`) foram
**removidos em 2025-03-31**; métodos de compartilhamento retornam `PERMISSION_DENIED`.
A seleção da biblioteca do usuário deve usar o **Photos Picker API**; a Library API continua apenas
para mídia criada pelo app. `google/java-photoslibrary` e `google/php-photoslibrary` foram
**arquivados em 2026-04-18**. `googlesamples/google-photos` (Apache-2.0) permanece ativo.
Não há skill ou MCP server oficial do Google para Photos.

### 2.5 Cloud SDK / console

`GoogleCloudPlatform/cloud-sdk-docker`, `gsutil`, `python-docs-samples`, `nodejs-docs-samples`,
`java-docs-samples`, `golang-samples`, `php-docs-samples`, `ruby-docs-samples`, `dotnet-docs-samples`
e `devrel-demos` — oficiais e ativos (Apache-2.0). `community` está **arquivado desde 2023-08-10**
e `google-cloud-powershell` desde 2026-07-06.

**Não há repo público verificado para o core do `gcloud` CLI nem para o frontend do Cloud Console**
(`GoogleCloudPlatform/google-cloud-sdk` e `google-cloud-cli` retornam 404). Use o skill local
`google-cloud-architecture` e os MCPs oficiais de Cloud como referência.

---

## 3. Não-Google — vendors oficiais (skills, MCP, SDKs)

| Repositório | URL | Vendor | Categoria | Relevância | Notas |
|---|---|---|---|---|---|
| `anthropics/skills` | https://github.com/anthropics/skills | Anthropic | Skills | Docs, Sheets, Skill-infra | Skills `docx`, `xlsx`, `pptx`, `pdf` (Apache-2.0 nos document skills). São formatos de arquivo locais, **não** APIs do Google. |
| `anthropics/claude-agent-sdk-python` | https://github.com/anthropics/claude-agent-sdk-python | Anthropic | Agent SDK | Skill-infra | MIT; skills + MCP in-process. |
| `anthropics/claude-agent-sdk-typescript` | https://github.com/anthropics/claude-agent-sdk-typescript | Anthropic | Agent SDK | Skill-infra | **Termos comerciais**, não MIT. |
| `anthropics/claude-quickstarts` | https://github.com/anthropics/claude-quickstarts | Anthropic | Samples | Console | `computer-use-demo`, `browser-use-demo`; isolar em VM/container. |
| `anthropics/claude-plugins-official` | https://github.com/anthropics/claude-plugins-official | Anthropic | Plugins | Skill-infra | Marketplace; plugins de terceiros não verificados. |
| `openai/plugins` | https://github.com/openai/plugins | OpenAI | Plugins/skills | Drive, Docs, Sheets, Cal | `plugins/google-drive/skills/` traz `google-drive`, `google-docs`, `google-sheets`, `google-slides`, `google-drive-comments`. Auth via conectores OpenAI (`ON_INSTALL`), não credenciais próprias. `google-slides` citado no README, mas diretório 404 — não verificado. |
| `openai/skills` | https://github.com/openai/skills | OpenAI | Skills | Skill-infra | **Deprecado** — usar `openai/plugins`. |
| `openai/openai-agents-python` · `-js` | https://github.com/openai/openai-agents-python | OpenAI | Agent SDK | Skill-infra | MIT; tools/MCP/handoffs, sem tools Google nativos. |
| `microsoft/playwright-mcp` | https://github.com/microsoft/playwright-mcp | Microsoft | MCP | Console | Automação determinística de UI com accessibility snapshots — preferível a screenshot-only para o Cloud Console. |
| `browser-use/browser-use` | https://github.com/browser-use/browser-use | Comunidade | Skills + MCP/agent | Console | Já está na fila (`#3`); pinar versão exata, modo cloud envia contexto do browser. |

---

## 4. Comunidade — MCP servers (não oficiais, usar só como ideia)

| Repositório | URL | Relevância | Maturidade / cautela |
|---|---|---|---|
| `taylorwilsdon/google_workspace_mcp` | https://github.com/taylorwilsdon/google_workspace_mcp | Auth, Drive, Sheets, Docs, Cal | MIT, ~3.5k stars, ativo em 2026-11-24. OAuth 2.1 multi-user; setup de consent verification é o maior custo. |
| `MarkusPfundstein/mcp-gsuite` | https://github.com/MarkusPfundstein/mcp-gsuite | Auth, Cal | MIT, ~492 stars, parado desde abr/2025. Tokens em `.oauth.{email}.json` no cwd. |
| `karthikcsq/google-tools-mcp` | https://github.com/karthikcsq/google-tools-mcp | Auth, Drive, Sheets, Docs, Cal | ~9 stars, muito novo; auditar escopos e ferramentas de escrita. |
| `guinacio/mcp-google-workspace` | https://github.com/guinacio/mcp-google-workspace | Drive, Sheets, Docs, Cal | ~0 stars; afirmações apenas no README. |
| `bowlofarugula/googleworkspace-mcp` | https://github.com/bowlofarugula/googleworkspace-mcp | Auth, Drive, Sheets, Docs, Cal | ~0 stars; Cloud Workers com OAuth por usuário. |
| `xing5/mcp-google-sheets` | https://github.com/xing5/mcp-google-sheets | Sheets, Drive, Auth | ~1k stars, último commit mai/2026; cuidado com service-account JSON. |
| `freema/mcp-gsheets` | https://github.com/freema/mcp-gsheets | Sheets | ~105 stars; verificar escopos OAuth e storage de token. |
| `isaacphi/mcp-gdrive` | https://github.com/isaacphi/mcp-gdrive | Drive, Sheets | ~283 stars, parado desde mai/2025; derivado do exemplo gdrive removido da Anthropic. |
| `savethepolarbears/google-photos-mcp` | https://github.com/savethepolarbears/google-photos-mcp | Photos | ~60 stars; usa Picker + Library APIs (caminho mais seguro para Photos). |
| `benjamin-di/google-photos-mcp` | https://github.com/benjamin-di/google-photos-mcp | Photos | ~2 stars; usa RPCs privadas `batchexecute` com cookies — risco de ToS e sessão completa. **Não recomendar.** |

**Não verificado:** `ai-zerolab/mcp-gsuite` retorna 404 — provável confusão com `MarkusPfundstein/mcp-gsuite`.

---

## 5. Cobertura por serviço pedido

| Serviço | Fontes oficiais | Fontes não oficiais / notas |
|---|---|---|
| **Autenticação** | `google/skills` (`google-cloud-recipe-auth`), `google-auth-*` (ver §2), Google ADK, Gemini CLI, MCP Toolbox | Conectores OpenAI; OAuth 2.1 do `google_workspace_mcp`. Preferir ADC/WIF a JSON keys. |
| **Google Photos** | Somente `google-api-*` clients (Photos Library API) e `googlesamples/google-photos`. **Não há skill/MCP oficial**. | Scopes amplos removidos em 2025-03-31; usar **Picker API** para seleção da biblioteca. MCPs da comunidade são a única opção de agent; ver ressalva na §2.4. |
| **Google Docs** | `gemini-cli-extensions/workspace`, `googleworkspace/apps-script-samples`, `add-ons-samples`, clientes `google-api-*`, endpoint `docsmcp.googleapis.com` | `openai/plugins` (skill `google-docs`), MCPs da comunidade. |
| **Google Agenda / Calendar** | `gemini-cli-extensions/workspace`, Apps Script samples, clientes `google-api-*`, `calendarmcp.googleapis.com` | `openai/plugins` (connector), `mcp-gsuite`. |
| **Google Console / Cloud** | `google/skills`, `gcloud-mcp`, `cloud-run-mcp`, `gke-mcp`, `mcp-security`, `gemini-cloud-assist-mcp`, `google-cloud-architecture` (skill local) | `playwright-mcp` e `browser-use` para UI; isolar sessão. |
| **Google Drive** | `gemini-cli-extensions/workspace`, Apps Script/Add-on samples, clientes `google-api-*`, `drivemcp.googleapis.com` | Skill `google-drive` em `openai/plugins`; MCPs da comunidade. |
| **Google Sheets / planilhas** | `gemini-cli-extensions/workspace`, Apps Script samples, clientes `google-api-*`, `sheetsmcp.googleapis.com`, skill local `google-workspace-analytics` | Skill `google-sheets` em `openai/plugins`; `mcp-google-sheets`, `mcp-gsheets`. |

## 6. Sobreposição com ativos existentes do kit

Não duplicar: `google-workspace-analytics`, `google-cloud-architecture`, `authentication`,
`browser-use-automation`, `llm-multi-provider`. Os candidatos foram implementados em
2026-11-25 como ativos `beta` complementares: `google-workspace-oauth`,
`google-drive-operations`, `google-sheets-operations`, `google-calendar-operations`,
`google-docs-operations`, `google-photos-api` e `google-cloud-mcp-toolsets`, além do agente
`operador-google-workspace`. Padrões e checklists foram adaptados das fontes oficiais acima;
nenhum código/docs upstream foram copiados.

## 7. Exclusões explícitas

Nada de código, docs longas, ícones, logos, screenshots, credenciais de exemplo reais ou binários
foi trazido para o kit. Projetos arquivados/deprecados (`openai/skills`, `googleapis-discovery`,
`google-api-javascript-client`, `ml-integration-samples`, `langchain-google-el-carro-python`)
ficam apenas como referência histórica.
