return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        disable_background = true,
      })
      vim.cmd.colorscheme("rose-pine")
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

      -- Completion menu highlights (Rosé Pine palette)
      local cmp_highlights = {
        CmpItemAbbr = { fg = "#e0def4" },
        CmpItemAbbrDeprecated = { fg = "#6e6a86", strikethrough = true },
        CmpItemAbbrMatch = { fg = "#ebbcba", bold = true },
        CmpItemAbbrMatchFuzzy = { fg = "#ebbcba", bold = true },
        CmpItemMenu = { fg = "#908caa", italic = true },
        CmpItemKind = { fg = "#9ccfd8" },
        -- Types & structures (Foam)
        CmpItemKindClass = { fg = "#9ccfd8" },
        CmpItemKindInterface = { fg = "#9ccfd8" },
        CmpItemKindStruct = { fg = "#9ccfd8" },
        CmpItemKindEnum = { fg = "#9ccfd8" },
        CmpItemKindTypeParameter = { fg = "#9ccfd8" },
        CmpItemKindModule = { fg = "#9ccfd8" },
        -- Callables (Rose)
        CmpItemKindMethod = { fg = "#ebbcba" },
        CmpItemKindFunction = { fg = "#ebbcba" },
        CmpItemKindConstructor = { fg = "#ebbcba" },
        -- Fields & properties (Iris)
        CmpItemKindField = { fg = "#c4a7e7" },
        CmpItemKindProperty = { fg = "#c4a7e7" },
        CmpItemKindEnumMember = { fg = "#c4a7e7" },
        -- Variables & references (Text)
        CmpItemKindVariable = { fg = "#e0def4" },
        CmpItemKindReference = { fg = "#e0def4" },
        -- Constants & values (Gold)
        CmpItemKindConstant = { fg = "#f6c177" },
        CmpItemKindValue = { fg = "#f6c177" },
        CmpItemKindUnit = { fg = "#f6c177" },
        CmpItemKindEvent = { fg = "#f6c177" },
        -- Keywords & operators (Pine)
        CmpItemKindKeyword = { fg = "#31748f" },
        CmpItemKindOperator = { fg = "#31748f" },
        -- Snippets & files (Love / Subtle)
        CmpItemKindSnippet = { fg = "#eb6f92" },
        CmpItemKindFile = { fg = "#9ccfd8" },
        CmpItemKindFolder = { fg = "#9ccfd8" },
        CmpItemKindText = { fg = "#908caa" },
      }
      for group, hl in pairs(cmp_highlights) do
        vim.api.nvim_set_hl(0, group, hl)
      end
    end,
  },
}
