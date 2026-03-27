# miasma.nvim ☁️

a color scheme for `{neo,}vim` inspired by the woods.

the current `main` branch now ships a modular lua theme for neovim, with a vimscript compatibility shim for `:colorscheme miasma`.

supports modern treesitter captures, semantic tokens, lsp diagnostics, lualine, telescope, lazy, mason, which-key, gitsigns, cmp, neo-tree, nvim-tree, noice, notify, trouble, rainbow delimiters, treesitter-context, and more.

![theme preview](https://raw.githubusercontent.com/xero/miasma.nvim/main/preview.png)
```
┏┏┓o┳━┓┓━┓┏┏┓┳━┓
┃┃┃┃┃━┫┗━┓┃┃┃┃━┫
┛ ┇┇┛ ┇━━┛┛ ┇┛ ┇
```
a fog descends upon your editor
https://github.com/xero/miasma.nvim

## structure

`main` contains the shipped lua theme:

* `colors/miasma.lua` - neovim colorscheme entrypoint
* `lua/miasma/` - palette, config, loader, and highlight modules
* `colors/miasma.vim` - compatibility shim for neovim and fallback legacy vim definitions

## installation

using `lazy`

```lua
{
  "xero/miasma.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme miasma")
  end,
}
```

with `lualine.nvim`, keep `theme = "auto"` to use the bundled `miasma` lualine theme automatically:

```lua
require("lualine").setup({
  options = {
    theme = "auto",
  },
})
```

using `plug`

```vim
Plug 'xero/miasma.nvim'
colorscheme miasma
```

using `packer`

```lua
use {"xero/miasma.nvim"}
vim.cmd("colorscheme miasma")
```

## usage

set the color scheme with the builtin command `:colorscheme`

the plugin also exposes its shipped version in lua:

```lua
print(require("miasma").version())
```

## customization

the lua theme exposes a small configuration layer:

```lua
require("miasma").setup({
  transparent = false,
  term_colors = true,
  color_overrides = {},
  highlight_overrides = {},
})
vim.cmd("colorscheme miasma")
```

the refactor plan and implementation checklist live in `MIASMA_REFACTOR_PLAN.md`.

## extras

terminal and app extras are planned, but are not currently shipped on this branch.

## versioning

releases now use semantic versioning.

* the canonical repo version lives in `VERSION`
* lua consumers can read it from `require("miasma").VERSION` or `require("miasma").version()`
* release notes live in `CHANGELOG.md`
* before tagging, verify release metadata with:

```sh
nvim --headless -u NONE -c "luafile scripts/check_release.lua"
```

for the next release, update `VERSION`, add a matching section to `CHANGELOG.md`, then create a git tag like `v0.1.1`.

# license

![kopimi logo](https://gist.githubusercontent.com/xero/cbcd5c38b695004c848b73e5c1c0c779/raw/6b32899b0af238b17383d7a878a69a076139e72d/kopimi-sm.png)

all files and scripts in this repo are released [CC0](https://creativecommons.org/publicdomain/zero/1.0/) / [kopimi](https://kopimi.com)! in the spirit of _freedom of information_, i encourage you to fork, modify, change, share, or do whatever you like with this project! `^c^v`
