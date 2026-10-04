return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.defaults = opts.defaults or {}

      local slow_scroll = function(prompt_bufnr, direction)
        local previewer = require("telescope.actions.state").get_current_picker(prompt_bufnr).previewer
        local status = require("telescope.state").get_status(prompt_bufnr)
        if type(previewer) ~= "table" or previewer.scroll_fn == nil or status.preview_win == nil then
          return
        end
        previewer:scroll_fn(1 * direction)
      end

      local full_page_scroll = function(prompt_bufnr, direction)
        local previewer = require("telescope.actions.state").get_current_picker(prompt_bufnr).previewer
        local status = require("telescope.state").get_status(prompt_bufnr)
        if type(previewer) ~= "table" or previewer.scroll_fn == nil or status.preview_win == nil then
          return
        end
        local speed = vim.api.nvim_win_get_height(status.preview_win)
        previewer:scroll_fn(speed * direction)
      end

      local prev_path_display = opts.defaults.path_display
      return vim.tbl_deep_extend("force", opts, {
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-n>"] = function(...)
                return require("telescope.actions").cycle_history_next(...)
              end,
              ["<C-p>"] = function(...)
                return require("telescope.actions").cycle_history_prev(...)
              end,
              ["<C-f>"] = function(prompt_bufnr)
                full_page_scroll(prompt_bufnr, 1)
              end,
              ["<C-b>"] = function(prompt_bufnr)
                full_page_scroll(prompt_bufnr, -1)
              end,
              ["<C-e>"] = function(prompt_bufnr)
                slow_scroll(prompt_bufnr, 1)
              end,
              ["<C-y>"] = function(prompt_bufnr)
                slow_scroll(prompt_bufnr, -1)
              end,
              ["<C-q>"] = function(...)
                require("telescope.actions").smart_send_to_qflist(...)
                require("telescope.actions").open_qflist(...)
              end,
            },
          },
          path_display = function(path_opts, path)
            path = path:gsub("^" .. vim.env.HOME, "~")
            if type(prev_path_display) == "function" then
              path = prev_path_display(path_opts, path)
            end
            return path
          end,
        },
      })
    end,
    keys = {
      -- Prevent work overlay's { "<leader>s", desc = "Search" } from creating a lazy-load key trigger
      -- that clobbers the <leader>s search-and-replace mapping in lua/config/remap.lua.
      { "<leader>s", false },
      {
        "<C-p>",
        "<cmd>lua require('telescope.builtin').find_files{find_command = {'rg', '--files', '--color', 'never', '--hidden', '--glob', '!.git'}}<cr>",
        desc = "Search for files in current directory",
      },
      {
        "<leader>sb",
        "<cmd>lua require('telescope.builtin').buffers{}<cr>",
        desc = "Search for files in opened buffers",
      },
      {
        "<leader>sp",
        "<cmd>lua require('telescope.builtin').live_grep{additional_args = {'--hidden', '--glob', '!.git'}}<cr>",
        desc = "Search for string in files (including hidden)",
      },
      {
        "<leader>sg",
        "<cmd>lua require('telescope.builtin').live_grep{}<cr>",
        desc = "Search for string in files",
      },
      {
        "<leader>sG",
        "<cmd>lua require('telescope.builtin').grep_string{ search = vim.fn.expand('<cword>') }<cr>",
        desc = "Search for current word in files",
      },
      {
        "<leader>sh",
        "<cmd>lua require('telescope.builtin').help_tags{}<cr>",
        desc = "Search help tags",
      },
    },
  },
}
