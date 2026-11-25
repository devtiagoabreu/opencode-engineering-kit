# Reference Capability Integration

**Date:** 2026-11-25  
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
| [UX/UI Agent Skills](https://github.com/plugin87/ux-ui-agent-skills) | MIT | `a11y-audit`, `ui-visual-craft`, `design-review-critic`, `design-tokens-pipeline` | WCAG 2.2 gates, DTCG tokens, anti-slop doctrine, blind design critic, measured contrast in both themes |
| [Vercel Plugin](https://github.com/vercel/vercel-plugin) | Apache-2.0 | `vercel-runtime-and-cache`, `vercel-deployment` | Official env/deploy/functions/cache skills; preview→promote→rollback; telemetry opt-out |
| [uv + ruff](https://github.com/astral-sh/uv) | Apache-2.0/MIT + MIT | `python-modern-tooling`, `python-best-practices` | Deterministic lockfile, PEP 621, unified lint/format, strict typing, supply-chain gates |
| [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/) | CC-BY-SA-4.0 (attribution required) | `nextjs-web-security` | XSS/CSRF prevention, Next.js security, webhooks, secrets management |
| [C-SSRS / SAFE-T / Stanley-Brown Safety Plan](https://cssrs.columbia.edu/) | domínio público / uso educacional | `mental-health-crisis-protocol` | Estratificação de risco, checagem direta e plano de segurança em quatro níveis, com CVV 188/SAMU 192 |
| [WHO mhGAP](https://www.who.int/publications/i/item/9789241549790) | CC BY-NC-SA 3.0 IGO (referência) | `mental-health-crisis-protocol`, `evidence-based-scales` | Gate de crise e interpretação conservadora de rastreios; nenhum texto copiado |
| [rhavekost/clinical-toolkit](https://github.com/rhavekost/clinical-toolkit) | NOASSERTION (ideias apenas) | `evidence-based-scales`, `mental-health-crisis-protocol` | Faixas PHQ-9/GAD-7/WHO-5/PCL-5/C-SSRS e gatilhos de encaminhamento |
| [ironyjk/counsel-frameworks](https://github.com/ironyjk/counsel-frameworks) | MIT | `counseling-frameworks` | Roteador de 14 frameworks, pipelines sequenciais e matriz de anti-padrões |
| [FreedomIntelligence/OpenClaw-Medical-Skills](https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills) | não declarada (ideias apenas) | `adhd-executive-function`, `mental-health-crisis-protocol` | Regra 3x, sistema das 3 coisas, externalização e detecção de crise |
| [robcushard-nth/autism_skills_suite](https://github.com/robcushard-nth/autism_skills_suite) | MIT | `neurodiversity-support` | Checklist de revisão por adultos autistas e clínicos antes de publicar |
| [tuanductran/hr-skills](https://github.com/tuanductran/hr-skills) | MIT | `people-governance-psychology` | Router-first, gate de jurisdição, cobertura por tarefa e GOVERNANCE com `[Proposed]` |
| [polar-bear-org/claude-skills](https://github.com/polar-bear-org/claude-skills) | custom (sem revenda; ideias apenas) | `people-governance-psychology` | ISO 30414 com n≥5, checagem por subtração, linha "o que não pode dizer", concern log em duas passagens |
| [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) | MIT | `psicologo-organizacional` | Diagnosticar condições, não caracteres; sequência confiança → conflito → desempenho |
| [Edmondson (1999) / Project Aristotle / Deci & Ryan / JD-R](https://doi.org/10.2307/2666999) | acadêmico / CC conforme cada fonte | `people-governance-psychology`, `psicologo-organizacional` | Segurança psicológica, autonomia/competência/vínculo, demandas e recursos, AMO |
| [WHO mental health at work / NICE NG212 / ISO 30414 / SHRM / EU AI Act / NIST AI RMF](https://www.nice.org.uk/guidance/ng212) | várias (normas pagas: referenciar) | `people-governance-psychology`, `psicologo-organizacional` | Intervenções organizacionais, ética de dados de pessoas e IA de emprego como alto risco |

## What was intentionally not copied

- Full 177-skill scientific catalog and its environment tooling; one reproducible retrieval workflow was adapted instead.
- The full 52-type diagram gallery, icon bundles and verifier scripts; the selection logic, drafting rules and a minimal template were adapted instead.
- Browser Use cloud APIs, daemon implementation and site-specific domain skills; only the operating discipline is documented.
- OpenViking runtime, storage engine and plugin code; only the portable context model is documented.
- agentmemory server, viewer and benchmark suites; only agent-facing rituals and a handoff format were adapted.
- Awesome list links that were not directly relevant to the harness patterns above.
- Full therapy/counseling protocols, clinical case files and longitudinal "therapist" personas (scope: this kit is educational only).
- Employee monitoring, flight-risk scores, individual wellbeing scoring and "culture fit" selection criteria.
- Text from repos with missing or restrictive licenses; only idea-level patterns were re-expressed.

## Maturity and curation

All new assets are `beta`: they are usable but not yet in `profiles/core.json`. Promotion to `stable` follows [docs/QUALITY_POLICY.md](./QUALITY_POLICY.md) and requires profile curation plus the normal quality gates.

## Verification

After integration, the usual gates apply:

```bash
python scripts/validate_assets.py --root . --check-manifest --check-links --strict-policy
python scripts/sync_readme_counts.py --root . --check
```

The provenance rows for new skills are also listed in `context/provenance.md`.
