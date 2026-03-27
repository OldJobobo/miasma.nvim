local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:append(root)

local checks = {
  "Normal",
  "DiagnosticUnderlineError",
  "@markup.heading.1.markdown",
  "@lsp.typemod.function.builtin",
  "CmpItemKindFunction",
  "NeoTreeNormal",
  "NoiceCmdlinePopupBorder",
  "DapUIFloatBorder",
  "NeogitBranch",
  "FlashLabel",
  "RenderMarkdownH1",
  "MiniPickBorder",
  "SnacksPicker",
}

vim.cmd.colorscheme("miasma")

local failed = false

for _, name in ipairs(checks) do
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok or vim.tbl_isempty(hl) then
    failed = true
    io.stderr:write(("missing highlight: %s\n"):format(name))
  else
    print(name .. " ok")
  end
end

if failed then
  vim.cmd("cquit 1")
else
  vim.cmd("qall")
end
