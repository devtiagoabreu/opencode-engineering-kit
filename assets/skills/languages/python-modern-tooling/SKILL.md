---
provenance:
  source: "OpenCode Engineering Kit (community) — padrões adaptados de astral-sh/uv, astral-sh/ruff, PEP 517/621, OWASP, sigstore"
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: python-modern-tooling
description: "Ferramentas Python modernas com uv, pyproject.toml PEP 621, ruff, mypy/pyright, pytest e supply chain segura"
category: languages
version: 0.1.0
author: devtiagoabreu
tags: [python, uv, pyproject, pep621, ruff, lockfile, pytest, supply-chain]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Python 3.11 ou superior (ou `uv` instalando o interpretador)
  - "uv disponível no PATH (`pip install uv`)"
  - Noções de pacotes, ambientes virtuais e linha de comando
provides:
  - Fluxo determinístico com uv, lockfile e versão de Python fixada
  - Modelo de pyproject.toml PEP 621 com layout src/
  - Esteira única de lint, formatação, tipos e testes
  - Gates de segurança, SBOM e publicação OIDC sem tokens long-lived
  - Lista de anti-padrões proibidos e diretrizes de licenças
---

# Python Modern Tooling

## Overview

Esta skill define o caminho padrão para projetos Python em 2026: `uv` para
ambientes e dependências, `pyproject.toml` (PEP 621) como fonte única de
verdade, `uv.lock` para reprodutibilidade, `ruff` para lint e formatação,
`mypy`/`pyright` em modo estrito e `pytest` como esteira de testes.
Segurança e supply chain não são opcionais: varredura estática, auditoria de
CVEs, SBOM e publicação via OIDC fazem parte do fluxo, não de um estágio final.
Use esta skill ao iniciar, migrar ou revisar um projeto Python. Para padrões
de código, tipos e estilo em si, combine com `python-best-practices`.

## Prerequisites

- Python 3.11+ no `PATH` — o `uv` também instala versões ausentes
- `uv` instalado: `python -m pip install uv` (em Windows, `py -m pip install uv`)
- Git para versionar `pyproject.toml`, `uv.lock` e `.python-version`
- Consciência de que `uv.lock` é artefato versionado; `.venv/` nunca é

## Fluxo de trabalho com uv

### Instalação sem script remoto

Prefira o gerenciador de pacotes do sistema em vez de `curl | sh`: em ambientes
corporativos o pipe para o shell é bloqueado, auditado ou simplesmente
indesejado. Fixe a versão do próprio `uv` quando a organização exigir.

```bash
python -m pip install 'uv==0.8.0'   # ajuste a versão conforme a política
uv --version
```

### Comandos essenciais

```bash
uv init --lib mylib            # cria projeto com pyproject.toml e src/
cd mylib
uv python pin 3.12              # grava .python-version
uv add 'requests>=2.32,<3'      # adiciona dependência e atualiza uv.lock
uv add --dev ruff mypy pytest   # grupo de desenvolvimento
uv run python -c 'import requests; print(requests.__version__)'
uv lock                         # resolve e grava uv.lock (universal)
uv sync --frozen                # CI/produção: falha se o lock estiver desatualizado
uv sync --locked                # equivalente estrito; não reescreve o lock
```

Regras de ouro:

- `uv add` / `uv remove` para mudar dependências — nunca editar `uv.lock` à mão.
- `uv run` para executar qualquer ferramenta; ele respeita o ambiente do projeto.
- `uv sync --frozen` no CI: se `pyproject.toml` e `uv.lock` divergirem, o build falha.
- Considere `.python-version` e `uv.lock` como contrato: commite ambos.
- Use `requires-python = ">=3.11"` e teste a matriz que o projeto declara.

### Workspaces e scripts

Monorepos usam um workspace com um único lock:

```toml
# pyproject.toml na raiz
[tool.uv.workspace]
members = ["packages/*", "apps/*"]

[tool.uv.sources]
mylib = { workspace = true }
```

Scripts de uma linha podem levar metadata inline (PEP 723), dispensando
`pyproject.toml`:

```python
# /// script
# requires-python = ">=3.11"
# dependencies = ["httpx>=0.27,<1"]
# ///
import httpx

print(httpx.get("https://example.com").status_code)
```

```bash
uv run report.py    # uv cria o ambiente a partir do cabeçalho
```

## Estrutura do projeto e pyproject.toml

Layout recomendado: `src/<pacote>/`, `tests/`, `pyproject.toml`, `uv.lock`,
`.python-version`, `README.md`. O layout `src/` impede imports acidentais da
árvore de código e obriga o consumo do pacote instalado.

