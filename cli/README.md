# opencode-engineering-kit CLI

Instala o **OpenCode Engineering Kit** dentro de qualquer projeto existente,
copiando skills, agents, commands, contexto e demais assets para `.opencode/`
e registrando-os no `opencode.json` do projeto.

## Instalação / Uso

```bash
# dentro do repo onde você quer instalar o kit
npx opencode-engineering-kit install
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

## Opções

| Opção          | Descrição                                                              |
|----------------|------------------------------------------------------------------------|
| `--target <d>` | Diretório do projeto alvo (padrão: diretório atual)                    |
| `--source <d>` | Usa um checkout local do kit em vez de baixar do GitHub                |
| `--repo <r>`   | Repositório GitHub do kit (padrão: `devtiagoabreu/opencode-engineering-kit`) |
| `--branch <b>` | Branch/tag do kit (padrão: `main`)                                     |
| `--only <l>`   | Subconjunto: `skills,agents,commands,context,assets` (padrão: todos)   |
| `--force`      | Sobrescreve arquivos existentes em `.opencode/`                        |
| `--dry-run`    | Mostra o que seria feito sem tocar no disco                            |
| `--verbose`    | Lista cada arquivo copiado                                             |
| `--version`    | Mostra a versão                                                        |
| `--help`       | Ajuda                                                                  |

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

## Desenvolvimento

```bash
npm test                          # roda os testes de integração
node bin/opencode-engineering-kit.js install --source ../.. --dry-run
```

## Publicação

```bash
npm login
npm publish
```
