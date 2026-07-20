# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- .gitignore for security and build artifacts
- Linting configs (.markdownlint.json, .yamllint.yml, .shellcheckrc, .editorconfig)
- Test runner script (scripts/test.sh)
- Agent content tests
- Template content tests
- Install script tests
- Fixed install.sh copy-direction bug (line 69)
- Fixed bootstrap.sh to match actual structure
- Fixed agent frontmatter references to non-existent skills
- Updated all documentation to English
- Version aligned to v0.1.0 across all files

### Changed

- Standardized language to English throughout
- Updated test-skill-content.sh to support both English and Portuguese headers
- Removed empty docs/ files
- Removed orphan directories (nano scripts/, specs/)

### Deprecated

- None yet

### Removed

- Empty docs/ placeholder files
- Orphan directories (nano scripts/, specs/)

### Fixed

- install.sh copy-direction bug (line 69)
- bootstrap.sh structure mismatch with actual files
- Agent frontmatter references to non-existent skills
- Version inconsistency (v2.0.0 vs v0.1.0)

### Security

- Added .gitignore to prevent secrets from being committed

## [0.1.0] - 2026-07-18

### Added

- Initial project structure
- Bootstrap script (scripts/bootstrap.sh)
- Basic documentation (README, CONTRIBUTING, LICENSE)
- PROJECT_SPEC.md with complete specification

---

[Unreleased]: https://github.com/opencode-ai/opencode-engineering-kit/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/opencode-ai/opencode-engineering-kit/releases/tag/v0.1.0
