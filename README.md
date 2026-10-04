# Dotfiles

Personal and shared configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

Designed as the **public base layer** (`~/.dotfiles`) of a two-repository "Core + Overlay" architecture:
- **`~/.dotfiles`** (public): Shared shell, Git, Tmux, Emacs, window manager, and Neovim configurations.
- **`~/.dotfiles-work`** (optional private overlay): Work-specific aliases, Git identity, VCS config, and a local `lazy.nvim` plugin overlay (`~/.dotfiles-work/nvim`). When absent on personal machines, every tool falls back cleanly to standalone open-source defaults.

---

## Repository Layout

```
~/.dotfiles/
├── bash/
│   ├── .bashrc                     # Prompt, history, completion, sources ~/.aliasrc & ~/.config/work/.aliasrc
│   ├── .profile                    # Login environment variables & PATH
│   └── .aliasrc                    # Shared aliases and shell helpers
├── bin/
│   └── .local/bin/                 # Custom utility scripts & statusbar helpers
├── dunst/
│   └── .config/dunst/dunstrc       # Notification daemon config
├── emacs/
│   └── .emacs.d/                   # Literate Emacs config (Emacs.org -> init.el); loads ~/.config/work/.emacs if present
├── fontconfig/
│   └── .config/fontconfig/         # Font rendering rules
├── git/
│   ├── .gitconfig                  # Shared Git config, global hooksPath, conditional work & personal includes
│   ├── .gitconfig.personal         # Enforces personal email inside ~/.dotfiles/ via includeIf
│   └── .githooks/pre-push          # Blocks internal URLs/strings/emails from being pushed to public remotes
├── i3/ & i3blocks/                 # i3 window manager & status bar configs
├── nvim/
│   └── .config/nvim/
│       ├── init.lua                # Bootstraps lazy.nvim; loads ~/.dotfiles-work/nvim if present + lua/plugins/
│       ├── lazy-lock.json          # Public plugin lockfile (used when ~/.dotfiles-work/nvim is absent)
│       └── lua/
│           ├── config/
│           │   ├── set.lua         # Core Neovim options & yank highlight autocmd
│           │   └── remap.lua       # Core keymaps (movement, clipboard, quickfix, split navigation)
│           └── plugins/
│               ├── colors.lua      # rose-pine colorscheme with transparent background
│               ├── ui.lua          # which-key, nvim-notify, devicons, mini.trailspace, symbols-outline, trouble
│               ├── treesitter.lua  # nvim-treesitter syntax highlighting
│               ├── telescope.lua   # Telescope fuzzy finder & mappings
│               ├── lsp.lua         # Lspsaga UI + Mason/lspconfig for personal machines
│               └── cmp.lua         # nvim-cmp + LuaSnip + lspkind completion
├── share/                          # Shared data files (~/.local/share/emoji)
├── tmux/
│   └── .tmux.conf                  # Tmux config (C-o prefix, truecolor, pane/window navigation)
├── wallpaper/                      # Desktop wallpaper
└── X/                              # X11 startup & resource files (.xinitrc, .Xresources, .xprofile)
```

---

## Quick Start

### 1. Personal Machine Setup

```bash
sudo apt-get update && sudo apt-get install -y stow neovim tmux ripgrep

git clone https://github.com/lazystring/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow bash bin dunst emacs fontconfig git i3 i3blocks nvim share tmux wallpaper X
```

### 2. Work Machine Setup (Core + Work Overlay)

Clone both `~/.dotfiles` and `~/.dotfiles-work`, stow the shared packages from `~/.dotfiles`, and stow the file-level work overlays from `~/.dotfiles-work` (`nvim` in `~/.dotfiles-work` is loaded directly by `lazy.nvim` as a local plugin rather than stowed):

```bash
git clone https://github.com/lazystring/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow bash bin emacs fontconfig git nvim share tmux

# Then stow work overlays (bash, emacs, fig, git) from ~/.dotfiles-work
```

---

## Neovim Architecture

[`nvim/.config/nvim/init.lua`](nvim/.config/nvim/init.lua) checks whether `~/.dotfiles-work/nvim` exists on disk:

