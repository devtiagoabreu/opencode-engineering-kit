# Reference Capability Integration

**Date:** 2026-11-23  
**Status:** Active; all imported capabilities are `beta` until curated.

This document records what was learned from external reference repositories and where the adapted capabilities now live in this kit. The clones under `references/` are local research material and are gitignored; no source code, long reference text, icons or diagrams were vendored.

## Rule of adaptation

Ideas, workflows and checklists were re-expressed in this kit's asset format. Each new asset declares the upstream source, canonical URL and upstream license in its frontmatter. Where an upstream license is incompatible with a straight copy, only idea-level patterns were used and the provenance says so explicitly.

## Mapping

| Upstream | Upstream license | Kit assets | What was adapted |
|---|---|---|---|
| [Awesome Harness Engineering](https://github.com/ai-boost/awesome-harness-engineering) | CC0-1.0 | `harness-engineering-patterns`, `harness-review`, `harness-checklist` | Tool permission classes, context delivery modes, verification gates, eval ladder, bounded orchestration, deletion review. |
| [OpenViking](https://github.com/volcengine/OpenViking) | AGPL-3.0 (ideas only) | `context-filesystem-memory` | Stable context addresses, three summary levels, scoped retrieval order, durable rules, session commit, hygiene and access boundaries. No upstream code or text copied. |
| [Browser Use](https://github.com/browser-use/browser-use) | MIT | `browser-use-automation` | Fetch-first triage, tab and daemon lifecycle, accessibility-tree interaction, sensitive-input handling, QA scorecard, bounded REPL loop. |
| [agentmemory](https://github.com/rohitg00/agentmemory) | Apache-2.0 | `memory-discipline`, `agent-session-handoff` | Four memory tiers, recall-before-work ritual, write-at-resolution, provenance and supersession, privacy defaults, hook capture, multi-agent leases, eval receipts, handoff template. |
| [Scientific Agent Skills](https://github.com/K-Dense-AI/scientific-agent-skills) | MIT | `scientific-data-retrieval`, `scientific-retrieval-ledger` | Retrieval contract, authoritative-source selection, bounded calls and count reconciliation, untrusted payload handling, provenance ledger, scientific design/power/units gates. |
| [Diagram Design](https://github.com/cathrynlavery/diagram-design) | MIT | `diagram-design`, `diagram` | Semantic-pattern-first type selection, style-token gate, connector rules, layout budget, accessible SVG contract, render-and-look loop, extract-then-redraw import workflow. |

## What was intentionally not copied

- Full 177-skill scientific catalog and its environment tooling; one reproducible retrieval workflow was adapted instead.
- The full 52-type diagram gallery, icon bundles and verifier scripts; the selection logic, drafting rules and a minimal template were adapted instead.
- Browser Use cloud APIs, daemon implementation and site-specific domain skills; only the operating discipline is documented.
- OpenViking runtime, storage engine and plugin code; only the portable context model is documented.
- agentmemory server, viewer and benchmark suites; only agent-facing rituals and a handoff format were adapted.
- Awesome list links that were not directly relevant to the harness patterns above.

## Maturity and curation

All new assets are `beta`: they are usable but not yet in `profiles/core.json`. Promotion to `stable` follows [docs/QUALITY_POLICY.md](./QUALITY_POLICY.md) and requires profile curation plus the normal quality gates.

## Verification

After integration, the usual gates apply:

```bash
python scripts/validate_assets.py --root . --check-manifest --check-links --strict-policy
python scripts/sync_readme_counts.py --root . --check
```

The provenance rows for new skills are also listed in `context/provenance.md`.
