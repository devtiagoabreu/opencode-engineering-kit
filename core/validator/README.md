# Validator

The validator ensures assets meet quality standards and schema requirements.

## Features

- **Schema validation**: Validate metadata against JSON schemas
- **Content validation**: Check for required sections and content
- **Format validation**: Ensure consistent formatting
- **Quality gates**: Run quality checks before acceptance

## Usage

```bash
# Validate a single asset
./core/validator/validate.sh skills/devops/docker-best-practices

# Validate all assets
./core/validator/validate-all.sh

# Validate specific asset type
./core/validator/validate.sh --type=skill
```

## Validation Rules

### Required Fields
- `name`: Asset name
- `description`: Asset description
- `version`: Semantic version
- `author`: Asset author
- `category`: Asset category

### Content Requirements
- SKILL.md must have at least 3 sections
- README.md must exist
- Examples must be provided

### Quality Standards
- No spelling errors
- Consistent formatting
- Working links
- Complete documentation

## Future Enhancements

- Custom validation rules
- Validation plugins
- CI/CD integration
- Validation reports