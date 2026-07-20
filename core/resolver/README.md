# Resolver

The resolver handles dependency resolution between assets.

## Features

- **Dependency detection**: Identify dependencies between assets
- **Version compatibility**: Ensure compatible versions are used
- **Conflict resolution**: Handle version conflicts
- **Transitive dependencies**: Resolve indirect dependencies

## Usage

```bash
# Resolve dependencies for a skill
./core/resolver/resolve.sh skills/devops/docker-best-practices

# Check for conflicts
./core/resolver/check-conflicts.sh

# Update dependencies
./core/resolver/update.sh
```

## Dependency Model

Dependencies are declared in the asset's `metadata.json` file:

```json
{
  "dependencies": {
    "required": ["skill-a", "skill-b"],
    "optional": ["skill-c"]
  },
  "peerDependencies": {
    "opencode": ">=0.1.0"
  }
}
```

## Future Enhancements

- Automatic dependency installation
- Version pinning
- Lock files
- Dependency updates