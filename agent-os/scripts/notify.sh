#!/bin/bash

# =============================================================================
# Agent OS Notification Helper
# Send system notifications via notify-send
# =============================================================================

notify() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"

    if command -v notify-send &>/dev/null; then
        notify-send -u "$urgency" "$title" "$message"
    fi
}

notify_input() {
    local message="$1"
    notify "OpenCode: Input Required" "$message" "normal"
}

notify_complete() {
    local message="$1"
    notify "OpenCode: Complete" "$message" "low"
}

notify_error() {
    local message="$1"
    notify "OpenCode: Error" "$message" "critical"
}
