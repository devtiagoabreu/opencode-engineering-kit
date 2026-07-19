---
name: conventions-context
description: Code conventions for OpenCode Engineering Kit
type: conventions
version: 1.0.0
author: OpenCode Community
---

# Code Conventions

## File Conventions

| Convention | Rule | Example |
|------------|------|---------|
| File name | kebab-case | `my-skill.md` |
| Directory name | kebab-case | `code-quality/` |
| Variable name | snake_case | `my_variable` |
| Constant name | UPPER_SNAKE_CASE | `MY_CONSTANT` |
| Function name | camelCase | `myFunction` |
| Class name | PascalCase | `MyClass` |

## Content Conventions

| Content | Rule | Example |
|---------|------|---------|
| Titles | Title Case | `## My Title` |
| Lists | '-' for bullets | `- Item` |
| Code | Fenced block | ` ```language ` |
| Links | Markdown links | `[text](url)` |
| Images | Markdown images | `![alt](url)` |

## Git Conventions

| Convention | Rule | Example |
|------------|------|---------|
| Branch naming | kebab-case | `feature/my-skill` |
| Commit message | Conventional Commits | `feat: add docker skill` |
| PR title | Conventional Commits | `feat: add docker skill` |
| Tags | semver | `v1.0.0` |

## Documentation Conventions

| Document | Language | Format |
|----------|----------|--------|
| README | English | Markdown |
| CONTRIBUTING | English | Markdown |
| CHANGELOG | English | Markdown |
| PROJECT_SPEC | English | Markdown |
| Skills | English | Markdown |
| Agents | English | Markdown |

## Markdown Style Guide

### General

- Maximum 80 characters per line
- Paragraphs separated by blank line
- Use `-` for bullets, not '*'
- Always specify language in code blocks
- Use reference links when possible
- Descriptive alt text for images

### Headers

```markdown
# H1 - Main Title
## H2 - Sections
### H3 - Subsections
#### H4 - Sub-subsections
```

### Lists

```markdown
- Item 1
- Item 2
  - Sub-item
- Item 3
```

### Code

````markdown
```python
def hello():
    print("Hello, World!")
```
````

## YAML Style Guide

### General

- 2-space indentation
- Use quotes only when necessary
- Use flow format for short lists
- Comments to explain decisions

### Example

```yaml
---
name: skill-name
description: Skill description
tags: [tag1, tag2]
compatible:
  - opencode
  - claude-code
---
```

## Bash Style Guide

### General

- Shebang `#!/bin/bash`
- `set -euo pipefail` at the beginning
- 2-space indentation
- Variables with `${VAR}`
- Double-quoted strings

### Example

```bash
#!/bin/bash
set -euo pipefail

function main() {
    local input="${1:?Usage: $0 <input>}"
    echo "Processing: ${input}"
}

main "$@"
```

## Anti-Patterns

| Anti-Pattern | Correct Pattern | Reason |
|--------------|-----------------|--------|
| Hardcoded secrets | Environment variables | Security |
| Duplicated code | Reusable functions | Maintenance |
| Generic names | Descriptive names | Readability |
| Long functions | Small functions | Comprehension |
| Excessive comments | Self-documenting code | Maintenance |
