# opencode-engineering-kit CLI

Instala e gerencia o **OpenCode Engineering Kit** em projetos OpenCode, copiando skills, agents, commands, contexto e assets para `.opencode/` e registrando-os no `opencode.json`.

## Quick start

```bash
# dentro do repo onde você quer instalar o kit
npx opencode-engineering-kit install
npx opencode-engineering-kit status
npx opencode-engineering-kit list --type skills
```

### Exemplo

```bash
cd ~/code/meu-app
npx opencode-engineering-kit install
```

Isso baixa o kit do GitHub, copia para `.opencode/` e cria/atualiza `opencode.json`:

```
meu-app/
├── .opencode/
│   ├── skills/        # assets/skills (todas as categorias)
│   ├── agents/        # assets/agents (nome achatado: backend-developer.md)
│   ├── commands/      # assets/commands
│   ├── context/       # context/*.md (registrados em instructions)
│   └── assets/        # prompts, playbooks, recipes, templates (referência)
└── opencode.json      # skills.paths + instructions (mesclado com o que existia)
```

Depois reinicie o OpenCode para a nova configuração ser carregada.

## Comandos

| Comando | Descrição |
|---------|-----------|
| `install` | Instala o kit no projeto ou globalmente (`--global`) |
| `status` | Mostra instalações e se o kit está ativo |
| `start` / `stop` | Reativa/desativa o wiring no `opencode.json` sem apagar arquivos |
| `list` | Lista assets (`--type skills|agents|prompts|templates`, `--json`) |
| `search <q>` | Busca por nome/descrição (`--json`) |
| `doctor` | Verifica integridade do checkout e wiring instalado (`--target/--global`, `--fast`, `--json`) |
| `upgrade` | Reinstala com `--force` (aceita opções de `install`) |
| `export` | Exporta pacote (`--format claude`, `--out <dir>`) |

## Opções do `install`

| Opção | Descrição |
|-------|-----------|
| `--target <d>` | Diretório do projeto alvo (padrão: diretório atual) |
| `--global` | Instala no config global do OpenCode |
| `--source <d>` | Usa um checkout local do kit em vez de baixar do GitHub |
| `--repo <r>` | Repositório GitHub do kit (padrão: `devtiagoabreu/opencode-engineering-kit`) |
| `--branch <b>` | Branch/tag do kit (padrão: `main`) |
| `--profile <nome>` | Perfil curado: `core`, `backend`, `frontend`, `devops`, `ai`, `brasil`, `full` |
| `--only <l>` | Subconjunto: `skills,agents,commands,context,assets` (padrão: todos) |
| `--force` | Sobrescreve arquivos existentes em `.opencode/` |
| `--dry-run` | Mostra o que seria feito sem tocar no disco |
| `--verbose` | Lista cada arquivo copiado |

## Perfis

Perfis reduzem ruído de contexto e dão um ponto de partida curado. Use `--profile core` para setup mínimo; `full` instala tudo.

| Perfil | Skills | Agents | Commands | Context |
|--------|--------|--------|----------|---------|
| `core` | 20 skills explícitas + categorias code-review/documentation/git/projects/quality | 7 agentes core | `review,test,lint` | 7 arquivos base |
| `backend` | categorias backend/database/testing/security/devops/architecture | `*` | `*` | `*` |
| `frontend` | categorias frontend/design/testing/security/performance | `*` | `*` | `*` |
| `devops` | categorias devops/cloud/security/testing/git | `*` | `*` | `*` |
| `ai` | categorias ai/analytics/vision/tools/security | `*` | `*` | `*` |
| `brasil` | categorias de domínio Brasil | `*` | `*` | `*` |
| `full` | `*` | `*` | `*` | `*` |

Notas:
- `*` no perfil significa “todos daquele grupo”.
- Seleção de perfil é aplicada durante `install`; `doctor` detecta drift dos arquivos rastreados no manifest.

## Modo offline / desenvolvimento

Use um checkout local para não depender da rede:

```bash
npx opencode-engineering-kit install --source /caminho/para/opencode-engineering-kit
```

## Como funciona

1. Baixa o tarball do kit (`https://github.com/<repo>/archive/refs/heads/<branch>.tar.gz`)
   e extrai em um diretório temporário (usa o `tar` do sistema).
2. Mapeia os assets para `.opencode/`:
   - `assets/skills/**` → `.opencode/skills/` (o OpenCode varre `**/SKILL.md` recursivamente)
   - `assets/agents/<categoria>/<nome>/<nome>.md` → `.opencode/agents/<nome>.md` (achatado)
   - `assets/commands/*.md` → `.opencode/commands/`
   - `context/*.md` → `.opencode/context/` (referenciados em `instructions`)
   - `assets/{prompts,playbooks,recipes,templates}` → `.opencode/assets/`
3. Mescla (sem apagar) o `opencode.json` existente: adiciona `.opencode/skills`
   em `skills.paths` e os arquivos de contexto em `instructions`.

## Requisitos

- Node.js 18+ (para `fetch`)
- `tar` disponível no PATH (Linux/macOS já têm; Windows 10+ e Git for Windows também)

## Confiança

- Use `--dry-run` para auditar mudanças antes de aplicar.
- Use `--source <checkout-local>` para instalar a partir de código inspecionado.
- `doctor` valida schema, allowlist, índices, lockfile, skill scan e vault (e testes com `--fast` desativado).
- `stop/start` só altera o wiring do `opencode.json`.

## Desenvolvimento

```bash
npm test                          # roda os testes de integração
node bin/opencode-engineering-kit.js install --source ../.. --dry-run
node bin/opencode-engineering-kit.js doctor --dir ../.. --fast
node bin/opencode-engineering-kit.js doctor --dir ../.. --target /path/to/project --fast
```

## Publicação

```bash
npm login
npm publish
```
