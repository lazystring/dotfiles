vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Netrw file explorer" })

-- Move highlighted lines up/down in Visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered during half-page jumps and search navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half-page down centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half-page up centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result centered" })

-- Clipboard & register helpers
vim.keymap.set("x", "p", '"_dP', { desc = "Paste over selection without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader><space>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Quickfix and location list navigation (<C-p> reserved for Telescope find_files)
vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "[Q", "<cmd>cfirst<CR>zz", { desc = "First quickfix item" })
vim.keymap.set("n", "]Q", "<cmd>clast<CR>zz", { desc = "Last quickfix item" })
vim.keymap.set("n", "<leader>p", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })
vim.keymap.set("n", "<leader>n", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
vim.keymap.set("n", "[l", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })
vim.keymap.set("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next location list item" })

-- Search and replace word under cursor
vim.keymap.set(
  "n",
  "<leader>s",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Replace word under cursor in buffer" }
)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- Split window navigation (fixed from broken '<silent> <c-k>' lhs)
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<CR>", { silent = true, desc = "Move to above window" })
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<CR>", { silent = true, desc = "Move to below window" })
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<CR>", { silent = true, desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<CR>", { silent = true, desc = "Move to right window" })
