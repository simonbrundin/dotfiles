return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      nushell = function(_, opts)
        require("lspconfig").nushell = {
          default_config = {
            cmd = { "nu", "--lsp" },
            filetypes = { "nu" },
            root_dir = function(fname)
              return require("lspconfig.util").find_git_ancestor(fname) or vim.fn.getcwd()
            end,
            single_file_support = true,
          },
          docs = {
            description = [[
https://github.com/nushell/nushell
Nushell language server
]],
          },
        }
        require("lspconfig").nushell.setup(opts)
        return true
      end,
    },
    servers = {
      nushell = {},
    },
  },
}
