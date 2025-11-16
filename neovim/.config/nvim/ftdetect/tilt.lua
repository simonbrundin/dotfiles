-- ~/.config/nvim/ftdetect/tilt.lua
vim.filetype.add({
  filename = {
    ["Tiltfile"] = "tiltfile",
  },
  pattern = {
    [".*[.]tiltfile$"] = "tiltfile",
  },
})
