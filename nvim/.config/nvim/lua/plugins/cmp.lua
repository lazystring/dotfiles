local html_entities = {
  ["&lt;"] = "<",
  ["&gt;"] = ">",
  ["&amp;"] = "&",
  ["&quot;"] = '"',
  ["&apos;"] = "'",
  ["&nbsp;"] = " ",
  ["&ensp;"] = " ",
  ["&emsp;"] = " ",
}

local function decode_html_entities(text)
  text = text:gsub("&#(%d+);", function(n)
    local code = tonumber(n, 10)
    if code and code >= 32 and code <= 126 then
      return string.char(code)
    end
    return ""
  end)
  text = text:gsub("&#[xX]([%da-fA-F]+);", function(h)
    local code = tonumber(h, 16)
    if code and code >= 32 and code <= 126 then
      return string.char(code)
    end
    return ""
  end)
  return (text:gsub("&[%a]+;", html_entities))
end

local function format_javadoc_link(inner)
  inner = vim.trim(inner)
  local target, label
  if inner:find("%b()") then
    target, label = inner:match("^(.-%b())%s+(.+)$")
  else
    target, label = inner:match("^(%S+)%s+(.+)$")
  end
  local display = vim.trim(label or target or inner)
  display = display:gsub("^#", ""):gsub("([%w_$.]+)#([%w_$]+)", "%1.%2")
  return "`" .. display .. "`"
end

--- Normalizes raw Javadoc / HTML tags (emitted by Java/C++ LSPs) into clean Markdown.
---@param lines string[]
---@return string[]
local function sanitize_javadoc_markdown(lines)
  if type(lines) ~= "table" or #lines == 0 then
    return lines
  end

  local out = {}
  local in_fence = false

  for _, raw_line in ipairs(lines) do
    for _, line in ipairs(vim.split(raw_line, "\n", { plain = true })) do
      if line:match("^%s*```") then
        in_fence = not in_fence
        table.insert(out, line)
      elseif in_fence then
        table.insert(out, decode_html_entities(line))
      else
        -- Convert <pre>{@code ...}</pre> and <pre><code>...</code></pre> boundaries into code fences
        if line:match("<pre>%s*{@code%s*$") or line:match("<pre>%s*<code>%s*$") or line:match("^%s*<pre>%s*$") then
          in_fence = true
          table.insert(out, "```java")
        elseif line:match("}%s*</pre>") or line:match("</code>%s*</pre>") or line:match("</pre>") then
          in_fence = false
          table.insert(out, "```")
        else
          local s = decode_html_entities(line)

          -- Javadoc inline tags: {@code ...}, {@literal ...}, {@value ...}, {@link ...}, {@linkplain ...}
          s = s:gsub("{@code%s+([^}]+)}", function(c)
            return "`" .. vim.trim(c) .. "`"
          end)
          s = s:gsub("{@literal%s+([^}]+)}", function(c)
            return vim.trim(c)
          end)
          s = s:gsub("{@value%s+([^}]+)}", function(c)
            return "`" .. vim.trim(c) .. "`"
          end)
          s = s:gsub("{@linkplain%s+([^}]+)}", format_javadoc_link)
          s = s:gsub("{@link%s+([^}]+)}", format_javadoc_link)

          -- Inline HTML formatting tags
          s = s:gsub("<code>(.-)</code>", "`%1`")
          s = s:gsub("<tt>(.-)</tt>", "`%1`")
          s = s:gsub("<b>(.-)</b>", "**%1**")
          s = s:gsub("<strong>(.-)</strong>", "**%1**")
          s = s:gsub("<i>(.-)</i>", "*%1*")
          s = s:gsub("<em>(.-)</em>", "*%1*")
          s = s:gsub('<a%s+[^>]*href=["\'](.-)["\'][^>]*>(.-)</a>', "[%2](%1)")
          s = s:gsub("<h[1-6][^>]*>(.-)</h[1-6]>", "### %1")

          -- Block / structural HTML tags
          s = s:gsub("^%s*<p[^>]*>%s*", "\n")
          s = s:gsub("<p[^>]*>", "\n\n")
          s = s:gsub("<br%s*/?>", "\n")
          s = s:gsub("<hr%s*/?>", "\n---\n")
          s = s:gsub("^%s*<li[^>]*>%s*", "- ")
          s = s:gsub("<li[^>]*>%s*", "\n- ")
          s = s:gsub("</?%w+[^>]*>", "")

          -- Trim leading space before emphasis lines (e.g. " *public static final* `ByteString`")
          s = s:gsub("^%s+(%b**)%s+", "%1 ")

          -- Javadoc block tags (@param, @return, @throws, @author, @since, @see, @deprecated)
          s = s:gsub("^%s*@param%s+(%S+)%s+(.+)$", "- **@param** `%1` — %2")
          s = s:gsub("^%s*@param%s+(%S+)%s*$", "- **@param** `%1`")
          s = s:gsub("^%s*@throws%s+(%S+)%s+(.+)$", "- **@throws** `%1` — %2")
          s = s:gsub("^%s*@exception%s+(%S+)%s+(.+)$", "- **@throws** `%1` — %2")
          s = s:gsub("^%s*@returns?%s+(.+)$", "- **@return** %1")
          for _, tag in ipairs({ "author", "since", "see", "deprecated" }) do
            s = s:gsub("^%s*@" .. tag .. "%s+(.+)$", "- **@" .. tag .. "** %1")
          end

          for _, split_line in ipairs(vim.split(s, "\n", { plain = true })) do
            table.insert(out, split_line)
          end
        end
      end
    end
  end

  -- Collapse consecutive blank lines
  local collapsed = {}
  local prev_blank = true
  for _, l in ipairs(out) do
    local blank = l:match("^%s*$") ~= nil
    if not (blank and prev_blank) then
      table.insert(collapsed, l)
    end
    prev_blank = blank
  end
  while #collapsed > 0 and collapsed[#collapsed]:match("^%s*$") do
    table.remove(collapsed)
  end

  return collapsed
