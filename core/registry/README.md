# Registry

The Registry is the central catalog of all assets in the OpenCode Engineering Kit.

## Structure

```
core/registry/
├── schema/                    # JSON Schemas
│   ├── skill.schema.json
│   ├── agent.schema.json
│   ├── prompt.schema.json
│   ├── template.schema.json
│   └── command.schema.json
├── index/                     # Generated indexes
│   ├── skills.json
│   ├── agents.json
│   ├── prompts.json
│   ├── templates.json
│   └── commands.json
├── generate.sh                # Index generator
├── validate.sh                # Schema validator
└── README.md
```

## Usage

### Validate Assets

```bash
# Validate all assets
./core/registry/validate.sh

# Validate specific asset type
./core/registry/validate.sh --type skills
```

### Generate Index

```bash
# Generate all indexes
./core/registry/generate.sh

# Generate specific index
./core/registry/generate.sh --type skills
```

## Schemas

Each asset type has a JSON Schema that defines its structure:

- `skill.schema.json` - Skills
- `agent.schema.json` - Agents
- `prompt.schema.json` - Prompts
- `template.schema.json` - Templates
- `command.schema.json` - Commands

## Adding New Assets

1. Create asset directory in `assets/`
2. Add main file (SKILL.md, AGENT.md, etc.)
3. Add `metadata.json` with required fields
4. Run validation: `./core/registry/validate.sh`
5. Generate index: `./core/registry/generate.sh`