local util = require("miasma.util")

return function()
  local modules = {
    require("miasma.groups.links.core"),
    require("miasma.groups.links.treesitter"),
    require("miasma.groups.links.lsp"),
    require("miasma.groups.links.languages"),
    require("miasma.groups.links.integrations"),
  }

  local groups = {}
  for _, module in ipairs(modules) do
    groups = util.merge(groups, module())
  end

  return groups
end
