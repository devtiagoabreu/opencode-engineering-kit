# Quality Gates Specification

> **Status:** Proposal  
> **Date:** 2026-07-19  
> **Author:** Chief Architect  
> **Decision:** Pending approval

---

## Overview

Quality Gates define automated checks that assets must pass before being accepted into the repository or published to the marketplace.

---

## Design Principles

1. **Automated** — All checks automated
2. **Fast** — Complete in <5 minutes
3. **Clear** — Clear pass/fail results
4. **Consistent** — Same checks everywhere
5. **Evolving** — Gates improve over time

---

## Gate Levels

### Level 1: Local Development

| Check | Description | Timeout |
|-------|-------------|---------|
| Schema Validation | Validate metadata | 10s |
| Lint Check | Linting rules | 30s |
| Format Check | Code formatting | 10s |
| Spell Check | Spell checking | 30s |

### Level 2: Pre-commit

| Check | Description | Timeout |
|-------|-------------|---------|
| All Level 1 | Level 1 checks | 60s |
| Test Run | Run unit tests | 120s |
| Build Check | Verify build works | 60s |

### Level 3: CI/CD

| Check | Description | Timeout |
|-------|-------------|---------|
| All Level 2 | Level 2 checks | 240s |
| Integration Tests | Run integration tests | 300s |
| Security Scan | Security vulnerabilities | 120s |
| Dependency Audit | Check dependencies | 60s |

### Level 4: Release

| Check | Description | Timeout |
|-------|-------------|---------|
| All Level 3 | Level 3 checks | 720s |
| Performance Test | Performance benchmarks | 300s |
| Compatibility Test | Platform compatibility | 300s |
| Documentation Review | Docs completeness | 60s |

---

## Validation Rules

### Schema Validation

```json
{
  "rules": [
    {
      "name": "required-fields",
      "description": "All required fields present",
      "severity": "error"
    },
    {
      "name": "field-types",
      "description": "Field types correct",
      "severity": "error"
    },
    {
      "name": "field-constraints",
      "description": "Field constraints satisfied",
      "severity": "error"
    },
    {
      "name": "version-format",
      "description": "Version follows SemVer",
      "severity": "error"
    },
    {
      "name": "name-format",
      "description": "Name follows conventions",
      "severity": "error"
    }
  ]
}
```

### Content Validation

```json
{
  "rules": [
    {
      "name": "has-overview",
      "description": "Asset has overview section",
      "severity": "error"
    },
    {
      "name": "has-examples",
      "description": "Asset has examples",
      "severity": "warning"
    },
    {
      "name": "has-installation",
      "description": "Asset has installation instructions",
      "severity": "error"
    },
    {
      "name": "has-usage",
      "description": "Asset has usage instructions",
      "severity": "error"
    },
    {
      "name": "no-broken-links",
      "description": "No broken links in content",
      "severity": "error"
    }
  ]
}
```

### Quality Validation

```json
{
  "rules": [
    {
      "name": "has-tests",
      "description": "Asset has tests",
      "severity": "warning"
    },
    {
      "name": "has-examples",
      "description": "Asset has examples",
      "severity": "warning"
    },
    {
      "name": "has-changelog",
      "description": "Asset has changelog",
      "severity": "warning"
    },
    {
      "name": "has-readme",
      "description": "Asset has README",
      "severity": "error"
    }
  ]
}
```

---

## Linting Rules

### Markdown Linting

```json
{
  "rules": {
    "MD001": "heading-increment",
    "MD003": "heading-style",
    "MD010": "no-hard-tabs",
    "MD012": "no-multiple-blanks",
    "MD013": "line-length",
    "MD024": "no-duplicate-heading",
    "MD031": "blanks-around-fences",
    "MD032": "blanks-around-lists",
    "MD040": "fenced-code-language",
    "MD041": "first-line-heading"
  }
}
```

### YAML Linting

