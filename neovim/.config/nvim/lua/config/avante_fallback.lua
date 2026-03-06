local M = {}

-- Minimal fallback for avante commands/mappings. Shows a notification
-- instead of erroring when the upstream plugin is not installed.
local function notify(msg)
  vim.schedule(function()
    vim.notify(msg, vim.log.levels.WARN)
  end)
end

function M.setup()
  -- Provide a safe command that upstream plugin would normally define.
  vim.api.nvim_create_user_command("AvanteEdit", function()
    notify("Avante functionality is unavailable: avante.nvim not installed.")
  end, { range = true })

  -- Provide a visual-mode mapping as a fallback for <leader>ae (example).
  -- Respect user's leader setting by using vim.g.mapleader.
  local leader = vim.g.mapleader or "\\"
  pcall(vim.keymap.del, "v", leader .. "ae")
  vim.keymap.set("v", leader .. "ae", function()
    notify("Avante: plugin missing — use :AvanteEdit instead.")
  end, { desc = "Avante fallback: edit selection" })
end

M.setup()

return M
