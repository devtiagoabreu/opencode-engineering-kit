---
provenance:
  source: Browser Use
  source_url: https://github.com/browser-use/browser-use
  license: MIT
  verified: 2026-11-23
maturity: beta
name: browser-use-automation
description: Drive real browsers with a fetch-first triage, AX-tree interactions, tab lifecycle controls, secret-safe workflows and evidence-backed browser QA.
category: web
version: 0.1.0
author: devtiagoabreu
tags: [browser, cdp, automation, qa, scraping, accessibility-tree]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - browser-use CLI and a compatible Chrome/Chromium CDP endpoint for local work
  - network access and user consent for cloud browsers
provides:
  - A decision rule for fetch versus browser
  - Reliable element discovery through the accessibility tree
  - Tab, daemon, credential and QA lifecycle checklists
security:
  risk_level: medium
  permissions:
    - filesystem
    - network
  audited: false
difficulty: intermediate
---

# Browser Use Automation

## Overview

Use a real browser when the task needs interaction, JavaScript rendering, a logged-in session or a bot-sensitive page. A plain HTTP request is cheaper and more deterministic for public static content, so try it first.

Browser Use drives Chrome through CDP from one persistent Python REPL. The model writes small cells, the harness runs them, and results return to the model. This skill captures the operational rules that make that loop safe and repeatable.

## Prerequisites

- `browser-use` installed and a local Chrome/Chromium remote-debugging endpoint, or an approved cloud browser.
- The `browser-use --doctor` output checked before a long task.
- Explicit user permission for login, purchase or any action with external side effects.

## Usage Instructions

### 1. Triage before opening a browser

| Situation | Use |
|---|---|
| Public HTML, docs or API response | HTTP fetch |
| JS-rendered content, click/type/navigate | Browser |
| Logged-in state or site-specific workflow | Browser with user consent |
| Captcha or bot protection | Isolated cloud browser, if approved |

If a fetch returns a shell page or empty content, escalate to the browser and say why.

### 2. Manage tabs and daemons

- First navigation for a task is `new_tab(url)`, not repeated `goto_url(url)`.
- Inspect `current_tab()` and `list_tabs()` before opening another tab.
- Keep one working tab per task/site; reuse a matching tab with `switch_tab()`.
- Do not close tabs you did not create.
- Background tabs are enough for screenshots and CDP input; activate a tab only when the page demonstrably pauses while hidden.
- Name cloud daemons uniquely for parallel tasks and stop each one when finished.

### 3. Prefer the accessibility tree

Find elements from the accessibility tree, convert the node box to a center point, click, then verify with a targeted page check. Screenshots are for layout or imagery, not for guessing selectors.

```bash
browser-use <<'PY'
nodes = cdp("Accessibility.getFullAXTree")["nodes"]
matches = [n for n in nodes if n.get("name") == "Continue" and n.get("role") == "button"]
box = cdp("DOM.getBoxModel", backendNodeId=matches[0]["backendDOMNodeId"])["model"]["content"]
x, y = sum(box[0::2]) / 4, sum(box[1::2]) / 4
click_at_xy(x, y)
wait_for_load()
print(page_info())
PY
```

Use `js(...)` for DOM inspection or extraction when coordinates are the wrong tool. Stop at login walls, passwords, MFA, consent screens and ambiguous account choices unless the user has explicitly delegated them.

### 4. Handle sensitive input carefully

Use the tool's supported typed-input mechanism for sensitive values, allow only the minimum environment into the worker, and keep outputs and checkpoints redacted. Redaction is not a sandbox: do not assume a leaked value can be safely recovered.

### 5. Run browser QA with evidence

Check whether the agent can actually see images before assigning visual judgment. If not, route that step to a vision-capable executor. Score with a 1–5 rubric, put task completion first, and attach screenshots plus console/network evidence. For localhost apps, use a tunnel deliberately and do not score tunnel artifacts as product defects.

### 6. Keep the loop bounded

A long browser task should survive timeouts: kill the worker process tree, preserve files and browser state, and return partial results with an explicit status. Prune screenshots, reserve one final turn for delivery, and repair a failed delivery once rather than looping.

## Examples

### Example 1: Fetch-first escalation note

```text
Tried HTTP fetch: 403 and a challenge page.
Escalating to browser because the content requires JavaScript and session state.
Tab: reuse existing task tab if present; otherwise create one named task-17.
```

### Example 2: QA verdict shape

```markdown
Score: 4/5
Task completion: passed
Evidence: screenshot after submit, network 200, no console errors
Issue: date picker label is ambiguous on narrow viewport
Next action: retest at 390px after label fix
```

## References

- [Browser Use](https://github.com/browser-use/browser-use)
- [Browser Use skills](https://github.com/browser-use/browser-use/tree/main/skills)
- [Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/)
