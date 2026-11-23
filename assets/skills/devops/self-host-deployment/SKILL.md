---
provenance:
  source: Coolify
  source_url: https://github.com/coollabsio/coolify
  license: Apache-2.0
  verified: 2026-11-23
maturity: beta
name: self-host-deployment
description: Deploy and operate applications on infrastructure you control with an explicit control-plane boundary, resource model, previews, rollbacks and backup discipline.
category: devops
version: 0.1.0
author: devtiagoabreu
tags: [self-hosting, deployment, paas, docker, rollback, backups]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - a server reachable over SSH
  - Docker Engine and a container registry
provides:
  - A responsibility boundary for self-hosted platforms
  - A deploy lifecycle checklist
  - A backup and secrets runbook outline
security:
  risk_level: low
  permissions:
    - filesystem
    - network
  audited: true
difficulty: intermediate
---

# Self-Host Deployment

## Overview

A self-hosted platform is a control plane, not a hosting provider. It coordinates builds, deployments, domains and health checks, while your servers, network and data remain your responsibility. Write that boundary down before adopting one.

## Prerequisites

- A supported Linux server with SSH access and enough CPU, memory and disk.
- Docker Engine and a reachable image registry.
- A backup destination separate from the application server.

## Usage Instructions

### 1. State the responsibility boundary

| Concern | Platform | You |
|---|---|---|
| Build and deploy orchestration | yes | configure source and target |
| Reverse proxy and certificates | yes | own DNS and ports |
| Workload servers | manages over SSH | provision and patch |
| Secrets and backups | can schedule | store, test and restore |
| OS, network, compliance | no | fully yours |

### 2. Organize resources by project and environment

Every deployable item is a resource belonging to a project and environment, running on a connected server. Use the same names in the platform, the repository and the dashboards. Separate production from previews at the environment level so credentials cannot bleed.

### 3. Standardize the build path

Prefer a reproducible build: Dockerfile or Compose file pinned in the repository. Buildpacks are convenient for simple apps; document when a project must override them. Deploy from a specific commit, not a moving tag.

### 4. Make every deploy reversible

- Enable preview deployments for pull requests.
- Retain the last known-good image.
- Require a health check before routing traffic.
- Rehearse a rollback and record the command.
- Never delete the previous image until the new one survives a full traffic cycle.

### 5. Handle secrets and encrypted state

Generate installation secrets once, store them in a protected location, and back them up. The file that encrypts stored credentials is part of your disaster recovery, not a disposable config. Reference environment variables in the platform; do not paste production values into issue trackers or chat.

### 6. Operate deliberately

Configure automatic HTTPS, restricted admin access, log retention, resource metrics and notifications. Schedule database and volume backups with a tested restore path. Restrict network access to services that do not need public exposure.

### 7. Keep an exit path

Configurations should remain standard Docker resources on your servers. If the control plane disappears, running workloads must still be manageable. Document how to export environment variables, compose files and volumes.

## Examples

### Example 1: Deploy acceptance gate

```text
[ ] Build derived from commit <sha>
[ ] Preview environment used for review
[ ] Health check passes on the target port
[ ] HTTPS certificate issued
[ ] Previous image retained and rollback rehearsed
[ ] Secrets referenced, never printed
```

### Example 2: Backup runbook outline

```text
daily: database dump + named volumes -> off-host storage
weekly: restore into isolated environment and run smoke tests
secrets: encrypted config file stored with restricted access
owner: platform team
last successful restore: 2026-11-23
```

## References

- [Coolify](https://github.com/coollabsio/coolify)
- [Coolify docs](https://coolify.io/docs/)
- Kit companions: `onpremise-deployment`, `docker-best-practices`, `ci-cd-pipeline`
