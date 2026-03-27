return function(palette)
  return {
    RenderMarkdownBullet = { fg = palette.accent_secondary },
    RenderMarkdownCode = { bg = palette.surface },
    RenderMarkdownCodeInline = { bg = palette.surface },
    RenderMarkdownError = { fg = palette.error },
    RenderMarkdownH1 = { fg = palette.error, style = "bold" },
    RenderMarkdownH2 = { fg = palette.orange, style = "bold" },
    RenderMarkdownH3 = { fg = palette.amber, style = "bold" },
    RenderMarkdownH4 = { fg = palette.accent_primary, style = "bold" },
    RenderMarkdownH5 = { fg = palette.accent_secondary, style = "bold" },
    RenderMarkdownH6 = { fg = palette.text, style = "bold" },
    RenderMarkdownHint = { fg = palette.accent_primary },
    RenderMarkdownInfo = { fg = palette.accent_secondary },
    RenderMarkdownSuccess = { fg = palette.accent_primary },
    RenderMarkdownTableHead = { fg = palette.accent_secondary, style = "bold" },
    RenderMarkdownTableRow = { fg = palette.text },
    RenderMarkdownWarn = { fg = palette.amber },
  }
end
