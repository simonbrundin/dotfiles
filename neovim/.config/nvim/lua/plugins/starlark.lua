return {
  -- Aktivera Tilt LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tilt_ls = {
          cmd = { "tilt", "lsp", "start" },
          filetypes = { "tiltfile" },
        },
      },
    },
  },

  -- Valfritt: Treesitter (bättre än vim-syntax)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { "python" })
    end,
  },
}
