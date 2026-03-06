return {
  -- disabled until we resolve the correct upstream repo / auth issues
  enabled = false,
  -- avante UI for LLMs
  "gbrlsnchs/avante.nvim",
  -- load at startup so dependencies are available when avante.setup runs
  lazy = false,
  dependencies = {
    -- ensure nui is on rtp before avante creates sidebars/popups
    { "MunifTanjim/nui.nvim", lazy = false },
    -- single copilot provider (choose one). Using copilot.lua (Lua-native)
    { "zbirenbaum/copilot.lua", lazy = false },
  },
  opts = {
    provider = "copilot",
    providers = {
      copilot = {
        model = "gpt-5-mini",
      },
    },
    behaviour = {
      -- avoid Avante auto-mapping collisions; we set explicit mappings below
      auto_set_keymaps = false,
    },
  },
  config = function(_, opts)
    -- ensure lazy-loaded dependencies are on runtimepath before requiring
    -- Avoid forcing requires synchronously during plugin setup: some
    -- dependency load ordering inside Lazy can call this config before
    -- the runtimepath is fully populated. Defer the actual require/setup
    -- to the next event tick so dependencies (nui, copilot) are available.

    -- attempt to require copilot now (harmless if unavailable)
    local ok_copilot, copilot = pcall(require, "copilot")
    if ok_copilot and copilot.setup then
      -- minimal copilot.lua setup if user hasn't configured it elsewhere
      pcall(copilot.setup, {})
    end

    -- setup avante
    local ok_avante, avante = pcall(require, "avante")
    if not ok_avante then
      vim.notify("avante.nvim: could not require avante", vim.log.levels.ERROR)
      return
    end

    -- Defer avante.setup so that lazy.nvim has a chance to load dependencies
    vim.schedule(function()
      local ok_avante, avante = pcall(require, "avante")
      if not ok_avante then
        vim.notify("avante.nvim: could not require avante (delayed)", vim.log.levels.ERROR)
        return
      end

      avante.setup(opts)

      -- explicit mappings (normal + visual)
      -- Ask (normal)
      vim.keymap.set("n", "<leader>aa", function()
        vim.cmd("AvanteAsk")
      end, { desc = "Avante: Ask (LLM)", silent = true })

      -- Edit (normal)
      vim.keymap.set("n", "<leader>ae", function()
        vim.cmd("AvanteEdit")
      end, { desc = "Avante: Edit (LLM)", silent = true })

      -- Edit (visual) - run command with visual selection
      vim.keymap.set("v", "<leader>ae", ":<C-u>AvanteEdit<CR>", { desc = "Avante: Edit (visual)", silent = true })

      -- Refresh / Toggle helpers
      vim.keymap.set("n", "<leader>ar", function()
        vim.cmd("AvanteRefresh")
      end, { desc = "Avante: Refresh", silent = true })

      vim.keymap.set("n", "<leader>at", function()
        vim.cmd("AvanteToggle")
      end, { desc = "Avante: Toggle sidebar", silent = true })
    end)
  end,
}
