# Contributing to OpenCode Engineering Kit

Thank you for considering contributing! Every contribution is valuable.

## Contribution Types

### 1. New Skill

To create a new skill:

1. Check if a similar skill already exists
2. Choose the appropriate category
3. Create a directory in `skills/<category>/`
4. Create the `SKILL.md` file following the template
5. Add practical examples
6. Submit a PR

#### SKILL.md Template

```markdown
---
name: skill-name
description: Clear description of the skill
category: category
version: 1.0.0
author: Your Name
tags: [tag1, tag2]
compatible:
  - opencode
  - claude-code
  - cursor
---

# Skill Name

## Overview

[Detailed description]

## Prerequisites

- [Requirements]

## Usage Instructions

### Step 1: [Title]

[Instructions]

## Examples

### Example 1: [Title]

[Example with code]

## References

- [Useful links]
```

### 2. New Agent

1. Define the persona and skills
2. Create the file `agents/<name>.md`
3. Document capabilities and context
4. Add usage examples
5. Submit a PR

### 3. New Template

1. Identify the use case
2. Create the directory in `templates/<type>/`
3. Define variables with `{{name}}`
4. Document usage and examples
5. Submit a PR

### 4. New Prompt

1. Define the objective clearly
2. Create the file in the appropriate category
3. Add variables and examples
4. Submit a PR

### 5. Improvements

- Suggest improvements to existing components
- Fix bugs found
- Improve documentation
- Add tests

### 6. Bug Reports

- Open an issue with the `bug` tag
- Describe the problem in detail
- Include steps to reproduce
- Add screenshots if applicable

## Contribution Process

### 1. Fork and Clone

```bash
git clone https://github.com/your-username/opencode-engineering-kit.git
cd opencode-engineering-kit
```

### 2. Create Branch

```bash
git checkout -b feature/my-feature
```

**Branch naming:**

- `feature/<name>` — New feature
- `bugfix/<name>` — Bug fix
- `hotfix/<name>` — Urgent fix
- `docs/<name>` — Documentation changes

### 3. Implement

- Follow the style guide
- Add tests if necessary
- Update documentation

### 4. Commit

Use [Conventional Commits](https://www.conventionalcommits.org/):

```bash
git commit -m "feat: add docker-best-practices skill"
git commit -m "fix: correct typo in README"
git commit -m "docs: update installation guide"
```

**Commit types:**

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Formatting (no logic change)
- `refactor:` Refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

### 5. Push and PR

```bash
git push origin feature/my-feature
```

Create a Pull Request with:

- Clear descriptive title
- Description of what was done
- Reference to related issues
- Screenshots if applicable

### 6. Code Review

- Every PR needs at least 1 approval
- Respond to all comments
- Implement requested changes

## Style Guide

### Markdown

- Maximum 80 characters per line
- Use `-` for lists
- Always specify language in code blocks
- Use hierarchical headers

### YAML

- 2-space indentation
- Use quotes only when necessary
- Comments to explain decisions

### Bash

- Shebang `#!/bin/bash`
- `set -euo pipefail` at the beginning
- 2-space indentation
- Variables with `${VAR}`

### Naming

- Files: `kebab-case`
- Bash variables: `UPPER_SNAKE_CASE`
- YAML variables: `snake_case`
- Templates: `{{snake_case}}`

## PR Checklist

- [ ] Code follows style guide
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] At least 1 example included
- [ ] Commit messages follow Conventional Commits
- [ ] Branch is up to date with main

## Frequently Asked Questions

### How to report a bug?

Open an issue with the `bug` tag and describe the problem in detail.

### How to suggest a feature?

Open an issue with the `enhancement` tag and describe your suggestion.

### Can I contribute with code that is not markdown?

Yes! We accept scripts, tests, workflows, and other types of contributions.

### Do I need to be an expert to contribute?

No! Contributions of all levels are welcome. Start with simple documentation improvements.

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](./CODE_OF_CONDUCT.md). By contributing, you agree to follow its terms.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](./LICENSE).
