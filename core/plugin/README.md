# Plugin System

The plugin system enables extending the OpenCode Engineering Kit with custom behavior (validation rules, generation steps, search augmentations) without modifying core code.

## Components

```
core/plugin/
├── loader.sh      # Plugin discovery and loading
├── installer.sh   # Install plugins from local path, URL, or registry
├── uninstaller.sh # Uninstall plugins
├── hooks.sh       # Hook registry and dispatch
├── sdk.sh         # Plugin SDK (logging, manifest validation, scaffolding)
└── README.md
```

## Plugin Structure

```
plugin-name/
├── plugin.json              # Plugin manifest (required)
├── index.sh                 # Entry point (bash) — or index.js
├── hooks/                   # Hook handlers
│   ├── before-validate.sh
│   └── after-generate.sh
└── README.md
```

## Plugin Manifest (`plugin.json`)

```json
{
  "name": "asset-linter",
  "version": "1.0.0",
  "description": "Enforces asset naming conventions",
  "author": "OpenCode Engineering Kit",
  "license": "MIT",
  "opencode": {
    "minVersion": "0.1.0"
  },
  "hooks": ["before-validate", "after-generate"],
  "permissions": ["read:assets"],
  "dependencies": {},
  "entry": "index.sh"
}
```

- `name` and `version` are required and validated by the SDK.
- `hooks` must be one of: `before-generate`, `after-generate`, `before-validate`, `after-validate`, `before-install`, `after-install`, `on-discover`, `on-search`.
- `permissions` are declared but enforced by the calling pipeline.
- `entry` defaults to `index.sh`.

## Hook System

Hook handlers are bash scripts placed at `hooks/<hook-name>.sh`. The loader registers them; `hooks.sh` dispatches them in alphabetical order across plugins.

```bash
# List registered handlers
./core/plugin/hooks.sh --list

# Describe a hook
./core/plugin/hooks.sh --describe before-validate

# Run a hook with context arguments
./core/plugin/hooks.sh before-validate assets/skills/devops/docker-best-practices
```

### Writing a hook handler

```bash
#!/bin/bash
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$PLUGIN_ROOT/../../../core/plugin/sdk.sh"

ASSET_PATH="${1:-}"
if ! echo "$(basename "$ASSET_PATH")" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    log_error "asset name is not kebab-case"
    exit 1
fi
log_info "naming conventions OK"
```

## SDK

```bash
source ./core/plugin/sdk.sh

log_info "message"     # green [INFO]
log_warn "message"     # yellow [WARN]
log_error "message"    # red [ERROR]
sdk_validate_manifest <path-to-plugin.json>   # prints "name version entry"
sdk_check_permission <manifest> <permission>  # exit 0 if granted
sdk_init_plugin <name> [target-dir]           # scaffold a new plugin
```

## Lifecycle

1. **Discovery** — `loader.sh` scans `plugins/community` and `plugins/enterprise`.
2. **Validation** — manifest checked via `sdk_validate_manifest`; entry point existence checked.
3. **Loading** — bash entry points executed with `PLUGIN_NAME`/`PLUGIN_VERSION` exported.
4. **Registration** — hook handlers under `hooks/` are dispatched by `hooks.sh`.
5. **Execution** — hooks fire when the pipeline invokes `hooks.sh <hook>`.
6. **Unloading** — `uninstaller.sh` removes the plugin directory.

## Usage

```bash
# Validate and load all plugins
./core/plugin/loader.sh

# Strict validation (exit non-zero on any failure)
./core/plugin/loader.sh --check

# Install a plugin
./core/plugin/installer.sh <name|path|url>

# Uninstall a plugin
./core/plugin/uninstaller.sh <name>
```
