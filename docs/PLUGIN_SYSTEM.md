# Plugin System Specification

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Overview

The Plugin System enables extensibility by allowing third parties to add new asset types, providers, and behaviors to the OpenCode Engineering Kit without modifying core code.

---

## Design Principles

1. **Isolation** — Plugins run in sandboxed context
2. **Composability** — Plugins can combine
3. **Discoverability** — Auto-detect installed plugins
4. **Versioning** — Plugins versioned independently
5. **Security** — Permissions-based access control

---

## Plugin Architecture

```
core/plugins/
├── sdk/                      # Plugin SDK
│   ├── plugin.js            # Plugin base class
│   ├── hooks.js             # Hook system
│   ├── context.js           # Plugin context
│   └── api.js               # Plugin API
├── loader/                   # Plugin loader
│   ├── discover.js          # Plugin discovery
│   ├── resolve.js           # Dependency resolution
│   └── sandbox.js           # Sandboxing
├── registry/                 # Plugin registry
│   ├── installed.json       # Installed plugins
│   └── available.json       # Available plugins
├── hooks/                    # Built-in hooks
│   ├── before-generate.md
│   ├── after-generate.md
│   ├── before-validate.md
│   └── after-validate.md
└── README.md
```

---

## Plugin Structure

### Directory Layout

```
plugin-name/
├── plugin.json              # Plugin manifest
├── index.js                 # Entry point
├── hooks/                   # Hook handlers
│   ├── before-generate.js
│   └── after-generate.js
├── lib/                     # Plugin code
│   ├── generator.js
│   └── validator.js
├── tests/                   # Plugin tests
│   └── plugin.test.js
└── README.md
```

### plugin.json

```json
{
  "name": "my-custom-plugin",
  "version": "1.0.0",
  "description": "My custom plugin for OpenCode",
  "author": "developer",
  "license": "MIT",
  "opencode": {
    "minVersion": "0.1.0",
    "maxVersion": "2.0.0"
  },
  "hooks": [
    "before-generate",
    "after-generate"
  ],
  "permissions": [
    "read:assets",
    "write:assets",
    "read:config"
  ],
  "dependencies": {},
  "entry": "index.js"
}
```

---

## Hook System

### Available Hooks

| Hook | Description | Arguments |
|------|-------------|-----------|
| before-generate | Before asset generation | context, config |
| after-generate | After asset generation | context, asset |
| before-validate | Before validation | context, asset |
| after-validate | After validation | context, result |
| before-install | Before installation | context, package |
| after-install | After installation | context, package |
| on-discover | On asset discovery | context, asset |
| on-search | On search query | context, query |

### Hook Implementation

```javascript
// hooks/before-generate.js
module.exports = {
  name: 'before-generate',
  
  async execute(context, config) {
    // Modify context before generation
    context.customData = 'value';
    
    // Add custom variables
    context.variables.myVar = 'myValue';
    
    // Return modified context
    return context;
  }
};
```

### Hook Chain

Multiple plugins can hook into the same event:

```
Plugin A (before-generate)
  ↓
Plugin B (before-generate)
  ↓
Core Generator
  ↓
Plugin A (after-generate)
  ↓
Plugin B (after-generate)
```

---

## Plugin API

### Context Object

```javascript
// Available in all hooks
const context = {
  // Asset being processed
  asset: {
    name: 'my-skill',
    type: 'skill',
    path: '/path/to/asset'
  },
  
  // Plugin configuration
  config: {
    // User-provided config
  },
  
  // Shared variables
  variables: {},
  
  // Logger
  log: {
    info: (msg) => {},
    warn: (msg) => {},
    error: (msg) => {},
    debug: (msg) => {}
  },
  
  // File system access
  fs: {
    read: (path) => {},
    write: (path, content) => {},
    exists: (path) => {}
  },
  
  // Registry access
  registry: {
    query: (filters) => {},
    get: (name) => {},
    register: (asset) => {}
  }
};
```

