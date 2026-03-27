# Miasma Refactor Plan

This plan converts `miasma.nvim` from its current single-file Vim colorscheme into a modular Lua theme with explicit support for the modern Neovim highlight coverage already proven out in `retro-82.nvim`.

The goal is not to make `miasma` look like `retro-82`. The goal is to bring `miasma` up to the same level of structural completeness, plugin support, and modern capture coverage while preserving the existing foggy, muted palette and design language.

## Current State

`miasma.nvim` currently ships as a flat Vim colorscheme:

```text
miasma.nvim/
├── colors/
│   └── miasma.vim
├── README.md
└── LICENSE
```

Observed gaps relative to `retro-82.nvim`:

- `miasma` has broad baseline coverage, but many groups are still placeholder definitions with `guifg=NONE guibg=NONE guisp=NONE`.
- `miasma` relies mostly on generic links for Treesitter and semantic captures instead of explicit modern capture groups.
- `miasma` only partially covers several plugins it nominally supports.
- `miasma` has no modular architecture for adding large plugin integrations without making `colors/miasma.vim` harder to maintain.
- `README.md` describes Lua flavors and shipped extras that are not present on the current `main` branch.

## Refactor Goals

- Preserve `:colorscheme miasma`.
- Preserve the existing visual identity of `miasma`.
- Extract palette and semantics from scattered raw highlight definitions.
- Make group coverage reviewable by domain.
- Add explicit Treesitter, LSP semantic token, and plugin integration coverage.
- Replace placeholder `NONE` groups with intentional styling where appropriate.
- Add a small, defensible configuration layer.
- Keep a compatibility path while Lua parity is established.

## Coverage Delta From Retro 82

`retro-82.nvim` is the reference for feature scope, not for palette decisions.

Broad delta categories:

- Core/editor/syntax completion of existing areas
- Explicit Treesitter captures
- Explicit semantic token captures
- Completion plugin support
- File tree support
- UI/notification support
- Git/diff workflow support
- Debugging and testing workflow support
- Markdown/rendering support
- Navigation/jump support
- Large plugin ecosystems (`mini.nvim`, `snacks.nvim`)

Practical takeaway:

- `miasma` should aim for parity in supported highlight families.
- `miasma` should not copy `retro-82` line for line.
- Every new group should be mapped semantically from a Miasma palette.

## Target Architecture

```text
miasma.nvim/
├── colors/
│   ├── miasma.lua
│   └── miasma.vim                # temporary compatibility shim during migration
├── lua/
│   └── miasma/
│       ├── init.lua
│       ├── config.lua
│       ├── palette.lua
│       ├── util.lua
│       ├── compiler.lua          # optional, phase 2
│       ├── groups/
│       │   ├── editor.lua
│       │   ├── syntax.lua
│       │   ├── treesitter.lua
│       │   ├── semantic_tokens.lua
│       │   ├── lsp.lua
│       │   ├── terminal.lua
│       │   └── integrations/
│       │       ├── lazy.lua
│       │       ├── mason.lua
│       │       ├── telescope.lua
│       │       ├── which_key.lua
│       │       ├── gitsigns.lua
│       │       ├── fzf_lua.lua
│       │       ├── cmp.lua
│       │       ├── blink_cmp.lua
│       │       ├── neo_tree.lua
│       │       ├── nvim_tree.lua
│       │       ├── noice.lua
│       │       ├── notify.lua
│       │       ├── trouble.lua
│       │       ├── treesitter_context.lua
│       │       ├── rainbow_delimiters.lua
│       │       ├── ufo.lua
│       │       ├── dap.lua
│       │       ├── dap_ui.lua
│       │       ├── diffview.lua
│       │       ├── neogit.lua
│       │       ├── neotest.lua
│       │       ├── render_markdown.lua
│       │       ├── aerial.lua
│       │       ├── navic.lua
│       │       ├── flash.lua
│       │       ├── leap.lua
│       │       ├── hop.lua
│       │       ├── harpoon.lua
│       │       ├── fidget.lua
│       │       ├── alpha.lua
│       │       ├── dashboard.lua
│       │       ├── mini.lua
│       │       └── snacks.lua
│       └── extras/
│           └── ...               # optional, phase 2
├── extras/                       # optional, once actually shipped
├── README.md
└── MIASMA_REFACTOR_PLAN.md
```

## Module Ownership

### Core theme modules

- `palette.lua`
  - owns raw colors and semantic aliases
  - no highlight group definitions
- `config.lua`
  - owns user options and defaults
  - no palette decisions
- `util.lua`
  - owns helpers for merges, style normalization, and `set_hl`
- `groups/editor.lua`
  - owns UI/editor groups like `Normal`, `Visual`, `Pmenu`, `FloatBorder`, `WinBar`, `StatusLine`, search, tabs, folds, sign columns
