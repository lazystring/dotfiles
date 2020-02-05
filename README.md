# Dotfiles

This my collection of configuration files (dotfiles).

## Installation

These files can be installed on any system by creating symbolic links using [GNU stow](https://www.gnu.org/software/stow/).

```bash
$ git clone git@github.com:lazystring/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
$ stow bash/ i3/ bin/ # ... and other subdirectories
```

## Dependencies
(I'll add more as I think of them)

- **Dunst**: A notification daemon.
- **i3**: A tiling window manager.
- **i3blocks**: A scheduler for status line scripts.
- **PulseAudio**: A general purpose sound server.
- **st**: A simple terminal implementation for X.
- **emacs**: A text editor.
- **feh**: A lightweight image viewer and desktop wallpaper manager.
- **i3lock**: A simple screen locker.
- **w3m**: A terminal based web browser (for ranger image previews).
- **dwm**: A dynamic window manager for X.
