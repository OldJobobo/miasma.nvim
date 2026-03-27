local config = require("miasma.config")
local base_palette = require("miasma.palette")
local util = require("miasma.util")
local version = require("miasma.version")

local M = {}
M.VERSION = version.current

local COMPILED_PATH = vim.fs.joinpath(vim.fn.stdpath("cache"), "miasma_compiled.lua")

local function load_palette()
  local opts = config.get()
  return vim.tbl_extend("force", vim.deepcopy(base_palette), opts.color_overrides or {})
end

local function style_groups(groups, opts)
  local styled = vim.deepcopy(groups)
  local styles = opts.styles or {}
  local map = {
    comments = { "Comment" },
    keywords = { "Keyword", "Statement" },
    types = { "Type" },
  }

  for style_name, targets in pairs(map) do
    local extra = styles[style_name]
    if extra and not vim.tbl_isempty(extra) then
      for _, group in ipairs(targets) do
        if styled[group] then
          styled[group] = util.extend_styles(styled[group], extra)
        end
      end
    end
  end

  return styled
end

local function build_groups(palette)
  local opts = config.get()
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

  groups = style_groups(groups, opts)

  return util.merge(groups, opts.highlight_overrides or {})
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

local function compile_key()
  return vim.json.encode({
    version = M.VERSION,
    options = config.get(),
  })
end

local function load_compiled(key)
  local chunk = loadfile(COMPILED_PATH)
  if not chunk then
    return nil
  end

  local ok, compiled = pcall(chunk)
  if not ok or type(compiled) ~= "table" then
    return nil
  end

  if compiled.key ~= key or type(compiled.groups) ~= "table" then
    return nil
  end

  return compiled.groups
end

local function write_compiled(groups, key)
  vim.fn.mkdir(vim.fs.dirname(COMPILED_PATH), "p")

  local lines = vim.split(
    "return " .. vim.inspect({
      key = key,
      groups = groups,
    }),
    "\n",
    { plain = true }
  )

  local ok, err = pcall(vim.fn.writefile, lines, COMPILED_PATH)
  if not ok then
    return nil, err
  end

  return COMPILED_PATH
end

function M.compile()
  local palette = load_palette()
  local opts = config.get()

  if opts.transparent then
    palette.base = nil
    palette.surface = nil
  end

  local compiled = util.normalize_all(build_groups(palette))
  return write_compiled(compiled, compile_key())
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

  if opts.compile then
    local key = compile_key()
    local compiled = load_compiled(key)

    if not compiled then
      compiled = util.normalize_all(build_groups(palette))
      write_compiled(compiled, key)
    end

    util.apply_normalized(compiled)
    return
  end

  util.apply(build_groups(palette))
end

return M
