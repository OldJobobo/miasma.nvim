local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:append(root)
vim.env.XDG_CACHE_HOME = "/tmp"

local failed = false

local function fail(message)
  failed = true
  io.stderr:write(message .. "\n")
end

local function get(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok or vim.tbl_isempty(hl) then
    fail(("missing highlight: %s"):format(name))
    return nil
  end

  print(name .. " ok")
  return hl
end

local function assert_equal(actual, expected, label)
  if actual ~= expected then
    fail(("%s: expected %s, got %s"):format(label, vim.inspect(expected), vim.inspect(actual)))
  end
end

local compiled_path = vim.fs.joinpath(vim.fn.stdpath("cache"), "miasma_compiled.lua")
pcall(vim.fn.delete, compiled_path)

require("miasma").setup({
  compile = true,
  styles = {
    comments = { "italic" },
    keywords = { "bold", "italic" },
    types = { "bold", "italic" },
  },
  integrations = {
    all = false,
    basic = true,
  },
})

vim.cmd.colorscheme("miasma")

local checks = {
  "Normal",
  "DiagnosticUnderlineError",
  "@markup.heading.1.markdown",
  "@lsp.typemod.function.builtin",
  "@lsp.typemod.variable.readonly",
  "TelescopeBorder",
  "htmlItalic",
  "markdownItalic",
  "DiagnosticWarning",
  "DiagnosticWarn",
}

for _, name in ipairs(checks) do
  get(name)
end

local comment = get("Comment")
if comment then
  assert_equal(comment.italic, true, "Comment should pick up configured italic style")
end

local keyword = get("Keyword")
if keyword then
  assert_equal(keyword.bold, true, "Keyword should remain bold")
  assert_equal(keyword.italic, true, "Keyword should pick up configured italic style")
end

local html_italic = get("htmlItalic")
if html_italic then
  assert_equal(html_italic.italic, true, "htmlItalic should be italic")
end

local markdown_italic = get("markdownItalic")
if markdown_italic then
  assert_equal(markdown_italic.italic, true, "markdownItalic should be italic")
end

local diagnostic_warn = get("DiagnosticWarn")
local diagnostic_warning = get("DiagnosticWarning")
local diagnostic_warning_floating = get("DiagnosticWarningFloating")
if diagnostic_warn and diagnostic_warning and diagnostic_warning_floating then
  assert_equal(diagnostic_warning.fg, diagnostic_warn.fg, "DiagnosticWarning should match DiagnosticWarn")
  assert_equal(diagnostic_warning_floating.fg, diagnostic_warn.fg, "DiagnosticWarningFloating should match DiagnosticWarn")
end

local ctor = get("@constructor.lua")
local special = get("Special")
if ctor and special then
  assert_equal(ctor.fg, special.fg, "@constructor.lua should align with Special")
end

local ruby_instance = get("rubyInstanceVariable")
local identifier = get("Identifier")
if ruby_instance and identifier then
  assert_equal(ruby_instance.fg, identifier.fg, "rubyInstanceVariable should align with Identifier")
end

local neotree = vim.api.nvim_get_hl(0, { name = "NeoTreeNormal", create = false, link = false })
if not vim.tbl_isempty(neotree) then
  fail("NeoTreeNormal should not be defined when tree integrations are disabled")
end

local cmp = vim.api.nvim_get_hl(0, { name = "CmpItemKindFunction", create = false, link = false })
if not vim.tbl_isempty(cmp) then
  fail("CmpItemKindFunction should not be defined when completion integrations are disabled")
end

if vim.fn.filereadable(compiled_path) ~= 1 then
  fail("compiled theme cache was not written")
end

if failed then
  vim.cmd("cquit 1")
else
  vim.cmd("qall")
end
