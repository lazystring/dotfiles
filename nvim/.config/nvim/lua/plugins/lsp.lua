local is_work = (vim.uv or vim.loop).fs_stat(vim.fn.expand("~/.dotfiles-work/nvim")) ~= nil

return {
  -- Lspsaga UI for hover, definitions, code actions, and diagnostics
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "LspAttach",
    cmd = "Lspsaga",
    opts = {
      scroll_preview = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      ui = {
        border = "rounded",
      },
      code_action = {
        keys = {
          quit = { "q", "<esc>" },
        },
      },
      lightbulb = {
        enable = false,
        ignore = { ft = { "python", "cpp" } },
      },
      symbol_in_winbar = {
        respect_root = true,
      },
    },
  },

  -- Mason for personal machines (disabled when work overlay provides its own LSP)
  {
    "williamboman/mason.nvim",
    enabled = not is_work,
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = not is_work,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = true,
    },
  },

  -- Shared LSP keybindings (using Lspsaga) + personal server setup when not at work
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "LSP hover" },
      { "<leader>K", "<cmd>Lspsaga hover_doc ++keep<cr>", desc = "LSP hover (sticky)" },
      { "grn", "<cmd>Lspsaga rename ++project<cr>", desc = "Rename symbol" },
      { "gra", "<cmd>Lspsaga code_action<cr>", desc = "Code Actions", mode = { "n", "v" } },
      { "gp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
      { "gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto definition" },
      { "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Goto declaration" },
      { "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", desc = "Workspace symbol" },
      { "gY", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Goto type definition" },
      { "gy", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek type definition" },
      { "gri", "<cmd>Lspsaga finder imp<cr>", desc = "Goto implementation" },
      { "grr", "<cmd>Lspsaga finder<cr>", desc = "Show references" },
      { "<leader>o", "<cmd>Lspsaga outline<cr>", desc = "Show LSP outline" },
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Previous diagnostic" },
      { "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next diagnostic" },
      {
        "[D",
        "<cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>",
        desc = "Previous diagnostic error",
      },
      {
        "]D",
        "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>",
        desc = "Next diagnostic error",
      },
      { "<leader>sl", "<cmd>Lspsaga show_line_diagnostics ++unfocus<cr>", desc = "Show line diagnostics" },
    },
    config = not is_work and function(_, opts)
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = (opts and opts.servers) or {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        ts_ls = {},
        pyright = {},
        rust_analyzer = {},
        gopls = {},
        clangd = {},
        bashls = {},
      }
      for server_name, server_opts in pairs(servers) do
        server_opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
        if vim.lsp and vim.lsp.config then
          vim.lsp.config(server_name, server_opts)
          vim.lsp.enable(server_name)
        elseif lspconfig[server_name] then
          lspconfig[server_name].setup(server_opts)
        end
      end
    end or nil,
  },
}
