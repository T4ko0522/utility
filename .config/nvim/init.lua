-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- python
local py = vim.fn.exepath("python3")
if py == "" then
  py = vim.fn.exepath("python")
end
if py ~= "" then
  vim.g.python3_host_prog = py
  vim.g.python_host_prog = py
end
