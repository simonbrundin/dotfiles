# Standards for This Work

## Agent OS Conventions

### Status Metadata
Following agent OS conventions for spec status tracking:
- Use YAML frontmatter in plan.md
- Status values: `pending`, `in_progress`, `completed`
- Optional field with `pending` as default

### File Organization
- All specs in `agent-os/specs/YYYY-MM-DD-HHMM-slug/`
- plan.md is the source of truth for status
- No separate status files (keep it simple)

## Code Standards

### Shell/Bash
From AGENTS.md:
- Use `#!/bin/bash` shebang
- Use `set -e` for error handling
- Use `[[ ]]` for conditionals
- Quote variables: `"$VAR"`
- Use `$()` for command substitution

### Performance
- Prefer `rg` over `grep` for speed
- Minimize file I/O operations
- Fail fast - exit early on errors

## Documentation Standards

### Plan.md Structure
```yaml
---
status: pending|in_progress|completed
---

# Title

## Problem Statement
Brief description of what we're solving.

## Solution Overview
High-level approach.

## Implementation Steps

### Task N: Task name
**Status:** pending|completed
- [ ] Subtask 1
- [ ] Subtask 2

## Success Criteria
Measurable outcomes.

## Notes
Additional context.
```

### Command Documentation
Commands in `opencode/.config/opencode/commands/` must include:
- Clear description
- Step-by-step execution plan
- Expected outputs
- Error handling
