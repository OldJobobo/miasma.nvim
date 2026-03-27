local util = require("miasma.util")

return function(palette)
  local modules = {
    require("miasma.groups.integrations.basic"),
    require("miasma.groups.integrations.completion"),
    require("miasma.groups.integrations.trees"),
    require("miasma.groups.integrations.ui"),
    require("miasma.groups.integrations.devtools"),
    require("miasma.groups.integrations.navigation"),
    require("miasma.groups.integrations.rendering"),
    require("miasma.groups.integrations.mini"),
    require("miasma.groups.integrations.snacks"),
  }

  local groups = {}
  for _, module in ipairs(modules) do
    groups = util.merge(groups, module(palette))
  end

  return groups
end
