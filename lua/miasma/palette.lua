local M = {}

M.base = "#222222"
M.surface = "#1c1c1c"
M.surface_edge = "#111111"
M.surface_highlight = "#43492a"
M.shadow = "#101010"
M.shadow_through = "#151515"

M.text = "#d7c483"
M.text_bright = "#c2c2b0"
M.text_muted = "#666666"
M.text_subtle = "#444444"

M.accent_primary = "#78834b"
M.accent_secondary = "#5f875f"
M.amber = "#c9a554"
M.orange = "#bb7744"
M.warning = "#685742"
M.error = "#b36d43"

M.string = M.warning
M.keyword = M.accent_secondary
M.type = M.accent_primary
M.func = M.accent_primary
M.identifier = M.text
M.special = M.orange
M.comment = M.text_muted
M.selection = M.accent_primary
M.border = M.warning

M.diff_add = M.accent_secondary
M.diff_change = M.warning
M.diff_delete = M.error
M.diff_text = M.amber

M.reference = "#fd9720"
M.signature = "#fbec9f"
M.indent = "#242d1d"

M.bg = M.base
M.fg = M.text

return M
