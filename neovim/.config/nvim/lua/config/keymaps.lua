-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- GitHub Copilot
vim.keymap.set("n", "<leader>cp", "<cmd>Copilot panel<cr>", { desc = "Open Copilot panel" })
vim.keymap.set("n", "<leader>ca", "<cmd>Copilot auth<cr>", { desc = "Authenticate with GitHub" })

vim.keymap.set("n", "<leader>kr", "<cmd>!simon kanata restart<cr>", { desc = "Restart Kanata" })

-- Markera all text i dokumentet
vim.keymap.set("n", "<leader>vv", "ggVG", { desc = "Select all text" })

-- Flytta todo och sub-todos till toppen av filen
local function move_todo_to_top()
  local current_line = vim.fn.line(".")
  local line_content = vim.fn.getline(current_line)
  if not line_content:match("^%s*- %[.%]") then
    vim.notify("Not on a todo line", vim.log.levels.WARN)
    return
  end
  -- Hitta slutet av blocket
  local base_indent = #(line_content:match("^(%s*)"))
  local end_line = current_line
  while true do
    local next_line = end_line + 1
    local next_content = vim.fn.getline(next_line)
    if next_content == "" or #(next_content:match("^(%s*)")) <= base_indent then
      break
    end
    end_line = next_line
  end
  -- Flytta blocket till toppen
  vim.cmd(":" .. current_line .. "," .. end_line .. "move 0")
  -- Flytta markören till toppen
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

vim.keymap.set("n", "<leader>mt", move_todo_to_top, { desc = "Move todo and sub-todos to top" })

-- Toggle todo och sub-todos som slutförda
local function toggle_todo_done()
  local current_line = vim.fn.line(".")
  local line_content = vim.fn.getline(current_line)
  if not line_content:match("^%s*- %[.%]") then
    vim.notify("Not on a todo line", vim.log.levels.WARN)
    return
  end
  -- Hitta blocket
  local base_indent = #(line_content:match("^(%s*)"))
  local start_line = current_line
  local end_line = current_line
  while true do
    local next_line = end_line + 1
    local next_content = vim.fn.getline(next_line)
    if next_content == "" or #(next_content:match("^(%s*)")) <= base_indent then
      break
    end
    end_line = next_line
  end
  -- Toggle varje rad i blocket
  for i = start_line, end_line do
    local content = vim.fn.getline(i)
    local status = content:match("%[(.)%]")
    if status == " " then
      content = content:gsub("%[ %]", "[X]")
    elseif status == "X" or status == "x" then
      content = content:gsub("%[" .. status .. "%]", "[ ]")
    end
    vim.fn.setline(i, content)
  end
end

vim.keymap.set("n", "<leader>tt", toggle_todo_done, { desc = "Toggle todo and sub-todos done" })

-- Flytta nuvarande rad till slutet av dokumentet och navigera tillbaka
vim.keymap.set("n", "<leader>mb", function()
  -- Spara antalet rader i filen och aktuell rad
  local total_lines = vim.fn.line("$")
  local current_line = vim.fn.line(".")
  local current_col = vim.fn.col(".")

  -- Kopiera raden
  vim.cmd("normal! yy")
  -- Ta bort raden
  vim.cmd("normal! dd")

  -- Gå till slutet av dokumentet och klistra in
  vim.cmd("normal! Gp")

  -- Beräkna ny position (efter borttagning kan den ha ändrats)
  local new_line = current_line
  if current_line > total_lines then
    -- Vi var på sista raden
    new_line = total_lines - 1
  end

  -- Hoppa tillbaka
  vim.api.nvim_win_set_cursor(0, { new_line, current_col - 1 })
end, { desc = "Move line to bottom and return" })
