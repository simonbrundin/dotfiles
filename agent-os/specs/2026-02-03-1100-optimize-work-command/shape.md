# Shaping Notes: Optimize /work Command

## Context

User identified that `/work` command is slow because it reads every spec file. With many specs, this becomes a bottleneck.

## Scope

**In Scope:**
- Add status metadata to plan.md format
- Rewrite /work to use rg for fast scanning
- Maintain backwards compatibility
- Update spec template

**Out of Scope:**
- Changing spec folder structure
- Modifying other commands
- Database or index solutions (overkill for this use case)

## Key Decisions

### 1. Status Location: YAML Frontmatter
- **Decision:** Put status in YAML frontmatter at top of plan.md
- **Rationale:** Easy to parse with rg, standard format, extensible for future metadata
- **Example:**
  ```yaml
  ---
  status: pending
  ---
  ```

### 2. Status Values
- `pending` - Not started yet
- `in_progress` - Currently being worked on
- `completed` - Done, archive

### 3. rg Search Strategy
- Search pattern: `^status: (pending|in_progress)`
- Only returns specs that need work
- Much faster than reading entire files

### 4. Backwards Compatibility
- Status field is optional
- Specs without status treated as "pending"
- Existing specs continue to work

## Technical Approach

```bash
# Fast scan with rg
rg "^status: (pending|in_progress)" agent-os/specs/*/plan.md \
  | sed 's/:.*//' \
  | xargs dirname \
  | sort -u
```

This gives us folder names of specs that need work without reading file contents.

## Risks

- **Risk:** rg might not be available on all systems
  - **Mitigation:** Fallback to slow method if rg missing
  
- **Risk:** Users forget to update status
  - **Mitigation:** Make it easy, add to template, maybe auto-update on /implement

## Success Metrics

- Performance: <100ms with 50+ specs
- Accuracy: 100% of pending specs found
- UX: Same interface, faster results
