local colors = require("miasma.palette")

return {
  normal = {
    a = { bg = colors.accent_primary, fg = colors.surface_edge, gui = "bold" },
    b = { bg = colors.surface, fg = colors.text },
    c = { bg = colors.base, fg = colors.text },
  },
  insert = {
    a = { bg = colors.accent_secondary, fg = colors.surface_edge, gui = "bold" },
    b = { bg = colors.surface, fg = colors.text },
    c = { bg = colors.base, fg = colors.text },
  },
  visual = {
    a = { bg = colors.amber, fg = colors.surface_edge, gui = "bold" },
    b = { bg = colors.surface, fg = colors.text },
    c = { bg = colors.base, fg = colors.text },
  },
  replace = {
    a = { bg = colors.error, fg = colors.surface_edge, gui = "bold" },
    b = { bg = colors.surface, fg = colors.text },
    c = { bg = colors.base, fg = colors.text },
  },
  command = {
    a = { bg = colors.orange, fg = colors.surface_edge, gui = "bold" },
    b = { bg = colors.surface, fg = colors.text },
    c = { bg = colors.base, fg = colors.text },
  },
  terminal = {
    a = { bg = colors.warning, fg = colors.surface_edge, gui = "bold" },
    b = { bg = colors.surface, fg = colors.text },
    c = { bg = colors.base, fg = colors.text },
  },
  inactive = {
    a = { bg = colors.base, fg = colors.text_muted, gui = "bold" },
    b = { bg = colors.base, fg = colors.text_muted },
    c = { bg = colors.base, fg = colors.text_muted },
  },
}