- `groups/syntax.lua`
  - owns classic Vim syntax groups like `Comment`, `String`, `Constant`, `Type`, `Function`, `Identifier`, `Special`
- `groups/treesitter.lua`
  - owns all explicit `@...` Treesitter and markup captures
- `groups/semantic_tokens.lua`
  - owns `@lsp.type.*`, `@lsp.mod.*`, `@lsp.typemod.*`
- `groups/lsp.lua`
  - owns diagnostics, references, code lens, signature, inlay hints
- `groups/terminal.lua`
  - owns `terminal_color_*` if enabled

### Integration module rule

Each integration module owns only its plugin-specific groups.

Examples:

- `integrations/telescope.lua`
  - owns `Telescope*`
- `integrations/mason.lua`
  - owns `Mason*`
- `integrations/neo_tree.lua`
  - owns `NeoTree*`
- `integrations/mini.lua`
  - owns `Mini*`

No plugin module should redefine generic groups like `Normal`, `Comment`, or `FloatBorder`.

## Palette Extraction Plan

Create `lua/miasma/palette.lua` with two layers:

1. Raw palette
2. Semantic aliases

Suggested raw palette start:

```lua
return {
  bg = "#222222",
  bg_alt = "#1c1c1c",
  bg_edge = "#111111",
  bg_popup = "#1c1c1c",
  bg_highlight = "#43492a",
  fg = "#d7c483",
  fg_muted = "#666666",
  olive = "#78834b",
  moss = "#5f875f",
  amber = "#c9a554",
  orange = "#bb7744",
  rust = "#b36d43",
  brown = "#685742",
}
```

Suggested semantic alias layer:

- `base`
- `surface`
- `surface_alt`
- `surface_highlight`
- `text`
- `text_muted`
- `text_subtle`
- `accent_primary`
- `accent_secondary`
- `success`
- `warning`
- `error`
- `string`
- `keyword`
- `type`
- `func`
- `border`
- `selection`
- `diff_add`
- `diff_change`
- `diff_delete`

All new integration groups should consume semantic roles, not raw hex literals.

## Config Layer

Create `lua/miasma/config.lua` with conservative defaults:

```lua
{
  transparent = false,
  term_colors = true,
  styles = {
    comments = {},
    keywords = { "bold" },
    types = { "bold" },
  },
  integrations = {
    all = true,
  },
  color_overrides = {},
  highlight_overrides = {},
  compile = false,
}
```

Rules:

- Do not expose arbitrary theme knobs just because they are easy to expose.
- Add options only when they solve a real maintenance or user need.
- Keep visual defaults faithful to current Miasma.

## Phase Plan

### Phase 0: Inventory and Baseline

Deliverables:

- add a coverage checklist to this file or a follow-up matrix file
- list all current `NONE` placeholder groups in `miasma`
- list all `retro-82` highlight families that do not exist in `miasma`
- define which gaps will be supported, aliased, or intentionally skipped

Validation:

- document baseline group counts
- record representative screenshots before refactor

### Phase 1: Lua Foundation

Deliverables:

- `colors/miasma.lua`
- `lua/miasma/init.lua`
- `lua/miasma/config.lua`
- `lua/miasma/palette.lua`
- `lua/miasma/util.lua`
- `lua/miasma/groups/editor.lua`
- `lua/miasma/groups/syntax.lua`
- compatibility behavior retained for `:colorscheme miasma`

Validation:

- `nvim --headless '+colorscheme miasma' '+hi Normal' '+qall'`
- verify `Normal`, `Comment`, `String`, `Function`, `Visual`, `Pmenu`

### Phase 2: Core Placeholder Cleanup

Replace support-in-name-only groups with intentional styling.

Priority fixes from the current Vim file:

- `DiagnosticUnderlineError`
- `DiagnosticUnderlineHint`
- `DiagnosticUnderlineInfo`
- `DiagnosticUnderlineOk`
- `DiagnosticUnderlineWarn`
- `MasonError`
- `MasonHeading`
- `MasonHighlightBlockBoldSecondary`
- `MasonHighlightBlockSecondary`
- `MasonHighlightSecondary`
- `MasonWarning`

Also review placeholder-heavy families:

- `Lazy*`
- `Telescope*`
- `WhichKey*`

Exit criteria:

- any retained `NONE` group is intentional and documented by module design

### Phase 3: Treesitter and Markup Coverage

Create `groups/treesitter.lua`.

Minimum explicit capture families to add:

