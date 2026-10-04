return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
        dependencies = {
          {
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
          },
        },
      },
    },
    opts = function(_, opts)
      opts = opts or {}
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- When running without the work overlay, provide default personal completion sources & mappings.
      -- When running with the work overlay, it populates opts.sources/mapping/snippet first,
      -- and we merge our bordered window + formatting enhancements on top.
      if not opts.sources then
        opts.snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        }
        opts.mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        })
        opts.sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "nvim_lsp_signature_help" },
        }
      end

      return vim.tbl_deep_extend("force", opts, {
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<right>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        },
        formatting = {
          format = {
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "…",
          },
        },
      })
    end,
    config = function(_, opts)
      local lspkind = require("lspkind")
      local cmp = require("cmp")
      cmp.setup(vim.tbl_deep_extend("force", opts, {
        sources = cmp.config.sources(opts.sources),
        formatting = {
          format = lspkind.cmp_format(opts.formatting.format),
        },
      }))
    end,
  },
}