```toml
[build-system]
requires = ["hatchling>=1.25"]
build-backend = "hatchling.build"
# Alternativa: requires = ["uv_build>=0.8,<0.9"]; build-backend = "uv_build"

[project]
name = "mylib"
version = "0.1.0"
description = "Descrição curta do pacote"
readme = "README.md"
requires-python = ">=3.11"
dependencies = [
  "pydantic>=2.7,<3",
  "httpx>=0.27,<1",
]

[project.optional-dependencies]
dev = ["pytest>=8", "ruff>=0.6", "mypy>=1.10"]

[tool.uv]
package = true
default-groups = ["dev"]

[tool.hatch.build.targets.wheel]
packages = ["src/mylib"]

[tool.pytest.ini_options]
addopts = "-ra --strict-markers"
testpaths = ["tests"]
```

Para bibliotecas, mantenha `src/` e `py.typed` no pacote. Para aplicações, o
bloqueio de versões vive no lockfile — não duplique pins em `dependencies`
nem ressuscite `requirements.txt` gerado à mão.

## Qualidade estática

### Ruff: lint e formatação em uma esteira

```toml
[tool.ruff]
target-version = "py311"
line-length = 88
src = ["src", "tests"]

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "SIM", "ASYNC", "S"]

[tool.ruff.format]
quote-style = "double"
```

```bash
uv run ruff check .              # correções seguras: uv run ruff check --fix .
uv run ruff format --check .     # gate: falha se houver arquivo desformatado
```

`E`/`F` substituem pyflakes e pycodestyle, `I` ordena imports, `UP` aplica
sintaxe moderna, `B` pega bugs prováveis, `SIM` simplifica, `ASYNC` protege
código assíncrono e `S` (bandit) encontra problemas de segurança.

### Tipagem estrita

Escolha **um** verificador e mantenha-o no CI:

```toml
[tool.mypy]
strict = true
files = ["src", "tests"]
warn_unreachable = true
```

```bash
uv run mypy
```

```toml
# Alternativa com pyright
[tool.pyright]
typeCheckingMode = "strict"
include = ["src", "tests"]
reportMissingImports = true
```

Supressões sempre com código e justificativa curta:

```python
import xml.etree.ElementTree as ET  # noqa: S405 - parser apenas para XML interno validado

value = external_payload["x"]  # type: ignore[no-any-return] - validado por Pydantic em schemas.py
```

Nunca use `# noqa` ou `# type: ignore` sem código e sem motivo; revisão deve
entender por que a exceção é segura.

## Testes

```toml
[tool.pytest.ini_options]
addopts = "-ra --strict-markers"
testpaths = ["tests"]
markers = ["integration: requires external service"]

[tool.coverage.run]
source = ["mylib"]
branch = true

[tool.coverage.report]
fail_under = 85
```

```bash
uv run pytest
uv run pytest --cov=mylib --cov-report=term-missing --cov-fail-under=85
```

Prefira `tmp_path` a arquivos temporários globais e `parametrize` para
tabelas de casos:

```python
import pytest

@pytest.mark.parametrize("entrada,esperado", [("2", 2), ("10", 10)])
def test_conversao(entrada: str, esperado: int) -> None:
    assert int(entrada) == esperado

def test_escrita_isolada(tmp_path):
    destino = tmp_path / "saida.txt"
    destino.write_text("ok", encoding="utf-8")
    assert destino.read_text(encoding="utf-8") == "ok"
```

Property-based testing com Hypothesis é opcional e valioso para invariantes;
a biblioteca é **MPL-2.0** (copyleft por arquivo) — verifique a política de
licenças antes de redistribuir código modificado.

## Segurança e supply chain

```bash
uv run bandit -r app -ll -f json -o bandit.json
uv run pip-audit --strict -r uv.lock
trivy fs --severity HIGH,CRITICAL --exit-code 1 .
cyclonedx-py environment -o sbom.json
```

- Bandit (`-ll`) encontra padrões inseguros no AST; `# nosec Bxxx` exige motivo.
- `pip-audit --strict` falha em advisory conhecido; Trivy cobre imagem e filesystem.
- Gere SBOM CycloneDX por release e anexe ao artefato.
- Publicação: trusted publishing OIDC do PyPI, sem `PYPI_TOKEN` persistente.

```yaml
# .github/workflows/publish.yml (trecho)
permissions:
  contents: read
  id-token: write
jobs:
  publish:
    environment: pypi
    steps:
      - uses: pypa/gh-action-pypi-publish@release/v1
```