- `@attribute`
- `@character`
- `@character.special`
- `@comment.documentation`
- `@comment.error`
- `@comment.hint`
- `@comment.note`
- `@comment.todo`
- `@comment.warning`
- `@constant.macro`
- `@constructor.lua`
- `@diff.delta`
- `@diff.minus`
- `@diff.plus`
- `@function.call`
- `@function.macro`
- `@function.method`
- `@function.method.call`
- `@keyword.conditional`
- `@keyword.conditional.ternary`
- `@keyword.coroutine`
- `@keyword.debug`
- `@keyword.directive`
- `@keyword.directive.define`
- `@keyword.exception`
- `@keyword.function`
- `@keyword.import`
- `@keyword.modifier`
- `@keyword.operator`
- `@keyword.repeat`
- `@keyword.return`
- `@keyword.type`
- `@markup`
- `@markup.heading`
- `@markup.heading.1.markdown`
- `@markup.heading.2.markdown`
- `@markup.heading.3.markdown`
- `@markup.heading.4.markdown`
- `@markup.heading.5.markdown`
- `@markup.heading.6.markdown`
- `@markup.italic`
- `@markup.link`
- `@markup.link.label`
- `@markup.link.url`
- `@markup.list`
- `@markup.list.checked`
- `@markup.list.unchecked`
- `@markup.math`
- `@markup.quote`
- `@markup.raw`
- `@markup.strikethrough`
- `@markup.strong`
- `@module`
- `@number.float`
- `@operator`
- `@punctuation.bracket`
- `@punctuation.delimiter`
- `@punctuation.special`
- `@string.documentation`
- `@string.escape`
- `@string.regexp`
- `@string.special`
- `@string.special.path`
- `@string.special.symbol`
- `@string.special.url`
- `@tag`
- `@tag.attribute`
- `@tag.builtin`
- `@tag.delimiter`
- `@type.builtin`
- `@type.definition`
- `@variable.builtin`
- `@variable.member`
- `@variable.parameter`

Rule:

- explicit capture groups should win over generic legacy links where visual nuance matters

### Phase 4: Semantic Tokens and LSP

Create:

- `groups/semantic_tokens.lua`
- `groups/lsp.lua`

Minimum additions:

- `@lsp.mod.defaultLibrary`
- `@lsp.type.enumMember`
- `@lsp.typemod.function.builtin`
- `@lsp.typemod.function.defaultLibrary`
- `LspInlayHint`

Review and normalize:

- diagnostics
- reference highlights
- floating LSP windows
- signature active parameter
- code lens if desired

### Phase 5: Tier 1 Integrations

These are either already present in Miasma or directly adjacent to existing support.

#### `lazy.lua`

Owns:

- all `Lazy*` groups

Tasks:

- replace placeholder groups with semantic mappings
- ensure buttons, headers, dimmed text, progress, and URLs all render intentionally

#### `mason.lua`

Owns:

- all `Mason*` groups

Tasks:

- fill current placeholder secondary/error/warning groups
- align headings, blocks, muted text, highlights

#### `telescope.lua`

Owns:

- all `Telescope*` groups

Tasks:

- convert preview/results placeholder groups into real styling
- separate border/title/selection/prompt semantics clearly

#### `which_key.lua`

Owns:

- all `WhichKey*` groups

Tasks:

- ensure float, border, desc, separator, values, and groups are all intentional

#### `gitsigns.lua`

Owns:

- `GitSigns*`

Tasks:

- extend beyond add/change/delete if the plugin surface warrants it
- consider inline and preview groups later if parity is wanted

#### `fzf_lua.lua`

Owns:

- `FzfLua*`

Tasks:

- preserve existing links or convert to explicit highlights if needed

### Phase 6: Tier 2 Integrations

These are common enough to justify first-class support once the foundation is stable.

#### `cmp.lua`

Owns:

- all `CmpItem*` groups

#### `blink_cmp.lua`

Owns:

- all `BlinkCmp*` groups

#### `neo_tree.lua`

Owns:

- all `NeoTree*` groups

#### `nvim_tree.lua`

Owns:

- all `NvimTree*` groups

#### `noice.lua`

Owns:

- all `Noice*` groups

#### `notify.lua`

Owns:

- all `Notify*` groups

#### `trouble.lua`

Owns:

- all `Trouble*` groups

#### `treesitter_context.lua`

Owns:

- `TreesitterContext`
- `TreesitterContextBottom`
- `TreesitterContextLineNumber`

#### `rainbow_delimiters.lua`

Owns:

- `RainbowDelimiter*`

#### `ufo.lua`

Owns:

- `UfoFoldedEllipsis`
- `UfoFoldedFg`

Exit criteria:

- common completion, navigation tree, and UI plugins have explicit first-party support

### Phase 7: Tier 3 Integrations

These are valuable, but not on the shortest path to solid mainstream coverage.

#### Debugging

- `dap.lua`
  - owns `Dap*`
- `dap_ui.lua`
  - owns `DapUI*`

#### Git and diff workflows

- `diffview.lua`
  - owns `Diffview*`
- `neogit.lua`
  - owns `Neogit*`

