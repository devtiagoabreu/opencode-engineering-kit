# Repository Governance Specification

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Overview

Repository Governance defines roles, responsibilities, and decision-making processes for the OpenCode Engineering Kit repository.

---

## Design Principles

1. **Transparent** — All decisions documented
2. **Inclusive** — Community can contribute
3. **Efficient** — Minimal bureaucracy
4. **Accountable** — Clear ownership
5. **Evolutionary** — Governance evolves with project

---

## Roles & Responsibilities

### Role Hierarchy

```
┌─────────────────────────────────────┐
│  Repository Owner                    │
├─────────────────────────────────────┤
│  Core Maintainers (3-5)             │
├─────────────────────────────────────┤
│  Module Maintainers                  │
├─────────────────────────────────────┤
│  Contributors                        │
├─────────────────────────────────────┤
│  Community Members                   │
└─────────────────────────────────────┘
```

### Role Definitions

| Role | Responsibilities | Requirements |
|------|------------------|--------------|
| Owner | Final decisions, repository settings | Repository creator |
| Core Maintainer | Review PRs, merge, releases | 6+ months contribution |
| Module Maintainer | Maintain specific module | Expertise in area |
| Contributor | Submit PRs, report issues | Signed CLA |
| Community Member | Use, report issues, suggest | None |

---

## Decision Making

### Decision Types

| Type | Process | Timeline |
|------|---------|----------|
| Routine | Core maintainer approval | 24h |
| Significant | 2 core maintainer approval | 72h |
| Major | All core maintainers + owner | 7 days |
| Emergency | Any core maintainer | Immediate |

### RFC Process

```
1. Proposal
   └─ Submit RFC document

2. Discussion
   └─ 7-day comment period

3. Vote
   └─ Core maintainers vote

4. Decision
   └─ Accept, reject, or defer

5. Implementation
   └─ Assign to milestone
```

### RFC Template

```markdown
# RFC: [Title]

## Summary
Brief summary of the proposal.

## Motivation
Why this change is needed.

## Detailed Design
Technical details of the proposal.

## Drawbacks
Potential negative impacts.

## Alternatives
Other approaches considered.

## Unresolved Questions
Open questions for discussion.
```

---

## Pull Request Process

### PR Requirements

| Requirement | Description |
|-------------|-------------|
| Description | Clear description of changes |
| Tests | New tests for new features |
| Documentation | Updated documentation |
| Changelog | Entry in CHANGELOG.md |
| Version | Version bump if needed |
| Review | At least 1 approval |

### Review Checklist

```markdown
## Code Quality
- [ ] Code follows style guide
- [ ] No linting errors
- [ ] No type errors
- [ ] No security issues

## Tests
- [ ] New tests added
- [ ] All tests pass
- [ ] Coverage maintained

## Documentation
- [ ] README updated
- [ ] API docs updated
- [ ] Examples updated

## Compatibility
- [ ] Backward compatible
- [ ] Platform compatible
- [ ] Version bumped
```

### Merge Requirements

```
Routine PR:
  ✓ 1 approval
  ✓ CI passing
  ✓ No conflicts

Significant PR:
  ✓ 2 approvals
  ✓ CI passing
  ✓ No conflicts
  ✓ Tests pass

Major PR:
  ✓ All core maintainer approvals
  ✓ CI passing
  ✓ No conflicts
  ✓ Tests pass
  ✓ RFC approved
```

---

## Issue Management

### Issue Types

| Type | Label | Priority |
|------|-------|----------|
| Bug | bug | high/medium/low |
| Feature | enhancement | high/medium/low |
| Documentation | docs | medium/low |
| Security | security | critical/high |
| Performance | performance | high/medium/low |

### Issue Lifecycle

```
1. Created
   └─ New issue submitted

2. Triaged
   └─ Labeled and prioritized

3. Assigned
   └─ Assigned to maintainer

4. In Progress
   └─ Work started

5. In Review
   └─ PR submitted

6. Closed
   └─ Issue resolved
```

### Issue Templates

```markdown
## Bug Report

### Description
[Description of the bug]

### Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Environment
- OS: [OS]
- Version: [Version]
```

---

## Release Process

### Release Cycle

```
Stable Releases:
  ├── Patch releases: As needed
  ├── Minor releases: Monthly
  └── Major releases: Quarterly

Pre-releases:
  ├── Alpha: After major changes
  ├── Beta: 2 weeks before release
  └── RC: 1 week before release
```

### Release Checklist

```markdown
## Release Checklist

### Pre-release
- [ ] All tests passing
- [ ] Documentation updated
- [ ] Changelog updated
- [ ] Version bumped
- [ ] Dependencies updated

### Release
- [ ] Create release branch
- [ ] Tag release
- [ ] Build artifacts
- [ ] Publish to registry
- [ ] Update marketplace

### Post-release
- [ ] Monitor for issues
- [ ] Respond to feedback
- [ ] Plan next release
```

### Release Automation

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: ./scripts/test.sh
      - name: Build
        run: ./scripts/build.sh
      - name: Create release
        uses: actions/create-release@v1
      - name: Publish
        run: ./scripts/publish.sh
```

---

## Conflict Resolution

### Process

```
1. Discussion
   └─ Parties discuss in issue/PR

2. Mediation
   └─ Core maintainer mediates

3. Vote
   └─ Core maintainers vote

4. Decision
   └─ Final decision by owner
```

### Code of Conduct

```markdown
## Code of Conduct

### Our Standards
- Be respectful
- Be constructive
- Be inclusive
- Be professional

### Enforcement
- Warning
- Temporary ban
- Permanent ban
```

---

## Governance Evolution

### Review Cycle

```
Quarterly Review:
  ├── Assess governance effectiveness
  ├── Gather community feedback
  ├── Update documentation
  └── Adjust processes
```

### Amendment Process

```
1. Proposal
   └─ Submit governance amendment

2. Discussion
   └─ 14-day comment period

3. Vote
   └─ 2/3 majority of core maintainers

4. Implementation
   └─ Update governance docs
```

---

## Future Enhancements

1. **Voting System** — Formal voting mechanism
2. **Delegation** — Delegate responsibilities
3. **Automation** — Automated governance checks
4. **Transparency** — Public decision logs
5. **Community Council** — Community representatives