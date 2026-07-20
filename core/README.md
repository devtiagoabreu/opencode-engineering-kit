# Core Infrastructure

This directory contains the core infrastructure for the OpenCode Engineering Kit.

## Directory Structure

```
core/
├── registry/      # Asset registry and schemas
├── discovery/     # Asset discovery system
├── resolver/      # Dependency resolution
├── validator/     # Schema validation
├── version/       # Versioning system
├── plugin/        # Plugin system
└── quality/       # Quality gates
```

## Components

### Registry
Manages the registration and indexing of all assets (skills, agents, prompts, templates, commands).

### Discovery
Provides search and discovery capabilities for finding assets by category, tags, or functionality.

### Resolver
Handles dependency resolution between assets, ensuring compatible versions are used together.

### Validator
Validates assets against schemas and quality standards before they can be published.

### Version
Manages semantic versioning for all assets and the platform itself.

### Plugin
Enables extension of the platform through plugins that add new functionality.

### Quality
Implements quality gates that all assets must pass before being accepted.