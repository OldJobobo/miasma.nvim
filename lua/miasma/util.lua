local M = {}

local STYLE_KEYS = {
  bold = true,
  italic = true,
  underline = true,
  undercurl = true,
  underdouble = true,
  underdotted = true,
  underdashed = true,
  strikethrough = true,
  reverse = true,
  standout = true,
  nocombine = true,
}

function M.merge(...)
  return vim.tbl_deep_extend("force", ...)
end

function M.normalize(spec)
  if spec.link then
    return { link = spec.link }
  end

  local out = {}

  if spec.fg ~= nil then
    out.fg = spec.fg
  end
  if spec.bg ~= nil then
    out.bg = spec.bg
  end
  if spec.sp ~= nil then
    out.sp = spec.sp
  end
  if spec.blend ~= nil then
    out.blend = spec.blend
  end

  if spec.style then
    for style in string.gmatch(spec.style, "[^,]+") do
      style = vim.trim(style)
      if STYLE_KEYS[style] then
        out[style] = true
      end
    end
  end

  return out
end

function M.apply(groups)
  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, M.normalize(spec))
  end
end

return M
