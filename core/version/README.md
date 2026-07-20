# Version System

The version system manages semantic versioning for all assets.

## Features

- **Semantic versioning**: Follow semver specification
- **Version bumping**: Automatic version increment
- **Changelog generation**: Create changelogs from commits
- **Version validation**: Ensure valid version formats

## Usage

```bash
# Bump version
./core/version/bump.sh patch|minor|major

# Generate changelog
./core/version/changelog.sh

# Validate version
./core/version/validate.sh
```

## Version Format

```
MAJOR.MINOR.PATCH

MAJOR: Breaking changes
MINOR: New features (backward compatible)
PATCH: Bug fixes (backward compatible)
```

## Examples

```
0.1.0 → 0.1.1 (patch)
0.1.1 → 0.2.0 (minor)
0.2.0 → 1.0.0 (major)
```

## Future Enhancements

- Pre-release versions
- Build metadata
- Version locking
- Automated releases