#### Test workflows

- `neotest.lua`
  - owns `Neotest*`

#### Markdown and document rendering

- `render_markdown.lua`
  - owns `RenderMarkdown*`

#### Symbol and breadcrumb navigation

- `aerial.lua`
  - owns `Aerial*`
- `navic.lua`
  - owns `Navic*`

#### Motion and jump plugins

- `flash.lua`
  - owns `Flash*`
- `leap.lua`
  - owns `Leap*`
- `hop.lua`
  - owns `Hop*`

#### Misc workflow UI

- `harpoon.lua`
  - owns `Harpoon*`
- `fidget.lua`
  - owns `Fidget*`
- `alpha.lua`
  - owns `Alpha*`
- `dashboard.lua`
  - owns `Dashboard*`

### Phase 8: Tier 4 Ecosystems

These have very large highlight surfaces and should be added only after the module system is proven.

#### `mini.lua`

Owns:

- all `Mini*` groups

Notes:

- this is one of the largest support surfaces
- keep it as a single module initially, split later only if needed

#### `snacks.lua`

Owns:

- all `Snacks*` groups

Notes:

- large surface area
- likely worth support, but not before the theme architecture is stable

## Coverage Checklist

Status legend:

- `[ ]` not started
- `[-]` partially covered in current Vim theme
- `[x]` completed in Lua refactor
- `[skip]` intentionally omitted

### Foundation

- [ ] palette extraction
- [ ] semantic alias layer
- [ ] config layer
- [ ] util helpers
- [ ] Lua loader
- [ ] compatibility shim strategy
- [ ] headless validation script

### Core

- [-] editor/UI groups
- [-] syntax groups
- [-] diagnostics and references
- [ ] terminal colors

### Modern syntax coverage

- [-] Treesitter explicit captures
- [-] semantic token captures
- [-] markdown/markup specialization

### Existing Miasma integration families to finish

- [-] Lazy
- [-] Mason
- [-] Telescope
- [-] WhichKey
- [-] GitSigns
- [-] FzfLua

### New integration families from Retro 82

- [ ] nvim-cmp
- [ ] blink.cmp
- [ ] Neo-tree
- [ ] nvim-tree
- [ ] Noice
- [ ] Notify
- [ ] Trouble
- [ ] Treesitter Context
- [ ] Rainbow Delimiters
- [ ] UFO
- [ ] DAP
- [ ] dap-ui
- [ ] Diffview
- [ ] Neogit
- [ ] Neotest
- [ ] Render Markdown
- [ ] Aerial
- [ ] Navic
- [ ] Flash
- [ ] Leap
- [ ] Hop
- [ ] Harpoon
- [ ] Fidget
- [ ] Alpha
- [ ] Dashboard
- [ ] Mini.nvim
- [ ] Snacks.nvim

## Validation Plan

Add lightweight checks once Lua modules exist.

Minimum checks:

- theme loads headlessly
- theme loads with default config
- theme loads with transparent mode
- representative groups exist in each module
- no integration module crashes when the plugin is absent
- highlight overrides merge correctly

Recommended representative group assertions:

- `Normal`
- `Comment`
- `String`
- `Visual`
- `DiagnosticUnderlineError`
- `@markup.heading.1.markdown`
- `@function.call`
- `@lsp.typemod.function.builtin`
- `TelescopeBorder`
- `MasonHeader`
- `CmpItemKindFunction`
- `BlinkCmpMenu`
- `NeoTreeNormal`
- `NoiceCmdlinePopupBorder`
- `DiffviewNormal`
- `NeogitBranch`
- `RenderMarkdownH1`
- `MiniPickBorder`
- `SnacksPicker`

## Documentation Follow-Up

After parity work begins, update `README.md` to reflect actual shipped state.

Required cleanup:

- stop advertising Lua support as "coming soon" once it exists
- stop advertising extras on `main` unless `extras/` actually ships
- document the real configuration API
- document supported integrations by name
- document migration expectations if `colors/miasma.vim` becomes a shim

## Recommended Execution Order

1. Build Lua foundation and semantic palette.
2. Port existing `miasma` core groups into Lua with no visual regression.
3. Eliminate placeholder `NONE` groups in diagnostics, Mason, Lazy, and Telescope.
4. Add explicit Treesitter and semantic token coverage.
5. Finish Tier 1 integrations.
6. Add Tier 2 integrations.
7. Add Tier 3 integrations.
8. Decide whether to absorb full `Mini` and `Snacks` support.
9. Update README and validation tooling.
10. Optionally add compile caching and generated extras.

## Non-Goals

- changing Miasma into a high-contrast theme
- copying Retro 82 stylistically
- exposing a huge configuration surface
- generating extras before the core Neovim theme architecture is stable
- supporting every obscure plugin before mainstream ones are complete
