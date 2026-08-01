-- GitHub Copilot integration with blink.cmp
-- Uses: zbirenbaum/copilot.lua + fang2hou/blink-copilot
return {
  -- Copilot.lua as the backend
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false }, -- We use blink.cmp instead
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  -- blink-copilot as the blink.cmp source
  {
    "fang2hou/blink-copilot",
    enabled = true,
  },
}
