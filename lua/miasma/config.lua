local M = {}

M.defaults = {
  transparent = false,
  term_colors = true,
  compile = false,
  styles = {
    comments = {},
    keywords = { "bold" },
    types = { "bold" },
  },
  integrations = {
    all = true,
  },
  color_overrides = {},
  highlight_overrides = {},
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
end

function M.get()
  return M.options
end

return M
