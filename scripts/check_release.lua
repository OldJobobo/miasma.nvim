local script_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
local root = vim.fn.fnamemodify(script_dir, ":h")
vim.opt.runtimepath:append(root)

local function read(path)
  local lines = vim.fn.readfile(path)
  return table.concat(lines, "\n")
end

local function trim(value)
  return vim.trim(value)
end

local version_file = trim(read(root .. "/VERSION"))
local module_version = require("miasma.version").current
local changelog = read(root .. "/CHANGELOG.md")

local failures = {}

if version_file ~= module_version then
  table.insert(
    failures,
    ("VERSION (%s) does not match lua/miasma/version.lua (%s)"):format(version_file, module_version)
  )
end

if not changelog:find("## %[" .. vim.pesc(version_file) .. "%]", 1, false) then
  table.insert(failures, ("CHANGELOG.md is missing a section for %s"):format(version_file))
end

if #failures > 0 then
  for _, failure in ipairs(failures) do
    io.stderr:write(failure .. "\n")
  end
  vim.cmd("cquit 1")
end

print(("release metadata ok for %s"):format(version_file))
vim.cmd("qall")
