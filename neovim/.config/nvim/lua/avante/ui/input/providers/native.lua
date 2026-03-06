-- Override of avante's native input provider to use vim.ui.input correctly.
-- The plugin's shipped implementation calls vim.ui.select with an opts table
-- which leads to `on_choice expected function, got nil`. Use vim.ui.input
-- which matches the intended behaviour for a single-line input prompt.

local M = {}

---@param input avante.ui.Input
function M.show(input)
  local opts = {
    prompt = input.title,
    default = input.default,
  }

  if input.conceal then
    vim.notify_once(
      "Native input provider doesn't support concealed input. Consider using 'dressing' or 'snacks' provider for password input.",
      vim.log.levels.WARN
    )
  end

  -- Use vim.ui.input for a simple single value submission
  vim.ui.input(opts, input.on_submit)
end

return M
