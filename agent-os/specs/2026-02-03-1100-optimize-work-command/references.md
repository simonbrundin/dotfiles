# References

## Current Implementation

### /work Command
**Location:** `/home/simon/repos/dotfiles/opencode/.config/opencode/commands/work.md`

Current approach:
1. Lists all folders in `agent-os/specs/`
2. Reads each `plan.md` to check for incomplete tasks
3. Presents options to user
4. Loads selected spec

**Problem:** Reads EVERY file, slow with many specs.

## rg (ripgrep) Documentation

### Usage Pattern
```bash
# Find specs with pending/in_progress status
rg "^status: (pending|in_progress)" agent-os/specs/*/plan.md

# Extract just folder names
rg "^status: (pending|in_progress)" agent-os/specs/*/plan.md -l
```

### Performance
- rg is line-oriented and extremely fast
- Built-in multithreading
- Respects .gitignore by default (not relevant here but good to know)

## Similar Patterns

### Fast File Scanning
Common pattern in CLI tools:
1. Use fast search tool (rg/ag) to filter files
2. Only read full contents of filtered files
3. Cache results if needed

Examples:
- `fd` + `rg` in modern CLI workflows
- Git's own internal caching
- Fuzzy finders (fzf) using rg for initial filter

## Related Files

- `agent-os/commands/agent-os/shape-spec.md` - Creates new specs
- `agent-os/commands/agent-os/plan-product.md` - Product planning
- `opencode/.config/opencode/AGENTS.md` - Workflow orchestration rules

## Tools Reference

### ripgrep (rg)
- Available on most modern systems
- Faster than grep for most use cases
- Better Unicode support
- Parallel by default

### Alternative: grep
- More universally available
- Slower for this use case
- Can use as fallback if rg unavailable
