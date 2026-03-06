-- Fallback mappings for Avante when the plugin isn't installed/accessible
-- Sets user-friendly keymaps that notify how to enable Avante instead of raising errors

local function make_rhs(cmd, friendly)
  return function()
    local ok, _ = pcall(require, "avante")
    if ok then
      -- If avante is available, run the command
      -- Use direct Ex command (no leading ':' needed for vim.cmd)
      pcall(vim.cmd, cmd)
    else
      vim.notify(
        "Avante.nvim är inte installerat eller åtkomst saknas.\n" ..
          "För att aktivera: 1) verifiera att repo finns, 2) konfigurera SSH-nyckel eller rätt HTTPS-access,\n" ..
          "och kör sedan ':Lazy sync' i Neovim. Alternativt använd en lokal fork.",
        vim.log.levels.WARN
      )
    end
  end
end

-- Install safe mappings at startup
vim.schedule(function()
  -- Normal mappings
  vim.keymap.set("n", "<leader>aa", make_rhs("AvanteAsk", "Avante: Ask"), { desc = "Avante: Ask", silent = true })
  vim.keymap.set("n", "<leader>ae", make_rhs("AvanteEdit", "Avante: Edit"), { desc = "Avante: Edit", silent = true })
  vim.keymap.set("n", "<leader>at", make_rhs("AvanteToggle", "Avante: Toggle"), { desc = "Avante: Toggle", silent = true })
  vim.keymap.set("n", "<leader>ar", make_rhs("AvanteRefresh", "Avante: Refresh"), { desc = "Avante: Refresh", silent = true })

  -- Visual mapping: run AvanteEdit with the visual selection as range if available
  vim.keymap.set("v", "<leader>ae", function()
    local ok, _ = pcall(require, "avante")
    if ok then
      -- Explicitly run the command with the visual range marks
      pcall(vim.cmd, "'<,'>AvanteEdit")
    else
      vim.notify("Avante.nvim är inte installerat eller åtkomst saknas.", vim.log.levels.WARN)
    end
  end, { desc = "Avante: Edit (visual)", silent = true })
end)

return {}
