#!/bin/bash

# =============================================================================
# OpenCode Watch - Notify when OpenCode is waiting or complete
# Usage:
#   opencode-watch run <args>    - Run opencode and notify on complete
#   opencode-watch wait          - Send "waiting for input" notification
# =============================================================================

OPENCODE_PATH="$(which opencode)"

notify_question() {
    notify-send -u normal "OpenCode" "🔔 OpenCode väntar på dig - kolla terminalen"
}

notify_complete() {
    notify-send -u low "OpenCode" "✅ Klart! OpenCode är färdig"
}

case "$1" in
    run)
        shift
        "$OPENCODE_PATH" "$@"
        notify_complete
        ;;
    wait)
        notify_question
        echo "📨 Notifikation skickad"
        ;;
    *)
        echo "Usage: opencode-watch <run|wait> [args]"
        ;;
esac