```json
{
  "rules": {
    "truthy": true,
    "comments": true,
    "document-start": true,
    "indent": {
      "spaces": 2,
      "indent-sequences": true
    },
    "line-length": {
      "max": 120
    }
  }
}
```

### Shell Linting

```json
{
  "shell": "bash",
  "severity": "warning",
  "exclude": [
    "SC1091",
    "SC2034"
  ]
}
```

---

## Security Scanning

### Vulnerability Checks

| Check | Description | Severity |
|-------|-------------|----------|
| Dependency Audit | Check for vulnerable deps | Critical |
| Secret Detection | Detect exposed secrets | Critical |
| Malware Scan | Scan for malicious code | High |
| License Check | Verify license compatibility | Medium |

### Security Tools

```bash
# Dependency audit
npm audit
pip audit
bundler-audit

# Secret detection
trufflehog
gitleaks
detect-secrets

# Malware scan
clamscan
rkhunter
```

---

## Performance Testing

### Benchmarks

| Metric | Target | Measurement |
|--------|--------|-------------|
| Search Time | <100ms | Time to search |
| Install Time | <30s | Time to install |
| Validation Time | <10s | Time to validate |
| Index Build Time | <30s | Time to build index |

### Performance Tests

```bash
# Run performance tests
./core/quality/perf.sh

# Benchmark specific asset
./core/quality/perf.sh --asset skill-name

# Generate performance report
./core/quality/perf.sh --report
```

---

## Compatibility Testing

### Platform Testing

| Platform | Test Command | Expected |
|----------|--------------|----------|
| OpenCode | opencode test | Pass |
| Claude Code | claude test | Pass |
| Cursor | cursor test | Pass |
| Copilot | copilot test | Pass |

### Framework Testing

| Framework | Test Command | Expected |
|-----------|--------------|----------|
| React | react test | Pass |
| Vue | vue test | Pass |
| Angular | ng test | Pass |

---

## CI/CD Integration

### GitHub Actions

```yaml
name: Quality Gates

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  quality-gates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Level 1 - Local
        run: |
          ./core/quality/validate.sh
          ./core/quality/lint.sh
          ./core/quality/format.sh
      
      - name: Level 2 - Pre-commit
        run: |
          ./core/quality/test.sh
          ./core/quality/build.sh
      
      - name: Level 3 - CI/CD
        run: |
          ./core/quality/integration.sh
          ./core/quality/security.sh
          ./core/quality/audit.sh
      
      - name: Level 4 - Release
        if: startsWith(github.ref, 'refs/tags/')
        run: |
          ./core/quality/perf.sh
          ./core/quality/compat.sh
          ./core/quality/docs.sh
```

### Quality Report

```json
{
  "timestamp": "2026-07-19T00:00:00Z",
  "level": 3,
  "results": {
    "schema-validation": {
      "status": "pass",
      "duration": "2.5s"
    },
    "lint-check": {
      "status": "pass",
      "duration": "5.2s"
    },
    "test-run": {
      "status": "pass",
      "duration": "30.1s"
    },
    "security-scan": {
      "status": "pass",
      "duration": "15.3s"
    }
  },
  "summary": {
    "total": 10,
    "passed": 10,
    "failed": 0,
    "warnings": 2
  }
}
```

---

## Quality Metrics

### Metrics Tracked

| Metric | Target | Current |
|--------|--------|---------|
| Pass Rate | >95% | N/A |
| Average Duration | <5min | N/A |
| False Positive Rate | <5% | N/A |
| Coverage | >80% | N/A |

### Quality Dashboard

```json
{
  "dashboard": {
    "pass_rate": 97.5,
    "avg_duration": "3m 45s",
    "false_positive_rate": 2.1,
    "coverage": 82.3,
    "trend": "improving"
  }
}
```

---

## Future Enhancements

1. **Custom Gates** — User-defined quality gates
2. **AI-Powered Review** — AI-assisted code review
3. **Visual Regression** — Visual testing
4. **Accessibility Testing** — Accessibility checks
5. **Performance Profiling** — Detailed performance analysis
