return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = "TSUpdate",
    lazy = false,
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
        "diff",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = false },
    },
    config = function(_, opts)
      if not pcall(function()
        require("nvim-treesitter.configs").setup(opts)
      end) then
        require("nvim-treesitter").setup(opts)
      end
    end,
  },
}
