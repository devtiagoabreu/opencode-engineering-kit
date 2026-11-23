---
maturity: beta
name: aprenda
description: Continue learning from the canonical repository queue and adapt new patterns into provenance-tagged beta assets.
version: 0.1.0
author: devtiagoabreu
tags: [learning, provenance, curation, repositories]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
usage: /aprenda
---

# /aprenda

## Usage

```text
aprenda
/aprenda
```

## Description

Runs the continuous-learning protocol in [docs/APRENDA_REPOSITORIOS.md](../../docs/APRENDA_REPOSITORIOS.md). Read that file first, then review every listed repository for changes since its `Última verificação`. Adapt only ideas, workflows and checklists into new or updated `beta` assets with explicit provenance. Do not vendor upstream source code, long docs, icons or logs.

## Steps

1. Open `docs/APRENDA_REPOSITORIOS.md` and copy its `Última verificação` date.
2. Check all 20 repositories in the table, including license changes and new agent/skill files.
3. Also review the `Temas prioritários` section: conciliação de extrato, DRE, FP&A, analista financeiro, controladoria e evidências de fechamento.
4. Skip patterns already covered by existing kit assets; extend them instead of duplicating.
5. Add or update `beta` skills/templates/commands with `provenance.source`, `source_url`, `license` and `verified`.
6. Keep restrictive-license repositories at idea level only.
7. Update mapping docs, provenance, READMEs and `CHANGELOG.md`.
8. Regenerate indexes, lockfile, compatibility matrix and manifest.
9. Run the strict validator, UTF-8 check, README count check and `npm test` in `cli/`.
10. Report the diff and ask for the name of the 12th platform repository, which was mentioned but never provided.

## Notes

- This command is a curation trigger, not a scraper: prefer official GitHub docs and release notes.
- A repository with no changes still gets a row in the report with the verified date.
- Never promote a new asset to `stable` in this command; curation is a separate review.
