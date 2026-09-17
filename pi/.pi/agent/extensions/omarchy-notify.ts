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

  // Get the current working directory or path info
  async function getPathInfo(): Promise<string> {
    try {
      // Try to get the repo/worktree info from git
      const { stdout: worktreeInfo } = await execAsync(
        `git rev-parse --show-toplevel 2>/dev/null | xargs -I{} sh -c 'basename $(git -C {} rev-parse --show-toplevel 2>/dev/null) && git -C {} branch --show-current 2>/dev/null || git -C {} rev-parse --abbrev-ref HEAD 2>/dev/null' || echo ""`,
        { timeout: 3000 }
      ).catch(() => ({ stdout: "" }));
      
      const trimmed = worktreeInfo.trim();
      if (trimmed) {
        return trimmed;
      }
    } catch {
      // Fall through
    }
    
    // Fallback: use current directory name
    try {
      const { stdout } = await execAsync(`basename "$PWD"`, { timeout: 1000 });
      return stdout.trim();
    } catch {
      return "";
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

    // Get path info asynchronously
    const pathInfo = await getPathInfo();

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
    const body = pathInfo 
      ? `Färdig: ${pathInfo}${sessionInfo}` 
      : `Färdig${sessionInfo}`;

    await showOmarchyNotification(title, body);
  });
}
