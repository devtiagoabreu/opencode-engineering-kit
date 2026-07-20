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