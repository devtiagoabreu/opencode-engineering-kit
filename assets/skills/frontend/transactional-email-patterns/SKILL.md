---
provenance:
  source: React Email
  source_url: https://github.com/resend/react-email
  license: MIT
  verified: 2026-11-23
maturity: beta
name: transactional-email-patterns
description: Build cross-client transactional email as typed components with preview-first iteration, plain-text fallback and accessibility defaults.
category: frontend
version: 0.1.0
author: devtiagoabreu
tags: [email, react, templates, accessibility, deliverability, preview]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - a React/TypeScript project
  - an email rendering step and a delivery provider
provides:
  - A component and style contract for email HTML
  - A preview-first development loop
  - Deliverability and accessibility checks
security:
  risk_level: low
  permissions:
    - filesystem
  audited: true
difficulty: beginner
---

# Transactional Email Patterns

## Overview

Email HTML is not web HTML. Clients vary in CSS support, ignore modern layout features, and render from an inbox preview before the message is opened. Component-based email templates make the constraints explicit and testable.

## Prerequisites

- A component library that renders to email-safe HTML.
- A local preview server or render command.
- A delivery provider integration that accepts rendered HTML.

## Usage Instructions

### 1. Start with the preview text

The preview line appears in the inbox. Keep it short, meaningful and first in the body. Ensure it does not look like hidden text to spam filters.

### 2. Use a small structural vocabulary

```tsx
<Html lang="en" dir="ltr">
  <Head />
  <Preview>Welcome to Acme — confirm your email.</Preview>
  <Body>
    <Container>
      <Section>...</Section>
    </Container>
  </Body>
</Html>
```

Import only the components you use. Prefer semantic heading and text components over raw table markup.

### 3. Use pixel-based styling

Email clients do not reliably support `rem`. Use a pixel-based preset and inline styles generated from classes. Keep responsive classes to a minimum; media query support is inconsistent. Check desktop and mobile widths in the preview.

### 4. Render two formats

Every template should produce both HTML and plain text from the same source. Use the provider-agnostic `render` step, then hand the result to any delivery service. Keep the provider adapter outside the template so switching vendors does not rewrite content.

### 5. Apply accessibility defaults

Set language and direction on the root, meaningful alternative text on images, and a document title from the preview. Decorative images should have empty alternative text. Check link text out of context.

### 6. Test against real clients

Maintain a small matrix: Gmail, Apple Mail, Outlook and one other client your users actually use. Automate what can be automated (render snapshot, plain text presence, link checks) and do a manual visual pass for the matrix.

### 7. Keep personalization safe

Template props are untrusted strings. Escape them through the renderer, never concatenate raw HTML. Validate URLs before putting them in a button. Avoid putting secrets or one-time tokens in logs or previews.

## Examples

### Example 1: Template checklist

```text
[ ] Preview text under 140 characters and first in body
[ ] Pixel-based styles, no rem units
[ ] Plain-text output generated from same source
[ ] Images have meaningful alt text
[ ] Buttons are links, not JavaScript
[ ] Rendered snapshot checked in
[ ] Cross-client matrix reviewed
```

### Example 2: Provider adapter boundary

```text
template.tsx -> render() -> { html, text } -> mailer.send()
```

The mailer owns credentials and retry policy; the template owns content only.

## References

- [React Email](https://github.com/resend/react-email)
- [React Email docs](https://react.email/docs)
- Kit companions: `design-system`, `harness-engineering-patterns`
