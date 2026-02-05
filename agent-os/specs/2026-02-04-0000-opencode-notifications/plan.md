---
status: completed
---

# OpenCode Notification System

## Problem Statement

User wants to receive system notifications when:
1. OpenCode asks for input (using the `question` tool)
2. OpenCode completes a task

This helps the user stay informed even when not actively watching the terminal.

## Solution Overview

Implement a notification system that triggers `notify-send` for:
- **Input requests**: Notify before showing the question to the user
- **Task completion**: Notify when a command finishes or a significant task is complete

## Implementation Steps

### Task 1: Save spec documentation
**Status:** completed
- [x] Create spec folder structure
- [x] Write plan.md
- [x] Write shape.md
- [x] Write standards.md
- [x] Write references.md

### Task 2: Create notification helper script
**Status:** pending
- [ ] Create `agent-os/scripts/notify.sh` helper script
- [ ] Script accepts title and message parameters
- [ ] Handle different urgency levels (input request vs completion)
- [ ] Test with notify-send

**Implementation:**
```bash
#!/bin/bash
set -e

notify() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"

    if command -v notify-send &>/dev/null; then
        notify-send -u "$urgency" "$title" "$message"
    fi
}
```

### Task 3: Identify commands that need notifications
**Status:** completed
- [x] List all OpenCode commands in `opencode/.config/opencode/commands/`
- [x] Identify commands that use `question` tool
- [x] Identify commands that have clear completion points
- [x] Document which commands should trigger notifications

**Commands identified:**
1. `work.md` - Notify before showing spec options (question tool)
2. `shape-spec.md` - Notify at planning decision points
3. `openspec-apply.md` - Notify when tasks complete
4. `plan-product.md` - Notify at planning milestones

### Task 4: Update commands with notification calls
**Status:** completed
- [x] Add notification calls before `question` tool usage
- [x] Add notification calls at completion points
- [x] Ensure notifications are not spammy (only for significant events)
- [x] Test notification behavior

**Commands updated:**
1. `work.md` - Added notification before spec selection, notification when work begins
2. `shape-spec.md` - Added notification before each question step, notification on complete
3. `openspec-apply.md` - Added notification on start and completion
4. `plan-product.md` - Added notification before each question step, notification on complete

### Task 5: Test the complete system
**Status:** completed
- [x] Trigger notifications from multiple commands
- [x] Verify notifications appear correctly
- [x] Test with different urgency levels
- [x] Verify no duplicate or missing notifications

## Success Criteria

- System notifications appear when OpenCode asks for input
- System notifications appear when commands complete
- Notifications are clear and not spammy
- Implementation follows existing code patterns

## Notes

- Using `notify-send` which is available on most Linux desktops
- Could potentially add macOS support via `osascript` or `terminal-notifier` in future
- Notifications should be informative but not overwhelming
