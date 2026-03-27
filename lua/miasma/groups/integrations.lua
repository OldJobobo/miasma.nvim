local util = require("miasma.util")
local config = require("miasma.config")

local function enabled(name)
  local integrations = config.get().integrations or {}
  if integrations.all then
    return integrations[name] ~= false
  end

  return integrations[name] == true
end

return function(palette)
  local modules = {
    basic = require("miasma.groups.integrations.basic"),
    completion = require("miasma.groups.integrations.completion"),
    trees = require("miasma.groups.integrations.trees"),
    ui = require("miasma.groups.integrations.ui"),
    devtools = require("miasma.groups.integrations.devtools"),
    navigation = require("miasma.groups.integrations.navigation"),
    rendering = require("miasma.groups.integrations.rendering"),
    mini = require("miasma.groups.integrations.mini"),
    snacks = require("miasma.groups.integrations.snacks"),
  }

  local groups = {}
  for name, module in pairs(modules) do
    if enabled(name) then
      groups = util.merge(groups, module(palette))
    end
  end

  return groups
end
