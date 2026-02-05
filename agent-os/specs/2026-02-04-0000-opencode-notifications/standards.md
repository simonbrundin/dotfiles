# Standards: OpenCode Notification System

## Applicable Standards

This feature follows these Agent OS standards:

### Shell Script Standards (from AGENTS.md)

```bash
#!/bin/bash
set -e
# Use [[ ]] for conditionals
# Use $() for command substitution
# Quote variables: "$VAR"
# Use snake_case for variables and functions
# local for function variables
```

### Notification Helper Script Standards

**Single Responsibility:** The notification script does one thing - send notifications.

**Graceful Degradation:** If notify-send is unavailable, the script should:
1. Check if notify-send exists
2. If not, exit silently or log to stderr
3. Never fail the calling command

**Error Handling:**
```bash
#!/bin/bash
set -e

notify() {
    if command -v notify-send &>/dev/null; then
        notify-send -u "${urgency:-normal}" "$title" "$message"
    fi
    return 0  # Never fail
}
```

### Command Documentation Standards

OpenCode command markdown files should:
1. Use consistent notification placement
2. Document when notifications are triggered
3. Use blockquotes for implementation notes
4. Keep notifications as bash code blocks for clarity

## Standards to Create

This feature will establish a new standard for notification patterns:

1. **Notification Helper Standard** - Script location, function signature, error handling
2. **Command Integration Standard** - Where to place notifications in command flow
3. **Notification Content Standard** - Title format, message format, urgency levels