### Plugin Base Class

```javascript
// index.js
const { Plugin } = require('@opencode/plugin-sdk');

class MyPlugin extends Plugin {
  name = 'my-plugin';
  version = '1.0.0';
  
  async onInstall() {
    // Called when plugin is installed
    this.log.info('Plugin installed');
  }
  
  async onUninstall() {
    // Called when plugin is uninstalled
    this.log.info('Plugin uninstalled');
  }
  
  async beforeGenerate(context) {
    // Handle before-generate hook
    return context;
  }
  
  async afterGenerate(context, asset) {
    // Handle after-generate hook
    return asset;
  }
}

module.exports = MyPlugin;
```

---

## Plugin Management

### Install Plugin

```bash
# Install from registry
./core/plugins/install.sh my-plugin

# Install from URL
./core/plugins/install.sh https://github.com/user/plugin

# Install from local path
./core/plugins/install.sh ./path/to/plugin

# Install specific version
./core/plugins/install.sh my-plugin@1.2.0
```

### Uninstall Plugin

```bash
# Uninstall plugin
./core/plugins/uninstall.sh my-plugin

# Uninstall and remove config
./core/plugins/uninstall.sh my-plugin --purge
```

### List Plugins

```bash
# List installed plugins
./core/plugins/list.sh

# List available plugins
./core/plugins/list.sh --available

# List plugin hooks
./core/plugins/list.sh --hooks
```

### Update Plugins

```bash
# Update all plugins
./core/plugins/update.sh

# Update specific plugin
./core/plugins/update.sh my-plugin
```

---

## Security Model

### Permissions

| Permission | Description |
|------------|-------------|
| read:assets | Read asset files |
| write:assets | Modify asset files |
| read:config | Read configuration |
| write:config | Modify configuration |
| read:registry | Query registry |
| write:registry | Modify registry |
| execute:scripts | Run scripts |
| network | Make network requests |

### Permission Declaration

```json
{
  "permissions": [
    "read:assets",
    "read:config"
  ]
}
```

### Permission Check

```javascript
// In plugin code
if (!this.hasPermission('write:assets')) {
  throw new Error('Permission denied: write:assets');
}
```

---

## Plugin Testing

### Test Structure

```
tests/
├── plugin.test.js          # Unit tests
├── hooks.test.js           # Hook tests
└── integration.test.js     # Integration tests
```

### Test Example

```javascript
// tests/plugin.test.js
const { TestContext } = require('@opencode/plugin-sdk/test');
const MyPlugin = require('../index');

describe('MyPlugin', () => {
  let plugin;
  let context;
  
  beforeEach(() => {
    plugin = new MyPlugin();
    context = new TestContext();
  });
  
  test('beforeGenerate modifies context', async () => {
    const result = await plugin.beforeGenerate(context);
    expect(result.customData).toBe('value');
  });
});
```

### Run Plugin Tests

```bash
# Test specific plugin
./core/plugins/test.sh my-plugin

# Test all plugins
./core/plugins/test.sh --all
```

---

## Plugin Lifecycle

```
1. Discovery
   └─ Plugin loader scans plugin directories

2. Resolution
   └─ Resolve dependencies between plugins

3. Loading
   └─ Load plugin code into sandbox

4. Initialization
   └─ Call plugin constructor

5. Registration
   └─ Register hooks with hook system

6. Execution
   └─ Hooks execute when events occur

7. Unloading
   └─ Cleanup when plugin is disabled
```

---

## Future Enhancements

1. **Plugin Marketplace** — Browse and install plugins
2. **Plugin Dependencies** — Declare plugin dependencies
3. **Plugin Conflicts** — Detect conflicting plugins
4. **Plugin Updates** — Auto-update plugins
5. **Plugin Analytics** — Track plugin usage
6. **Plugin Sandbox** —更强的隔离
7. **Plugin API Versioning** — Version plugin API
