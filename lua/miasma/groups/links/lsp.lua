return function()
  return {
    DiagnosticErrorFloating = { link = "DiagnosticError" },
    DiagnosticFloatingError = { link = "DiagnosticError" },
    DiagnosticFloatingHint = { link = "DiagnosticHint" },
    DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
    DiagnosticFloatingOk = { link = "DiagnosticOk" },
    DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
    DiagnosticFloatingWarning = { link = "DiagnosticWarning" },
    DiagnosticSignOk = { link = "DiagnosticOk" },
    DiagnosticVirtualTextOk = { link = "DiagnosticOk" },
    LspCodeLens = { link = "Comment" },
    ["@lsp.type.comment"] = { link = "Comment" },
    ["@lsp.type.decorator"] = { link = "Function" },
    ["@lsp.type.enumMember"] = { link = "Constant" },
    ["@lsp.type.function"] = { link = "Function" },
    ["@lsp.type.method"] = { link = "Function" },
    ["@lsp.type.parameter"] = { link = "Identifier" },
    ["@lsp.type.property"] = { link = "Identifier" },
    ["@lsp.type.type"] = { link = "Type" },
    ["@lsp.type.variable"] = { link = "Identifier" },
  }
end
