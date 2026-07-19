---
name: coding-rules-context
description: Code rules for OpenCode Engineering Kit
type: conventions
version: 1.0.0
author: OpenCode Community
---

# Code Rules

## General

1. **Simplicity:** Keep code simple and readable
2. **Consistency:** Follow the style guide
3. **Modularity:** Independent components
4. **Testability:** Easy to test
5. **Documentability:** Easy to document

## Markdown

### Rules

1. Maximum 80 characters per line
2. Paragraphs separated by blank line
3. Use `-` for bullets
4. Always specify language in code blocks
5. Use reference links when possible

### Example

```markdown
# Title

Paragraph with **bold** and *italic*.

- Item 1
- Item 2

```python
def hello():
    print("Hello, World!")
```
```

## YAML

### Rules

1. 2-space indentation
2. Use quotes only when necessary
3. Use flow format for short lists
4. Comments to explain decisions

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

## Bash

### Rules

1. Shebang `#!/bin/bash`
2. `set -euo pipefail` at the beginning
3. 2-space indentation
4. Variables with `${VAR}`
5. Strings with double quotes
6. Functions for each task
7. Local variables with `local`
8. Handle errors explicitly

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
| Long functions | Small functions | Understanding |
| Excessive comments | Self-documenting code | Maintenance |
| Silent errors | Explicit handling | Debugging |
| Magic numbers | Named constants | Readability |

## Quality

### Metrics

| Metric | Minimum | Ideal |
|--------|---------|-------|
| Test coverage | 80% | 90%+ |
| Cyclomatic complexity | < 10 | < 5 |
| Duplication | < 5% | 0% |
| Documentation | 100% | 100% |

### Checklist

- [ ] Code is readable
- [ ] Names are descriptive
- [ ] Functions are small
- [ ] No duplicated code
- [ ] Error handling adequate
- [ ] Tests present
- [ ] Documentation updated