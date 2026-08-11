---
provenance:
  source: OpenCode Engineering Kit (community)
  url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-08-08
name: repo-to-llm
description: Convert any Git repository into clean, token-efficient Markdown (with llms.txt) ready for LLM context, RAG and code review
category: tools
version: 0.1.0
author: OpenCode Community
tags: [llm, markdown, repository, tokens, llms.txt, gittomd, git2md, context]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Git 2.0+ and network access to the target repository
  - One of: gittomd, git2md or repo2txt (see Instructions)
provides:
  - Single-file Markdown snapshot of a repository
  - llms.txt index for LLM context
  - Filtered source-only output (no noise, no binaries)
---

# Repo to LLM Markdown

## Overview

AI assistants cannot browse a repository directly: they read text inside a
context window. This skill converts any Git repository (or local folder) into a
single, structured Markdown document that fits into a prompt — with the
directory tree, file path headers and only the source files that matter. This
is the core pattern of "context engineering": give the model the full picture
without wasting tokens on `node_modules`, lock files and build artifacts.

It covers three community tools:

- **[gittomd](https://gittomd.com)** — web tool that converts a public GitHub
  repo into one Markdown file.
- **[git2md](https://github.com/sliday/git2md)** — local CLI that also emits the
  `llms.txt` format for LLM context.
- **[repo2txt](https://repo2txt.simplebasedomain.com)** — browser-based picker
  with private-repo support via personal access token.

## Prerequisites

- Git 2.0+ and Bash 4.0+ (for the local options)
- Node.js 16+ if using `git2md` via npx
- A target repository (local path or public GitHub URL)

## Usage Instructions

### 1. Quickest option: gittomd (web)

Replace the repository URL with the gittomd equivalent in your browser, or use
the GitHub-hosted endpoint. Download the generated Markdown file.

### 2. Local CLI: git2md

```bash
# Run from anywhere, against a local or remote repository
npx git2md /path/to/repository --output ./llm-context.md

# Emit the llms.txt format (index of all files)
npx git2md /path/to/repository --format llms.txt

# Filter by extensions and exclude noise
npx git2md /path/to/repository \
  --extensions .py,.md,.yaml \
  --exclude tests,build,dist \
  --output ./llm-context.md
```

### 3. Browser picker: repo2txt

Paste the GitHub URL, select the files you want and download a plain-text file
ready to paste into any LLM. Supports private repositories with a personal
access token.

### 4. Best practices for token economy

- **Filter aggressively**: exclude tests, generated code, lock files and
  build artifacts. A medium frontend repo usually fits a 100K–200K window after
  filtering.
- **Generate once, reuse**: package the context once per sprint and reuse it for
  code review, docs, onboarding and architecture discussions.
- **Scan for secrets first**: before feeding any snapshot to a model, run the
  secret scan from this kit (`./core/security/secret-scan.sh`) or a tool like
  truffleHog.
- **Check the output size**: conversion tools report total tokens/bytes; match
  the size to your model's context window.

## Examples

### Example 1: Package a local codebase for a code review

```bash
cd /path/to/your/project
npx git2md . --extensions .ts,.tsx,.json --exclude node_modules,dist,tests \
  --output ./codebase.md
wc -c ./codebase.md
```

### Example 2: Generate an llms.txt index for a project

```bash
npx git2md /path/to/your/project --format llms.txt --output ./llms.txt
```

### Example 3: Combine with this kit's secret scan

```bash
npx git2md . --output ./context.md
./core/security/secret-scan.sh ./context.md
```

## References

- [gittomd](https://gittomd.com)
- [git2md on GitHub](https://github.com/sliday/git2md)
- [repo2txt](https://repo2txt.simplebasedomain.com)
- [Repomix (advanced codebase packager)](https://github.com/yamadashy/repomix)

## Notes

- gittomd is free for public repositories; private repos need a token.
- git2md runs fully local — safe for sensitive codebases.
- Keep the generated files out of git (`*.context.md`, `llms.txt` if unwanted).
