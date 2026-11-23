---
maturity: beta
name: diagram
description: Create or redraw an accessible self-contained HTML/SVG diagram using editorial layout and connector rules.
version: 0.1.0
author: devtiagoabreu
tags: [diagram, svg, html, accessibility, design]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
usage: /diagram <request> [--format html|svg|png] [--size doc-inline|slide-16x9|fit]
---

# /diagram

## Usage

```text
/diagram <request> [--format html|svg|png] [--size doc-inline|slide-16x9|fit]
```

## Description

Creates a diagram with the `diagram-design` skill. Before drawing, state the chosen visual type, size preset and anything the complexity budget will force out. For Mermaid, draw.io, Excalidraw or PlantUML input, extract the content and redraw it rather than converting renderer coordinates.

Output is a single self-contained HTML file with inline SVG by default. PNG or SVG export happens only when the user asks.

## Arguments

| Argument | Required | Description | Default |
|---|---|---|---|
| request | Yes | What the diagram should explain, or the source to import | — |
| --format | No | Deliverable format | html |
| --size | No | Size preset | doc-inline |
| --detail | No | faithful, balanced or simplified for imports | balanced |
| --audience | No | engineer, mixed or executive | mixed |

## Examples

```bash
/diagram "architecture of frontend, API and database" --size doc-wide
/diagram "redraw this Mermaid sequence diagram as an editorial SVG" --detail faithful
```

## Notes

- If a table would communicate the same idea, do not draw.
- Use accent on at most two elements and keep the SVG accessible.
- A missing renderer means the result is not visually reviewed; say so explicitly.
