---
name: code-knowledge-graph
description: Turn any folder of code, SQL schemas, docs or images into a queryable knowledge graph for coding agents using Graphify
category: tools
version: 0.1.0
author: OpenCode Community
tags: [graph, knowledge-graph, codebase, graphify, llm, analysis]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Node.js 18+ and npm/npx
  - Network access to fetch the Graphify package
provides:
  - Queryable knowledge graph of a codebase
  - Natural-language queries over code, SQL schemas and docs
  - Reduced tokens to describe a codebase to an LLM
---

# Code Knowledge Graph (Graphify)

## Overview

This skill uses [Graphify](https://github.com/Graphify-Labs/graphify) to turn a
folder of code, SQL schemas, scripts, docs, papers, images or videos into a
queryable knowledge graph for coding agents. Instead of dumping an entire
codebase into context, you build a graph once and then query only the nodes you
need — cutting the tokens required to describe the project by an order of
magnitude while improving accuracy.

Graphify is compatible with Claude Code, Codex, OpenCode, Cursor, Gemini CLI
and more, and can combine application code, database schema and infrastructure
in a single graph.

## Prerequisites

- Node.js 18+ with npm/npx
- A folder containing the code, schema or docs you want to index
- (Optional) a database to store large graphs — Graphify ships an embedded
  option for small projects

## Usage Instructions

### 1. Install Graphify

```bash
npm install -g @graphify-labs/graphify
```

Verify:

```bash
graphify --version
```

### 2. Build a graph from a project

```bash
cd /path/to/your/project
graphify build --input . --output ./graph
```

For larger projects you can scope the input (code only, SQL only, docs only):

```bash
graphify build --input ./src --input ./schema.sql --output ./graph
```

### 3. Query the graph

```bash
# List nodes
graphify query --graph ./graph "list all API endpoints"

# Find related files for a feature
graphify query --graph ./graph "which files implement authentication?"

# Explore dependencies
graphify query --graph ./graph "what depends on the database layer?"
```

### 4. Use the graph with a coding agent

Expose the graph to the agent so it queries on demand instead of reading whole
files. In OpenCode, reference the query commands as part of your workflow or
skills — the agent runs a query, gets only the relevant nodes, and keeps its
context small.

### 5. Best practices

- **Build once, refresh when code changes**: keep the graph updated in CI.
- **Scope inputs**: index only the folders that matter; exclude tests and
  generated code to keep the graph lean.
- **Query before reading**: always ask the graph for the specific symbols,
  endpoints or schema relevant to the task before opening files.
- **Combine with the resolver**: this kit's `core/resolver` dependency graph
  complements Graphify's code graph for asset-level dependencies.

## Examples

### Example 1: Index a backend and find the auth flow

```bash
graphify build --input . --output ./graph --exclude node_modules,dist
graphify query --graph ./graph "trace the login flow from route to database"
```

### Example 2: Index SQL schema for a data question

```bash
graphify build --input ./migrations --output ./schema-graph
graphify query --graph ./schema-graph "which tables reference users?"
```

### Example 3: Document-only knowledge base

```bash
graphify build --input ./docs --output ./docs-graph
graphify query --graph ./docs-graph "how do we deploy to production?"
```

## References

- [Graphify repository](https://github.com/Graphify-Labs/graphify)
- [Understand-Anything (alternative interactive graph)](https://github.com/Egonex-AI/Understand-Anything)

## Notes

- Graphify stores the graph locally; no code leaves your machine unless you
  choose a remote store.
- Build times scale with input size — use `--exclude` for generated folders.
- Graph queries return node summaries, not full files; fetch a file only when
  the node points to it as relevant.
