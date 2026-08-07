# Marketplace

This directory contains the marketplace infrastructure for the OpenCode Engineering Kit.

## Components

```
core/marketplace/
├── install.sh       # Install assets into the kit
├── search.sh        # Search assets by keyword
├── publish.sh       # Publish assets to the registry
├── publisher.sh     # Manage publisher accounts
├── rate.sh          # Ratings and reviews
└── README.md
```

Registry data lives in `core/marketplace/registry/` (`assets.json`, `publishers.json`, `reviews.json`).

## Usage

### Search for Assets

```bash
./core/marketplace/search.sh "docker"
```

### Install an Asset

```bash
./core/marketplace/install.sh skill docker-best-practices
```

### Publish an Asset

```bash
# Create a publisher account (once)
./core/marketplace/publisher.sh create --name "John Doe" --email john@example.com
./core/marketplace/publisher.sh verify --publisher john-doe

# Publish an asset
./core/marketplace/publish.sh --type skill --path ./assets/skills/my-skill --publisher john-doe

# List published assets
./core/marketplace/publish.sh --list
```

### Rate an Asset

```bash
./core/marketplace/rate.sh add --asset docker-best-practices --reviewer jane-doe --rating 5 --title "Excellent"
./core/marketplace/rate.sh summary --asset docker-best-practices
./core/marketplace/rate.sh list --asset docker-best-practices
```

## Publishing Workflow

1. Author creates the asset following the standard structure.
2. Author runs validation: `./core/quality/validate.sh <asset-path>` (run automatically on publish).
3. Author publishes: `./core/marketplace/publish.sh --type <type> --path <path> --publisher <name>`.
4. The asset appears in the registry (`./core/marketplace/publish.sh --list`).
5. Community members rate and review the asset.

## Future Enhancements

- Web-based marketplace
- Asset analytics
- Monetization options