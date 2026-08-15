# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability within OpenCode Engineering Kit, please send an email to the maintainers. All security vulnerabilities will be promptly addressed.

**Please do NOT report security vulnerabilities through public GitHub issues.**

### What to include

When reporting a vulnerability, please include:

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### Response timeline

- **Acknowledgment**: Within 48 hours
- **Initial assessment**: Within 1 week
- **Fix or mitigation**: Within 2 weeks for critical issues

## Security Best Practices

### For Users

- Never commit secrets, API keys, or credentials
- Use environment variables for sensitive data
- Keep dependencies updated
- Review code before using in production

### For Contributors

- Follow secure coding practices
- Validate all inputs
- Use parameterized queries
- Sanitize outputs
- Run security scans before submitting PRs
- Never embed real credentials in skill/agent examples — use placeholders or `!secret` references
- Run `core/security/skill-scan.sh` before opening a PR; high-risk findings must be resolved or explicitly allowlisted

## Skill Content Security

The kit ships machine-readable instructions (skills and agents) that other AI
tools may execute. Malicious skill content — "ToxicSkills" — is a known attack
vector in skill marketplaces (e.g. skills that download-and-execute payloads,
harvest environment variables, or inject prompt overrides). The kit defends
against this in two ways:

### 1. Provenance

Every asset carries a `provenance` block (source, url, license, verified
date). Community content is marked as such and only added after review. See
`context/provenance.md`.

### 2. Automated content scan (`core/security/skill-scan.sh`)

Scans every `SKILL.md` and agent file for:

- **Download-and-execute** patterns: `curl|bash`, `wget|sh`, `irm|iex`, `iwr|iex`, `Invoke-Expression` against a URL
- **Hardcoded credentials**: private keys, passwords, tokens, API keys with values
- **Secret exfiltration** phrasing
- **Prompt-injection overrides**: "ignore previous instructions" and similar

Results are reported per file and gated:

- **FAIL** (exit 2): high-risk pattern without an allowlist entry — blocks the build
- **WARN**: medium-risk patterns (e.g. `os.environ`, `eval(`, `subprocess`) — informational, often legitimate
- **PASS** (exit 0): no un-allowlisted high-risk patterns

Allowlisted exceptions live in `core/security/skill-scan.allow` (scoped
`<path>:<regex>` entries with justification comments). The scan runs in CI as a
quality gate and in `core/quality/validate.sh`.

### SkillSpector

[NVIDIA SkillSpector](https://github.com/NVIDIA/skill-spector) can be used as
an optional external deep-scan layer. The kit's skill `security/skill-spector`
documents how to run it on the catalog for additional confidence.

## Incident Response Runbook

1. **Report**: file a private report (see below). Acknowledge within 48h.
2. **Triage**: assess scope (asset affected, pattern, blast radius) within 1 week.
3. **Contain**: remove or quarantine the affected asset from `main`; if a
   release was cut, tag a patched release immediately.
4. **Scan**: run `core/security/skill-scan.sh` over the full catalog and
   `secret-scan.sh` to check for related patterns elsewhere.
5. **Remediate**: fix the asset, rotate any exposed credentials, and document
   the finding in `context/HISTORY.md` and the CHANGELOG.
6. **Post-mortem**: within 2 weeks for critical issues — record the root cause
   and add a regression test (`tests/security/`) so the class of bug is caught.

## Dependency Security

We use automated tools to monitor dependencies:

- **Dependabot**: Automated dependency updates
- **Security audits**: Regular dependency audits

## Authentication & Authorization

This project does not handle authentication or authorization. It is a collection of documentation and configuration files.

## Data Storage

This project does not store any user data. All content is stored in the Git repository.

## Contact

For security concerns, contact the maintainers via:
- GitHub Issues (for non-sensitive matters)
- Email (for sensitive security reports)