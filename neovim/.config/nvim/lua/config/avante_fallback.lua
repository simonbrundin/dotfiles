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
-- Defer mapping until VimEnter so that user-defined <leader> is set by other configs
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    -- clear possibly stale mappings to avoid conflicts
    pcall(vim.keymap.del, "n", "<leader>aa")
    pcall(vim.keymap.del, "n", "<leader>ae")
    pcall(vim.keymap.del, "n", "<leader>at")
    pcall(vim.keymap.del, "n", "<leader>ar")
    pcall(vim.keymap.del, "v", "<leader>ae")

    -- Normal mappings
    vim.keymap.set("n", "<leader>aa", make_rhs("AvanteAsk", "Avante: Ask"), { desc = "Avante: Ask", silent = true })
    vim.keymap.set("n", "<leader>ae", make_rhs("AvanteEdit", "Avante: Edit"), { desc = "Avante: Edit", silent = true })
    vim.keymap.set("n", "<leader>at", make_rhs("AvanteToggle", "Avante: Toggle"), { desc = "Avante: Toggle", silent = true })
    vim.keymap.set("n", "<leader>ar", make_rhs("AvanteRefresh", "Avante: Refresh"), { desc = "Avante: Refresh", silent = true })

    -- Visual mapping: run AvanteEdit with the visual selection as range if available
    vim.keymap.set("v", "<leader>ae", function()
      local ok, _ = pcall(require, "avante")
      if ok then
        pcall(vim.cmd, "'<,'>AvanteEdit")
      else
        vim.notify("Avante.nvim är inte installerat eller åtkomst saknas.", vim.log.levels.WARN)
      end
    end, { desc = "Avante: Edit (visual)", silent = true })

    -- Diagnostic: write mapping state to log for debugging
    pcall(function()
      local home = os.getenv("HOME") or "."
      local cache_dir = home .. "/.cache/nvim"
      os.execute("mkdir -p " .. cache_dir)
      local log_path = cache_dir .. "/avante_mapping_debug.log"
      local f, err = io.open(log_path, "a")
      if not f then
        return
      end
      local sep = string.rep("=", 60)
      f:write(sep .. "\n")
      f:write(os.date("%Y-%m-%d %H:%M:%S") .. " - VimEnter mapping debug\n")
      f:write("vim.g.mapleader = " .. tostring(vim.g.mapleader) .. "\n")
      local nmap = vim.fn.maparg("<leader>ae", "n")
      local vmap = vim.fn.maparg("<leader>ae", "v")
      f:write("maparg (n, '<leader>ae'): " .. tostring(nmap) .. "\n")
      f:write("maparg (v, '<leader>ae'): " .. tostring(vmap) .. "\n")
      f:write("nmap list entries for lhs '<leader>ae':\n")
      for _, m in ipairs(vim.api.nvim_get_keymap('n')) do
        if m.lhs == '<leader>ae' then
          f:write(vim.inspect(m) .. "\n")
        end
      end
      f:write("vmap list entries for lhs '<leader>ae':\n")
      for _, m in ipairs(vim.api.nvim_get_keymap('v')) do
        if m.lhs == '<leader>ae' then
          f:write(vim.inspect(m) .. "\n")
        end
      end
      f:write(sep .. "\n\n")
      f:close()
    end)
  end,
})

return {}
