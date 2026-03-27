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

local function append_style(out, style)
  if style and STYLE_KEYS[style] then
    out[style] = true
  end
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
      append_style(out, style)
    end
  end

  for style in pairs(STYLE_KEYS) do
    if spec[style] then
      out[style] = true
    end
  end

  return out
end

function M.normalize_all(groups)
  local out = {}
  for group, spec in pairs(groups) do
    out[group] = M.normalize(spec)
  end
  return out
end

function M.extend_styles(spec, styles)
  if not styles or vim.tbl_isempty(styles) then
    return spec
  end

  local out = vim.deepcopy(spec)
  for _, style in ipairs(styles) do
    append_style(out, style)
  end
  return out
end

function M.apply(groups)
  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, M.normalize(spec))
  end
end

function M.apply_normalized(groups)
  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

return M
