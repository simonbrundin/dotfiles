# Shaping Notes: OpenCode Notification System

## Context

User identified a need for notifications when OpenCode requires attention:
1. When OpenCode asks for user input (via the `question` tool)
2. When OpenCode completes a task or command

This is a quality-of-life improvement to help the user stay informed without constantly watching the terminal.

## Scope

**In Scope:**
- Create notification helper script
- Integrate notifications into relevant OpenCode commands
- Use system notifications via `notify-send`
- Handle different notification types (input request, completion)

**Out of Scope:**
- macOS support (could be added later)
- Notification persistence or history
- Complex notification configuration
- Modifying OpenCode tool internals

## Key Decisions

### 1. Notification Mechanism: notify-send
- **Decision:** Use `notify-send` command for system notifications
- **Rationale:** Available on most Linux desktops, simple to use, integrates with Hyprland/mako
- **Alternative considered:** Terminal bell (too subtle), custom notification server (overkill)

### 2. Integration Strategy: Command-level injection
- **Decision:** Modify OpenCode command markdown files to include notification calls
- **Rationale:** Commands are already markdown files that OpenCode reads, easy to modify
- **Alternative considered:** Hook into OpenCode tool itself (not possible without modifying OpenCode)
- **Implementation:** Add bash script calls before `question` tool and at completion points

### 3. Notification Categories
- **Input Request:** Medium urgency, includes "Waiting for input..."
- **Task Completion:** Low urgency, includes brief summary
- **Error/Failure:** High urgency (optional, for errors)

### 4. Script Location
- **Decision:** Create `agent-os/scripts/notify.sh`
- **Rationale:** Reusable across commands, keeps notification logic centralized
- **Pattern:** Follow existing script conventions from `agent-os/scripts/`

## Technical Approach

### Notification Helper Script

```bash
#!/bin/bash
# agent-os/scripts/notify.sh

notify() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"

    notify-send -u "$urgency" "$title" "$message"
}

# Usage examples:
# notify "OpenCode Input Required" "Waiting for your selection..."
# notify "OpenCode Task Complete" "Spec optimization finished" "low"
```

### Command Integration Pattern

In command markdown files, add notification calls before `question` tool:

```markdown
## Step 4: Present Options to User

> [!NOTE]
> Before showing the question, trigger notification:
> ```bash
> notify-send -u normal "OpenCode Input Required" "Select which spec to work on"
> ```

Use the **question** tool to ask the user which spec to work on:
```

At completion points:

```markdown
## Step 6: Begin Work

After user confirms, set the current working context and notify completion:

```bash
notify-send -u low "OpenCode" "Started working on: $spec_name"
```
```

## Risks

- **Risk:** Notifications may be too frequent
  - **Mitigation:** Only notify on major events, not every action
  - **Mitigation:** Allow user to disable if needed (future)

- **Risk:** notify-send may not be available
  - **Mitigation:** Check if notify-send exists before calling
  - **Mitigation:** Graceful fallback (log only, or skip)

- **Risk:** Notification content may be unclear
  - **Mitigation:** Use consistent, informative titles and messages
  - **Mitigation:** Include relevant context (spec name, command name)

## Success Metrics

- Notifications appear within 1 second of triggering
- User can identify what OpenCode needs from the notification
- No more than 2-3 notifications per command session
- Works consistently across different OpenCode commands