- **Personal Mode (`~/.dotfiles-work/nvim` absent)**:
  - Uses `~/.config/nvim/lazy-lock.json`.
  - Enables `mason.nvim` and `mason-lspconfig.nvim` and configures standard language servers (`lua_ls`, `ts_ls`, `pyright`, `rust_analyzer`, `gopls`, `clangd`, `bashls`) in [`lua/plugins/lsp.lua`](nvim/.config/nvim/lua/plugins/lsp.lua).
  - Configures standalone `nvim-cmp` sources (`nvim_lsp`, `nvim_lua`, `luasnip`, `buffer`, `path`, `nvim_lsp_signature_help`) in [`lua/plugins/cmp.lua`](nvim/.config/nvim/lua/plugins/cmp.lua).
- **Work Mode (`~/.dotfiles-work/nvim` present)**:
  - Uses `~/.dotfiles-work/nvim/lazy-lock.json` so work-only plugins never dirty the public lockfile.
  - Loads `~/.dotfiles-work/nvim` (`work.plugins`) as the base layer before `plugins/`, merging work LSP/completion sources with shared UI, colorscheme, Lspsaga, Trouble, and Telescope preferences.

### Core Neovim Keybindings (`<Space>` Leader)

| Key | Mode | Action |
| :--- | :--- | :--- |
| `<leader>pv` | `n` | Open Netrw file explorer (`:Ex`) |
| `<C-p>` | `n` | Telescope find files (including hidden files) |
| `<leader>sb` | `n` | Telescope open buffers |
| `<leader>sp` / `<leader>sg` | `n` | Telescope live grep (hidden / standard) |
| `<leader>sG` | `n` | Telescope grep word under cursor |
| `<leader>sh` | `n` | Telescope help tags |
| `<leader>so` | `n` | Toggle Symbols Outline |
| `<leader>s` | `n` | Search and replace word under cursor in buffer |
| `<leader><space>` | `n` | Clear search highlight |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | `n` | Navigate left / below / above / right window split |
| `J` / `K` | `v` | Move selected lines down / up |
| `<C-d>` / `<C-u>` | `n` | Half-page scroll down / up (centered) |
| `n` / `N` | `n` | Next / previous search match (centered) |
| `p` | `x` | Paste over selection without overwriting yank register |
| `<leader>y` / `<leader>Y` | `n`, `v` | Yank selection / line to system clipboard (`+`) |
| `[q` / `]q` / `<C-n>` | `n` | Previous / next quickfix item |
| `<leader>p` / `<leader>n` (`[l` / `]l`) | `n` | Previous / next location list item |
| `gd` / `gp` / `gD` | `n` | Goto definition / Peek definition / Goto declaration |
| `grr` / `gri` / `grn` / `gra` | `n` | References / Implementation / Rename / Code action (Lspsaga) |
| `K` / `<leader>K` | `n` | Hover doc / Sticky hover doc (Lspsaga) |
| `<leader>o` | `n` | Toggle Lspsaga outline |
| `[d` / `]d` (`[D` / `]D`) | `n` | Previous / next diagnostic (or error) |
| `<leader>dw` / `<leader>dd` | `n` | Workspace / Document diagnostics (Trouble) |
| `<leader>dl` / `<leader>dq` | `n` | Location list / Quickfix list (Trouble) |

---

## Leak Prevention & Git Identity Isolation

[`git/.gitconfig`](git/.gitconfig) enforces two automatic guardrails:
1. **Directory-Scoped Identity**: `[include] path = ~/.gitconfig.work` applies work Git settings globally when stowed, while `[includeIf "gitdir:~/.dotfiles/"] path = ~/.gitconfig.personal` guarantees commits inside `~/.dotfiles` always use your personal email.
2. **Global Pre-Push Hook**: `core.hooksPath = ~/.githooks` runs [`git/.githooks/pre-push`](git/.githooks/pre-push) before every push to external remotes, rejecting any commit whose diff or author metadata contains internal identifiers or corporate emails.
