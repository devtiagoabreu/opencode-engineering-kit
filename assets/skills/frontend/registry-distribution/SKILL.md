---
provenance:
  source: shadcn/ui
  source_url: https://github.com/shadcn-ui/ui
  license: MIT
  verified: 2026-11-23
maturity: beta
name: registry-distribution
description: Distribute code assets as copy-in registry items with manifests, namespaces and validation instead of opaque package dependencies.
category: frontend
version: 0.1.0
author: devtiagoabreu
tags: [registry, distribution, components, cli, supply-chain, copy-in]
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
requires:
  - a versioned source repository
  - an installer or CLI that materializes files into a target project
provides:
  - A registry manifest shape for mixed file types
  - Namespace and authentication rules for public and private sources
  - A publish-time validation checklist
security:
  risk_level: low
  permissions:
    - filesystem
    - network
  audited: true
difficulty: intermediate
---

# Registry Distribution

## Overview

A registry distributes **source files** that the receiving project owns and edits. This is different from a package dependency: the code lands in the repo, can be customized, and is reviewed like first-party code. Use this pattern for components, hooks, agent instructions, docs and project conventions.

Three layers make it work: a versioned source repository, a manifest describing installable items, and an installer that copies files and rewrites imports.

## Prerequisites

- A Git repository with stable file paths.
- An item schema your installer understands.
- A way to validate manifests before publishing.

## Usage Instructions

### 1. Choose the distribution mode

| Mode | Best for | Trade-off |
|---|---|---|
| Copy/paste docs | One-off snippets | No versioning or updates |
| Package dependency | Stable libraries | Consumers cannot edit internals |
| Registry item | Code meant to be forked per project | Consumer owns upgrades and diffs |

Use a registry when customization is the product, not an exception.

### 2. Define a manifest

Keep one root manifest and compose smaller ones with `include` when the registry grows.

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry.json",
  "name": "acme-toolkit",
  "homepage": "https://github.com/acme/toolkit",
  "items": [
    {
      "name": "project-conventions",
      "type": "registry:item",
      "title": "Project Conventions",
      "description": "Shared editor settings and agent instructions.",
      "registryDependencies": ["acme/lint-rules"],
      "dependencies": ["zod@3"],
      "files": [
        { "path": "AGENTS.md", "type": "registry:file", "target": "~/AGENTS.md" },
        { "path": "docs/conventions.md", "type": "registry:file" }
      ]
    }
  ]
}
```

Every item needs a unique name across the resolved registry. Paths are relative to the manifest that declares the item; targets use `~` for the project root.

### 3. Separate two addressing models

- **GitHub address:** `owner/repo/item` works for public repos with zero configuration.
- **Namespace:** `@team/item` maps to a configured URL template, useful for private hosting, headers, query parameters and stable aliases.

Namespaces are not a second registry; they are a resolvable alias. Document both in the consuming project.

### 4. Keep credentials out of manifests

Private registries may accept headers and parameters, but values must come from environment variables such as `${REGISTRY_TOKEN}`. Never commit a token, and never echo expanded headers in logs. Rotate the token if it appears in an error message.

### 5. Validate before publishing

1. Resolve `include` entries and check for duplicate item names.
2. Verify every referenced file exists and every target is inside the intended project.
3. Check dependency versions and registry dependency addresses.
4. Run the registry validator against a branch or tag, not only the working tree.
5. Review the generated diff as a consumer would.

### 6. Treat third-party registries as untrusted input

A registry item is executable code. Pin a tag or commit, read the diff before accepting, restrict which namespaces are allowed in a repository, and require review for items that add scripts, hooks or network calls.

## Examples

### Example 1: Installing from two sources

```bash
add acme/ui/button
add @internal/agent-rules
```

The first address is a public GitHub registry; the second is a configured private namespace.

### Example 2: Pre-merge checklist

```text
[ ] Manifest validates at the exact tag being released
[ ] All item names unique after include resolution
[ ] File targets stay inside the consumer project
[ ] Secrets referenced as ${VAR}, never inline
[ ] Diff reviewed from the consumer's point of view
```

## References

- [shadcn/ui](https://github.com/shadcn-ui/ui)
- [Registry files](https://ui.shadcn.com/docs/registry/registry-json)
- [GitHub registries](https://ui.shadcn.com/docs/registry/github)
- Kit companion: `design-system`
