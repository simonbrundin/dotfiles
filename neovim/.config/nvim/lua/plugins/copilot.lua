-- GitHub Copilot integration with blink.cmp
-- Provides inline code completions with low latency
return {
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" },
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = {
        enabled = true,
        -- Show suggestions as ghost text (inline, no popup)
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-.>",
          accept_line = "<M-Enter>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = {
        enabled = false, -- We use blink.cmp for suggestions
      },
      filetypes = {
        -- Disable copilot for certain filetypes
        yaml = false,
        markdown = false,
        help = false,
      },
    },
  },
  -- Copilot source for blink.cmp
  {
    "CopilotC-Nvim/blink.copilot",
    -- External dependency that blink.cmp will auto-load
    -- no plugin spec needed - blink.cmp handles this automatically
  },
}
