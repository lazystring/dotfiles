vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.set")
require("config.remap")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local work_nvim = vim.fn.expand("~/.dotfiles-work/nvim")
local has_work = (vim.uv or vim.loop).fs_stat(work_nvim) ~= nil

require("lazy").setup({
  lockfile = has_work
      and (work_nvim .. "/lazy-lock.json")
      or (vim.fn.stdpath("config") .. "/lazy-lock.json"),
  spec = {
    -- Work-only plugin specs load first as base layer when ~/.dotfiles-work/nvim exists,
    -- allowing shared plugins/ specs to merge and override cleanly on top.
    {
      dir = work_nvim,
      name = "work",
      import = "work.plugins",
      cond = has_work,
    },
    -- Shared plugins (colors, ui, treesitter, telescope, lsp, cmp)
    { import = "plugins" },
  },
  checker = { enabled = not has_work },
})
