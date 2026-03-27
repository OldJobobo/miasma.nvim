local config = require("miasma.config")
local util = require("miasma.util")

local function enabled(name)
  local integrations = config.get().integrations or {}
  if integrations.all then
    return integrations[name] ~= false
  end

  return integrations[name] == true
end

return function()
  local groups = {}

  if enabled("basic") then
    groups = util.merge(groups, {
      FzfLuaBorder = { link = "Normal" },
      FzfLuaCursor = { link = "Cursor" },
      FzfLuaCursorLine = { link = "CursorLine" },
      FzfLuaCursorLineNr = { link = "CursorLineNr" },
      FzfLuaNormal = { link = "Normal" },
      FzfLuaScrollFloatEmpty = { link = "PmenuSbar" },
      FzfLuaScrollFloatFull = { link = "PmenuThumb" },
      FzfLuaSearch = { link = "IncSearch" },
      MasonHeaderSecondary = { link = "LazyButtonActive" },
      MasonHighlightBlockBold = { link = "LazyButtonActive" },
      MasonHighlightBlock = { link = "LazyButtonActive" },
      MasonMutedBlockBold = { link = "MasonHighlight" },
      MasonMutedBlock = { link = "MasonMuted" },
      TelescopeMatching = { link = "Special" },
      TelescopePreviewBorder = { link = "TelescopeBorder" },
      TelescopePreviewLine = { link = "TelescopeSelection" },
      TelescopePreviewTitle = { link = "TelescopeTitle" },
      TelescopePromptCounter = { link = "TelescopeBorder" },
      TelescopePromptPrefix = { link = "TelescopeTitle" },
      TelescopePromptTitle = { link = "TelescopeTitle" },
      TelescopeResultsBorder = { link = "TelescopeBorder" },
      TelescopeResultsFileIcon = { link = "Special" },
      TelescopeResultsTitle = { link = "TelescopeTitle" },
      TelescopeSelection = { link = "Visual" },
    })
  end

  return groups
end
