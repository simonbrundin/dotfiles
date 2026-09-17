import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { exec } from "node:child_process";
import { promisify } from "node:util";

const execAsync = promisify(exec);

/**
 * Omarchy notification extension for pi.
 * Shows a desktop notification when pi is done with its work.
 */
export default function (pi: ExtensionAPI) {
  // Track if we should notify (avoid duplicate notifications)
  let lastNotified: number = 0;
  const COOLDOWN_MS = 2000; // Minimum time between notifications

  // Show notification using omarchy notification system
  async function showOmarchyNotification(title: string, body: string) {
    try {
      // Use omarchy notification send with a checkmark icon
      await execAsync(
        `omarchy notification send "${title}" "${body}" -g "󰋜" -u normal`,
        { timeout: 5000 }
      );
    } catch (err) {
      // Silently fail - notifications are non-critical
      console.error("Failed to send omarchy notification:", err);
    }
  }

  // Listen for when pi is done and won't continue automatically
  pi.on("agent_settled", async (event, ctx) => {
    // Only notify in TUI mode
    if (ctx.mode !== "tui") return;

    // Cooldown to avoid spam
    const now = Date.now();
    if (now - lastNotified < COOLDOWN_MS) return;
    lastNotified = now;

    // Get session info if available
    let sessionInfo = "";
    try {
      const sessionFile = ctx.sessionManager.getSessionFile();
      if (sessionFile) {
        // Extract session name from file path
        const match = sessionFile.match(/([^/]+)\.jsonl$/);
        if (match) {
          sessionInfo = ` (${match[1]})`;
        }
      }
    } catch {
      // Ignore errors getting session info
    }

    const title = "pi klart";
    const body = `Färdig${sessionInfo}`;

    await showOmarchyNotification(title, body);
  });
}
