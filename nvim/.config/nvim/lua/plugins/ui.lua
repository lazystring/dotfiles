local orig_vim_notify = vim.notify

return {
  -- Keybinding popup and group labels
  {
    "folke/which-key.nvim",
    event = #vim.fn.argv() > 0 and "VeryLazy" or "UIEnter",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      spec = {
        { "<leader>c", group = "Code / AI" },
        { "<leader>d", group = "Diagnostics (Trouble)" },
        { "<leader>s", group = "Search" },
      },
    },
  },

  -- Notification popups
  {
    "rcarriga/nvim-notify",
    init = function()
      vim.opt.termguicolors = true
    end,
    cmd = "Notifications",
    opts = {
      background_colour = "#000000",
    },
    config = function(_, opts)
      require("notify").setup(opts)
      if vim.notify == orig_vim_notify then
        vim.notify = require("notify")
      end
    end,
  },

  -- Diagnostic gutter icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      local signs = { text = {}, linehl = {}, numhl = {} }
      local sign = function(name, icon)
        signs.text[vim.diagnostic.severity[name]] = icon
        signs.linehl[vim.diagnostic.severity[name]] = ""
        signs.numhl[vim.diagnostic.severity[name]] = ""
      end
      sign("ERROR", "󰅚")
      sign("WARN", "󰀪")
      sign("HINT", "󰌶")
      sign("INFO", "")
      vim.diagnostic.config({ signs = signs })
    end,
  },

  -- Highlight trailing whitespace
  {
    "echasnovski/mini.trailspace",
    main = "mini.trailspace",
    dependencies = {
      "echasnovski/mini.nvim",
    },
    event = { "BufRead", "BufNewFile" },
    config = true,
  },

  -- Symbols outline (moved from <C-l> to <leader>so to avoid clobbering <C-l> window navigation)
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>so", "<cmd>SymbolsOutline<cr>", desc = "Toggle Symbols Outline" },
    },
    opts = {},
  },

  -- Diagnostics list
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>dw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>dd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>dl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>dq", "<cmd>Trouble quickfix toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },
}
