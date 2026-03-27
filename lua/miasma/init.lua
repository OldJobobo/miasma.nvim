local config = require("miasma.config")
local base_palette = require("miasma.palette")
local util = require("miasma.util")
local version = require("miasma.version")

local M = {}
M.VERSION = version.current

local function load_palette()
  local opts = config.get()
  return vim.tbl_extend("force", vim.deepcopy(base_palette), opts.color_overrides or {})
end

local function build_groups(palette)
  local groups = {}
  local modules = {
    require("miasma.groups.editor"),
    require("miasma.groups.syntax"),
    require("miasma.groups.lsp"),
    require("miasma.groups.treesitter"),
    require("miasma.groups.semantic_tokens"),
    require("miasma.groups.integrations"),
    require("miasma.groups.links"),
  }

  for _, module in ipairs(modules) do
    groups = util.merge(groups, module(palette))
  end

  return util.merge(groups, config.get().highlight_overrides or {})
end

local function apply_terminal_colors(palette)
  vim.g.terminal_color_0 = palette.surface_edge
  vim.g.terminal_color_1 = palette.error
  vim.g.terminal_color_2 = palette.accent_secondary
  vim.g.terminal_color_3 = palette.amber
  vim.g.terminal_color_4 = palette.accent_primary
  vim.g.terminal_color_5 = palette.orange
  vim.g.terminal_color_6 = palette.text
  vim.g.terminal_color_7 = palette.text
  vim.g.terminal_color_8 = palette.text_muted
  vim.g.terminal_color_9 = palette.error
  vim.g.terminal_color_10 = palette.accent_secondary
  vim.g.terminal_color_11 = palette.amber
  vim.g.terminal_color_12 = palette.accent_primary
  vim.g.terminal_color_13 = palette.orange
  vim.g.terminal_color_14 = palette.text_bright
  vim.g.terminal_color_15 = palette.text_bright
end

function M.setup(opts)
  config.setup(opts)
end

function M.version()
  return M.VERSION
end

function M.load()
  local opts = config.get()
  local palette = load_palette()

  if opts.transparent then
    palette.base = nil
    palette.surface = nil
  end

  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.background = "dark"
  vim.g.colors_name = "miasma"

  if opts.term_colors then
    apply_terminal_colors(palette)
  end

  util.apply(build_groups(palette))
end

return M
