return {
  "prettier/vim-prettier",
  -- File types to enable vim-prettier for
  ft = {
    "markdown",
  },
  init = function()
    -- The following two options can be used together for autoformatting files
    -- on save without @format or @prettier tags
    vim.g["prettier#autoformat"] = 1
    vim.g["prettier#autoformat_require_pragma"] = 0
    -- Set prose_wrap to always, never, or preserve
    vim.g["prettier#config#prose_wrap"] = "always"
  end,
}