end

local source_labels = {
  nvim_lsp = "[LSP]",
  luasnip = "[Snip]",
  nvim_lua = "[Lua]",
  buffer = "[Buf]",
  path = "[Path]",
  nvim_lsp_signature_help = "[Sig]",
}

-- 16-bit BMP Unicode symbols rendered natively by Iosevka Term & urxvt (no Nerd Font required)
local unicode_kind_symbols = {
  Class = "◈",
  Color = "◉",
  Constant = "π",
  Constructor = "⊕",
  Enum = "∷",
  EnumMember = "∙",
  Event = "✦",
  Field = "▪",
  File = "▤",
  Folder = "▸",
  Function = "ƒ",
  Interface = "◇",
  Keyword = "§",
  Method = "ƒ",
  Module = "◫",
  Operator = "±",
  Property = "▫",
  Reference = "→",
  Snippet = "✂",
  Struct = "▣",
  Text = "≡",
  TypeParameter = "τ",
  Unit = "µ",
  Value = "♯",
  Variable = "α",
}

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
      "MeanderingProgrammer/render-markdown.nvim",
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
          completion = cmp.config.window.bordered({
            col_offset = -3,
            side_padding = 0,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            max_width = 80,
            max_height = 24,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None",
          }),
        },
        mapping = {
          ["<right>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          expandable_indicator = true,
        },
      })
    end,
    config = function(_, opts)
      local lspkind = require("lspkind")
      local cmp = require("cmp")

      lspkind.init({
        mode = "symbol_text",
        symbol_map = unicode_kind_symbols,
      })

      -- Hook Javadoc/HTML sanitizer into LSP markdown conversion (used by both nvim-cmp docs and K hover)
      if not vim.lsp.util._javadoc_sanitizer_installed then
        vim.lsp.util._javadoc_sanitizer_installed = true
        local orig_convert = vim.lsp.util.convert_input_to_markdown_lines
        vim.lsp.util.convert_input_to_markdown_lines = function(input, contents)
          local res = orig_convert(input, contents)
          return sanitize_javadoc_markdown(res)
        end

        -- Replace legacy regex stylize_markdown (used by nvim-cmp docs_view) with Neovim 0.11
        -- Treesitter markdown + render-markdown.nvim so code blocks and inline code stay intact.
        vim.lsp.util.stylize_markdown = function(bufnr, contents, stylize_opts)
          stylize_opts = stylize_opts or {}
          local clean = sanitize_javadoc_markdown(contents)
          local width = vim.lsp.util._make_floating_popup_size(clean, stylize_opts)
          if vim.lsp.util._normalize_markdown then
            clean = vim.lsp.util._normalize_markdown(clean, { width = width })
          end
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, clean)
          vim.treesitter.language.register("markdown", "cmp_docs")
          pcall(vim.treesitter.start, bufnr, "markdown")

          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(bufnr) then
              return
            end
            local win = vim.fn.bufwinid(bufnr)
            if win ~= -1 and vim.api.nvim_win_is_valid(win) then
              local ok, rm_ui = pcall(require, "render-markdown.core.ui")
              if ok and rm_ui and rm_ui.update then
                rm_ui.update(bufnr, win, "CmpDocs", true)
              end
            end
          end)

          return clean
        end
      end

      -- Option A formatting: Icon badge on left (`kind`), truncated name in middle (`abbr`),
      -- and explicit `<Kind> [Source]` label on right (`menu`).
      opts.formatting = opts.formatting or {}
      opts.formatting.fields = { "kind", "abbr", "menu" }
      opts.formatting.format = function(entry, vim_item)
        local kind_name = vim_item.kind or "Text"
        local symbol = unicode_kind_symbols[kind_name] or lspkind.symbolic(kind_name, { mode = "symbol" })
        if not symbol or symbol == "" then
          symbol = "≡"
        end

        if vim.fn.strdisplaywidth(vim_item.abbr or "") > 50 then
          vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, 49) .. "…"
        end

        local source_name = entry.source and entry.source.name or ""
        local source_tag = source_labels[source_name] or (source_name ~= "" and ("[" .. source_name .. "]") or "")

        vim_item.kind = " " .. symbol .. " "
        vim_item.menu = source_tag ~= "" and string.format("%s %s", kind_name, source_tag) or kind_name
        return vim_item
      end

      opts.sources = cmp.config.sources(opts.sources)
      cmp.setup(opts)
    end,
  },
}
