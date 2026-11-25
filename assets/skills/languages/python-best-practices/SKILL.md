---
provenance:
  source: OpenCode Engineering Kit (community)
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: stable
name: python-best-practices
description: Python best practices covering typing, packaging, virtual environments, and code style
category: languages
version: 0.1.0
author: devtiagoabreu
tags: [python, typing, packaging, venv, pep8, style]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Python 3.9 or newer
  - pip and venv available
  - Basic familiarity with Python syntax
provides:
  - Guidelines for static typing with PEP 484 annotations
  - Workflow for virtual environments and dependency pinning
  - Project packaging setup with pyproject.toml
  - Code style and linting conventions (PEP 8, ruff, black)
---

# Python Best Practices

## Overview

This skill provides a practical guide to writing clean, maintainable, and
well-packaged Python code. It covers static typing with type annotations,
isolated dependency management with virtual environments, modern packaging
through `pyproject.toml`, and consistent code style following PEP 8. Following
these practices makes code easier to read, safer to refactor, and simpler to
ship as a reusable library. The guidance applies to libraries, CLI tools, and
application code alike.

## Prerequisites

- Python 3.9+ installed and available on `PATH`
- `python3 -m pip --version` returns a working pip
- Git for versioning your project (recommended)

## Usage Instructions

### Step 1: Initialize the Project with uv

Use `uv` as the default environment and dependency manager. It creates and
manages the `.venv` for you and keeps `pyproject.toml` as the single source
of truth. Install it with `python -m pip install uv` (avoid `curl | sh` in
corporate environments).

```bash
uv init --lib myproject && cd myproject
uv python pin 3.12              # writes .python-version
uv add 'requests>=2.32,<3'      # updates pyproject.toml and uv.lock
uv add --dev ruff mypy pytest
uv run python -c 'import requests; print(requests.__version__)'
```

Add `.venv/` to `.gitignore`; commit `pyproject.toml`, `uv.lock` and
`.python-version`. On Windows use `py -m pip install uv` when needed.

Legacy alternative (still valid for existing projects):

```bash
python3 -m venv .venv
source .venv/bin/activate       # Windows: .venv\Scripts\activate
python -m pip install --upgrade pip
```

### Step 2: Lock Dependencies for Reproducibility

`uv` resolves the full dependency graph into a universal `uv.lock`. Use
`uv sync --frozen` in CI so a stale lock fails the build instead of silently
resolving new versions.

```bash
uv lock                         # resolve and write uv.lock
uv sync --frozen                # exact environment from the lockfile
uv run pytest
```

Change dependencies with `uv add` / `uv remove`; never hand-edit `uv.lock`.
Legacy: `pip install requests==2.32.0` followed by
`pip freeze > requirements.txt`. That flow remains acceptable for
pre-existing applications, but it is no longer the recommended default.

### Step 3: Add Type Annotations

Annotate function signatures and data structures to make intent explicit:

```python
from typing import Any, Iterable

def average(numbers: Iterable[float]) -> float:
    """Return the arithmetic mean of a non-empty iterable."""
    values = list(numbers)
    if not values:
        raise ValueError("cannot average an empty sequence")
    return sum(values) / len(values)

def handle_event(payload: dict[str, Any]) -> None:
    ...
```

Prefer built-in generics (`list[str]`, `dict[str, int]`) on Python 3.9+ and
reserve `typing.List` / `typing.Dict` for legacy codebases.

### Step 4: Configure Linting and Formatting

Use `ruff` for both linting and formatting — one tool, one configuration:

```bash
uv run ruff check .
uv run ruff format --check .
```

Add a `pyproject.toml` section to keep settings shared across the team:

```toml
[tool.ruff]
target-version = "py311"
line-length = 88

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "SIM", "ASYNC", "S"]
```

`ruff format --check` is the CI gate; `ruff check --fix` applies safe fixes.
`black` remains a legacy formatter for projects not yet migrated — do not
introduce it in new projects. Suppressions must carry a code and a reason,
e.g. `# noqa: S603 - fixed argument list, no shell`.

### Step 5: Verify Types with mypy or pyright

Run a strict type checker before changes reach production. Pick one checker
and keep it in CI:

```bash
uv add --dev mypy
uv run mypy                     # reads [tool.mypy] from pyproject.toml
```

```toml
[tool.mypy]
strict = true
files = ["src", "tests"]
```

```toml
# Alternative: [tool.pyright] typeCheckingMode = "strict"
```

Keep `py.typed` inside the package directory so downstream users can rely on
your type hints. Use `# type: ignore[code]` with a short justification rather
than blanket ignores.

### Step 6: Package with pyproject.toml (PEP 621)

Use a `src/` layout with a PEP 517 build backend (`hatchling` or `uv_build`):

```toml
[build-system]
requires = ["hatchling>=1.25"]
build-backend = "hatchling.build"
# Or: requires = ["uv_build>=0.8,<0.9"]; build-backend = "uv_build"

[project]
name = "myproject"
version = "0.1.0"
description = "A short summary of the project"
readme = "README.md"
requires-python = ">=3.11"
dependencies = ["requests>=2.32,<3"]

[project.optional-dependencies]
dev = ["ruff", "mypy", "pytest"]

[tool.uv]
package = true

[tool.hatch.build.targets.wheel]
packages = ["src/myproject"]

[tool.pytest.ini_options]
addopts = "-ra --strict-markers"
```

Sync the project and its dev group from the lockfile:

```bash
uv sync --frozen                # CI and production
uv run pytest
```

For a full modern-tooling checklist — workspaces, inline scripts, coverage,
Bandit/pip-audit/SBOM and OIDC publishing — see `python-modern-tooling`.

## Examples

### Example 1: A Typed Dataclass

```python
from dataclasses import dataclass, field

@dataclass(slots=True)
class User:
    """A user entity with validation helpers."""
    id: int
    name: str
    email: str
    roles: list[str] = field(default_factory=list)

    @property
    def is_admin(self) -> bool:
        return "admin" in self.roles
```

### Example 2: Guarded Library Entry Point

```python
# myproject/cli.py
import argparse

def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(prog="myproject")
    parser.add_argument("name", help="name to greet")
    args = parser.parse_args(argv)
    print(f"Hello, {args.name}!")

if __name__ == "__main__":
    main()
```

## References

- [Python PEP 8 Style Guide](https://peps.python.org/pep-0008/)
- [PEP 484 Type Hints](https://peps.python.org/pep-0484/)
- [Python Packaging User Guide](https://packaging.python.org/en/latest/)
- [pyproject.toml specification (PEP 621)](https://peps.python.org/pep-0621/)
- [uv documentation](https://docs.astral.sh/uv/)
- [ruff documentation](https://docs.astral.sh/ruff/)
- [mypy documentation](https://mypy.readthedocs.io/)
- [The Hitchhiker's Guide to Python](https://docs.python-guide.org/)

## Notes

- Commit `uv.lock` and `.python-version`; keep `.venv` out of version control.
- Legacy `requirements.txt` is fine for older apps, but prefer `uv lock` + `uv sync --frozen`.
- Add `.venv`, `__pycache__`, and `*.egg-info/` to `.gitignore`.
- Run `uv run ruff check . && uv run ruff format --check . && uv run mypy` in CI.
- Use `enum` for fixed value sets instead of string constants.
- Favor `dataclasses` and `pydantic` over hand-written `__init__` methods.
- On Windows use `py -m pip install uv` when `python3` is unavailable.
- Keep modules small; a file over 300 lines usually deserves splitting.
