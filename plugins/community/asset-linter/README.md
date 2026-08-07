# asset-linter

Enforces asset naming conventions and file layout during validation.

## Hooks

- `before-validate` — fails when an asset name is not kebab-case
- `after-generate` — logs a summary after asset generation

## Permissions

- `read:assets`

## Usage

```bash
# List registered handlers
./core/plugin/hooks.sh --list

# Run the before-validate hook with an asset context
./core/plugin/hooks.sh before-validate assets/skills/devops/docker-best-practices

# Run the after-generate hook
./core/plugin/hooks.sh after-generate assets/skills/devops/docker-best-practices
```

## Testing

```bash
./core/plugin/test.sh asset-linter
```
