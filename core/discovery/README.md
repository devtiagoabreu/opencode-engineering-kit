# Discovery System

The discovery system enables searching and finding assets by various criteria.

## Features

- **Search by keyword**: Find assets matching specific terms
- **Filter by category**: Browse assets by category (devops, backend, frontend, etc.)
- **Filter by tags**: Find assets with specific tags
- **Filter by compatibility**: Find assets compatible with specific platforms
- **Sort by popularity**: Sort results by usage or rating

## API

```bash
# Search for assets
./core/discovery/search.sh "docker"

# List all skills in a category
./core/discovery/list.sh --category=devops

# Find assets compatible with OpenCode
./core/discovery/list.sh --compatible=opencode
```

## Index

The discovery system maintains an index of all assets for fast searching.

## Future Enhancements

- Full-text search
- Fuzzy matching
- Relevance ranking
- Usage analytics