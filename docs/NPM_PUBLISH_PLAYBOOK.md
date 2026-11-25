# Playbook — publicar a CLI no npm

Registro da solução usada em 2026-11-25 para publicar `opencode-engineering-kit`.
Objetivo: a próxima sessão conseguir publicar uma nova versão sem redescobrir o fluxo.

## Fatos que importam

- O pacote npm **não é a raiz do repo**. Fica em `cli/` (`package.json`, `bin/`, `src/`).
- Nome: `opencode-engineering-kit` · conta maintainer: `areareversacode` · licença MIT.
- O tarball é pequeno (~20 kB, 13 arquivos): só `bin/` + `src/` + README + LICENSE.
  Os ativos (`assets/`, `core/`, `context/`) **não** vão no npm: a CLI baixa o
  tarball do `main` do GitHub na hora do `install` (ou usa `--source`).
- Antes da publicação real, o nome pode estar ocupado por um placeholder
  `0.0.0-stage` e por uma versão real **staged** aguardando aprovação.
  Isso é normal — verifique com `npm stage list`.
- **Regra de ouro:** `cli/` e o tarball publicado devem ser **sempre idênticos**.
  Toda mudança em `cli/package.json`, `cli/bin/` ou `cli/src/` exige bump de
  versão + publish + verificação. Mudanças em `assets/`, `core/`, `context/` e
  `docs/` **não** exigem novo publish: a CLI instalada via `npx` baixa esses
  arquivos do `main` do GitHub na hora do `install`.

## Pré-publicação

```bash
cd cli
npm ci          # ou npm test direto; o projeto não tem dependências
npm test        # 26 testes de integração
npm pack --dry-run
```

## Autenticação sem vazar token

Nunca coloque o token em arquivo versionado nem em comando que será compartilhado.
Use um `.npmrc` temporário com interpolação e uma variável de ambiente:

```powershell
$tmp = Join-Path $env:LOCALAPPDATA 'Temp\opencode\oek-npmrc'
Set-Content $tmp '//registry.npmjs.org/:_authToken=${NPM_TOKEN}'
$env:NPM_TOKEN = '<token>'   # fornecido pelo usuário na hora
npm whoami --userconfig=$tmp --registry=https://registry.npmjs.org
```

Se o token apareceu em chat/log, revogue-o e gere outro.

## O problema: 2FA em shell não interativo

Com um token comum, `npm publish` falha assim:

```
403 ... Two-factor authentication or granular access token with bypass 2fa enabled is required
```

Mesmo com token granular, o registry pode exigir OTP:

```
npm error code EOTP
npm error This operation requires a one-time password.
```

O npm **só oferece o fluxo de browser quando `stdin`/`stdout` são TTY**. Em shell
automatizado ele imprime a URL com `authId` mascado (`***`) e aborta no primeiro
`404` do endpoint `/-/v1/done`, antes do usuário abrir a página.

## A solução: TTY falso + `--browser=false`

Crie um wrapper temporário (fora do repo) que marca os streams como TTY e pede
ao npm para **não** tentar abrir o browser sozinho:

```js
// oek-npm-webauth.cjs
process.stdin.isTTY = true;
process.stdout.isTTY = true;
process.env.NPM_CONFIG_BROWSER = 'false';

process.argv = [
  process.execPath,
  'C:\\Program Files\\nodejs\\node_modules\\npm\\bin\\npm-cli.js',
  'publish', // ou: stage approve <stage-id>
  '--ignore-scripts',
  '--access', 'public',
  '--registry=https://registry.npmjs.org',
  '--userconfig=C:\\Users\\<user>\\AppData\\Local\\Temp\\opencode\\oek-npmrc',
];

require('C:\\Program Files\\nodejs\\node_modules\\npm\\bin\\npm-cli.js');
```

Rode em background redirecionando a saída para um arquivo:

```powershell
node oek-npm-webauth.cjs *> oek-publish.log
```

A saída traz a URL **sem máscara**:

```
Authenticate your account at:
https://www.npmjs.com/auth/cli/<uuid>
```

Passe essa URL ao usuário. Ele faz login + 2FA no browser. O npm fica fazendo
polling em `https://registry.npmjs.org/-/v1/done?authId=<uuid>` e conclui o
comando automaticamente quando a autenticação é aprovada.

> `--ignore-scripts` evita rodar `prepublishOnly` (testes) de novo na tentativa
> de autenticação; rode os testes uma vez antes. Isso também faz a URL aparecer
> em segundos, em vez de depois de ~12 s.

## Atenção: publicação staged

Se o registry responder:

```
409 Conflict - Cannot publish over previously staged version "0.1.0"
```

**não** tente `npm publish` de novo. A versão já está no registry, só aguardando
aprovação. Liste e aprove:

```bash
npm stage list opencode-engineering-kit --userconfig=$tmp
# id: <uuid> · version: 0.1.0 · status: staged

npm stage approve <uuid> --userconfig=$tmp
```

`npm stage approve` também exige 2FA: use o mesmo wrapper TTY falso, trocando
`publish` por `stage approve <uuid>` no `process.argv`. Ao final, a versão passa
a `latest` no registry.

Alternativa se o usuário tiver app de autenticação: `npm publish --otp=XXXXXX`
ou `npm stage approve <uuid> --otp=XXXXXX` — mas exige colar o código, o que é
menos seguro e mais difícil de sincronizar.

## Alternativa sem wrapper (usuário no terminal)

Se não quiser automatizar, o usuário roda no próprio terminal interativo:

```bash
cd cli
npm login
npm publish --access public
# se houver stage pendente: npm stage approve <uuid>
```

## Verificação depois de publicar

```bash
npm view opencode-engineering-kit version     # deve ser a versão nova
npm view opencode-engineering-kit bin         # deve mostrar bin/opencode-engineering-kit.js
npx opencode-engineering-kit --version
npx opencode-engineering-kit install --dry-run --target /projeto/existente

# compara o tarball publicado com o cli/ local, arquivo por arquivo (SHA-256)
python scripts/check_npm_sync.py --root .
```

O `check_npm_sync.py` falha se algum arquivo do tarball estiver diferente,
faltando ou sobrando em relação ao `cli/`. Use-o sempre depois de publicar e
antes de dizer que "cli e npx estão iguais".

Também atualize os textos que dizem "pacote ainda não publicado":
`README.md`, `README_EN.md` e `docs/SESSION_HANDOFF.md`.

## Histórico de 2026-11-25

1. Commit `d351f7c` preparou `cli/package.json`, lockfile e `.github/workflows/release.yml`
   (job `publish-npm` com `NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}`).
2. Placeholder `0.0.0-stage` publicado pela conta `areareversacode`.
3. Versão `0.1.0` enviada como stage (`a4699eb5-8a41-409a-8df1-1e964a481f7f`),
   shasum `a51fc6ae34f377d9dd61261db071e3f16f0f09e1` — idêntico ao `npm pack` atual.
4. `npm publish` direto falhou com 403/EOTP; resolvido com wrapper TTY falso.
5. `npm stage approve a4699eb5-8a41-409a-8df1-1e964a481f7f` com o mesmo fluxo de browser — versão publicada com sucesso. Validação: `latest = 0.1.0`, `bin` presente, `npx --yes opencode-engineering-kit --version` → `0.1.0`.