Nunca use token long-lived, segredo em log ou `curl | sh` em pipeline
corporativo. Ambiente protegido + `id-token: write` é o caminho padrão.

## CI

```yaml
name: ci
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.11", "3.12", "3.13"]
    steps:
      - uses: actions/checkout@<sha>
      - uses: astral-sh/setup-uv@<sha>
        with:
          version-file: .python-version
          enable-cache: true
      - run: uv python install ${{ matrix.python-version }}
      - run: uv sync --frozen
      - run: uv run ruff check .
      - run: uv run ruff format --check .
      - run: uv run mypy
      - run: uv run pytest
      - run: uv run pytest --cov=mylib --cov-fail-under=85
      - run: uv run bandit -r app -ll
      - run: uv run pip-audit --strict
```

Pin actions por SHA (substitua `<sha>` pelo commit revisado), não por tag
mutável. Cache do `setup-uv` reduz o tempo de install; `--frozen` garante que
o lockfile testado é o publicado.

## Async e logging

```python
import asyncio
import logging

logger = logging.getLogger(__name__)

async def carregar() -> None:
    async with asyncio.TaskGroup() as tg:
        tg.create_task(buscar_a())
        tg.create_task(buscar_b())

def main() -> None:
    asyncio.run(carregar())
```

- Use `asyncio.run()` como ponto de entrada; `TaskGroup` para fan-out estruturado.
- I/O bloqueante (requests, compressão, disco) vai para `asyncio.to_thread`.
- Nunca bloqueie o event loop com `time.sleep`, chamada síncrona longa ou CPU pesada.
- Bibliotecas adicionam `logging.NullHandler()` no logger do pacote; apps configuram handlers.
- `logging.getLogger(__name__)`, nunca `print()` para telemetria.
- Nunca logar segredos, tokens, PII ou payloads completos; use `extra` e máscara.

## Anti-padrões proibidos

| Anti-padrão | Substituto |
|---|---|
| `verify=False` em HTTP | CA configurada e hostname verificado |
| `shell=True` em subprocess | lista de argumentos, `shell=False` |
| `pickle` em filas/Celery | JSON, Protobuf ou Pydantic serializado |
| `trust_remote_code=True` | revisar e vendorizar o código, ou trocar o modelo |
| `assert` para autorização | `raise PermissionError` explícito |
| `np.load(..., allow_pickle=True)` com dados externos | `allow_pickle=False` |
| `torch.load()` sem `weights_only=True` | `torch.load(..., weights_only=True)` |
| `pip install` sem pin/hash | `uv add` + `uv.lock` + `uv sync --frozen` |
| Editar revisão Alembic já aplicada | Nova revisão com `alembic revision` |
| `requests` síncrono dentro de `async def` | `httpx.AsyncClient` ou `to_thread` |

Também proibido: `@app.on_event` legado em FastAPI, `OAuth2PasswordBearer`
tratado como validação real de token e segredos literais no código.

## Licenças e atribuição

Adapte ideias e checklists; **não copie texto integral de upstream**.

| Material | Licença | Obrigação prática |
|---|---|---|
| uv, ruff, mypy, pyright, pytest | Apache-2.0 / MIT | Manter aviso de copyright ao redistribuir |
| Bandit, pip-audit, Trivy, sigstore | Apache-2.0 | Atribuição; revisar avisos ao vendorizar |
| Hypothesis | MPL-2.0 | Copyleft por arquivo: não incorporar código modificado sem avaliar |
| OWASP CheatSheets, pypa advisory DB | CC-BY-SA / CC-BY | Atribuir e respeitar ShareAlike se adaptar texto |
| Documentação PEP/Python | PSF/CC conforme a página | Cite a fonte; não reproduzir em bloco |

Verifique a licença de cada dependência antes de distribuir; licenças mistas
exigem revisão jurídica, não suposição.

## References

- [uv documentation](https://docs.astral.sh/uv/)
- [ruff documentation](https://docs.astral.sh/ruff/)
- [PEP 621 — Storing project metadata in pyproject.toml](https://peps.python.org/pep-0621/)
- [pyproject.toml specification](https://packaging.python.org/en/latest/specifications/pyproject-toml/)
- [mypy strict mode](https://mypy.readthedocs.io/en/stable/command_line.html)
- [pytest documentation](https://docs.pytest.org/)
- [pip-audit](https://github.com/pypa/pip-audit)
- [sigstore Python](https://github.com/sigstore/sigstore-python)
- [OWASP Python Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Python_Security_Cheat_Sheet.html)
