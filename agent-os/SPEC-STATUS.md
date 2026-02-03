# Spec Status Convention

## Overview

All spec plans use YAML frontmatter to track their status. This enables fast scanning and filtering of specs.

## Format

Every `plan.md` must start with:

```yaml
---
status: pending
---
```

## Status Values

| Status | Meaning | When to Use |
|--------|---------|-------------|
| `pending` | Not started | New specs, waiting to begin |
| `in_progress` | Actively being worked on | Currently implementing |
| `completed` | Done and archived | All tasks finished |

## Backwards Compatibility

- **Optional field**: Specs without status are treated as `pending`
- **No breaking changes**: Existing specs continue to work
- **Tooling**: Commands like `/work` use `rg` for fast filtering

## Example

```yaml
---
status: in_progress
---

# Feature Implementation

## Task 1
**Status:** completed
- [x] Subtask 1
- [x] Subtask 2

## Task 2
**Status:** in_progress
- [ ] Current work
```

## Fast Scanning with rg

```bash
# Find specs needing work
rg "^status: (pending|in_progress)" agent-os/specs/*/plan.md -l

# Extract folder names
rg "^status: (pending|in_progress)" agent-os/specs/*/plan.md -l \
  | xargs -I {} dirname {}
```

## Updating Status

1. When starting work: Change to `status: in_progress`
2. When done: Change to `status: completed`
3. Commands may auto-update status during workflow
