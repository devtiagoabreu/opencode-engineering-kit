---
maturity: beta
name: {{product_name}}
description: {{one_line_description_of_saas}}
version: {{version}}
author: {{author}}
category: project
compatible:
  - opencode
  - claude-code
  - cursor
  - copilot
---

# {{product_name}} — Launch Checklist

## Usage

Use this before the first preview deploy and again before general availability. Every item needs an owner and evidence; a missing check is a finding, not a pass.

## Vertical slices

| Slice | Owner | Evidence | Status |
|---|---|---|---|
| Authentication | {{auth_owner}} | {{auth_evidence}} | {{status}} |
| Authorization / tenant isolation | {{authz_owner}} | {{authz_evidence}} | {{status}} |
| Email | {{email_owner}} | {{email_evidence}} | {{status}} |
| Background jobs | {{jobs_owner}} | {{jobs_evidence}} | {{status}} |
| Billing / entitlements | {{billing_owner}} | {{billing_evidence}} | {{status}} |
| Uploads | {{uploads_owner}} | {{uploads_evidence}} | {{status}} |
| Analytics | {{analytics_owner}} | {{analytics_evidence}} | {{status}} |

## Providers

| Provider | Purpose | Env vars | Local mode | Production owner |
|---|---|---|---|---|
| {{provider_1}} | {{purpose_1}} | {{env_1}} | {{local_1}} | {{owner_1}} |
| {{provider_2}} | {{purpose_2}} | {{env_2}} | {{local_2}} | {{owner_2}} |

## Repository readiness

- [ ] `{{instruction_file}}` lists build, test and lint commands
- [ ] Skills for common tasks are listed in `{{skills_index}}`
- [ ] Migrations and env vars have documented conventions
- [ ] A clean checkout rehearsal passed on {{rehearsal_date}}

## Data and privacy

- [ ] Tenant key present on every shared table
- [ ] RLS or equivalent policy tests pass
- [ ] Preview data classification: {{real_or_sanitized_or_schema_only}}
- [ ] Analytics event schema reviewed; no personal data by default
- [ ] Optional tracking features approved: {{opt_in_features}}

## Deployment

- [ ] Preview deploy from commit {{commit}}
- [ ] Health check passes at {{health_path}}
- [ ] HTTPS certificate issued for {{domain}}
- [ ] Rollback to {{previous_image}} rehearsed
- [ ] Backups of {{database_and_volumes}} tested on {{restore_date}}
- [ ] Secrets stored outside the repository and rotated

## Sign-off

- Remaining risks: {{remaining_risks}}
- Approved by: {{approver}}
- Next review date: {{review_date}}
