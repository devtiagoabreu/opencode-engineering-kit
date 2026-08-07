# Plugin Guide

Practical guide for installing, writing, and running plugins in the OpenCode Engineering Kit.

## Installing Plugins

```bash
# From the local plugins directory (already bundled)
./core/plugin/installer.sh asset-linter

# From a local path
./core/plugin/installer.sh ./my-plugin

# From a git URL
./core/plugin/installer.sh https://github.com/user/my-plugin
```

## Listing Plugins

```bash
# Validate and load all plugins
./core/plugin/loader.sh

# Strict check (fails on any invalid plugin)
./core/plugin/loader.sh --check

# List registered hook handlers
./core/plugin/hooks.sh --list
```

## Writing Your First Plugin

```bash
# Scaffold a new plugin
./core/plugin/sdk.sh  # source only; use the sdk_init_plugin function:
```

```bash
source core/plugin/sdk.sh
sdk_init_plugin my-validator plugins/community/my-validator
```

Add a hook handler:

```bash
# plugins/community/my-validator/hooks/after-validate.sh
#!/bin/bash
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PLUGIN_ROOT/../../../core/plugin/sdk.sh"

RESULT="${2:-}"
log_info "validation result captured: $RESULT"
```

Run it:

```bash
./core/plugin/hooks.sh after-validate "all checks passed"
```

## Hooks Reference

| Hook | Fires | Arguments |
|------|-------|-----------|
| `before-generate` | Before asset generation | context, config |
| `after-generate` | After asset generation | context, asset |
| `before-validate` | Before validation | context, asset |
| `after-validate` | After validation | context, result |
| `before-install` | Before installation | context, package |
| `after-install` | After installation | context, package |
| `on-discover` | On asset discovery | context, asset |
| `on-search` | On search query | context, query |

## Example Plugin

See `plugins/community/asset-linter/` for a complete, tested example that:

- enforces kebab-case asset names (`before-validate`)
- logs a summary after generation (`after-generate`)
- ships a manifest, entry point, and README

Run its handlers:

```bash
./core/plugin/hooks.sh before-validate assets/skills/devops/docker-best-practices
./core/plugin/hooks.sh before-validate assets/skills/Bad_Asset   # fails
```
