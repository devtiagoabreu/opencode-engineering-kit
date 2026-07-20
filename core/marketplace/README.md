# Marketplace

This directory contains the marketplace infrastructure for the OpenCode Engineering Kit.

## Overview

The marketplace enables users to discover, install, and share assets (skills, agents, prompts, templates, commands) with the community.

## Features

- **Asset Discovery**: Search and browse assets
- **One-Click Install**: Install assets with a single command
- **Version Management**: Manage asset versions
- **Dependency Resolution**: Automatically resolve dependencies
- **Quality Assurance**: All assets pass quality gates

## Usage

### Search for Assets

```bash
./core/marketplace/search.sh "docker"
```

### Install an Asset

```bash
./core/marketplace/install.sh skill docker-best-practices
```

### List Installed Assets

```bash
./core/marketplace/list.sh
```

## Asset Structure

Assets in the marketplace follow the standard structure:

```
asset-name/
├── SKILL.md or agent.md or prompt.md
├── metadata.json
├── README.md
└── examples/
```

## Quality Gates

All assets must pass the following quality gates:

- Schema validation
- Content validation
- Security scanning
- Documentation review

## Publishing

To publish an asset to the marketplace:

1. Create the asset following the structure
2. Run validation: `./core/validator/validate.sh <asset-path>`
3. Submit a pull request
4. Wait for review and approval

## Future Enhancements

- Web-based marketplace
- User reviews and ratings
- Asset analytics
- Monetization options