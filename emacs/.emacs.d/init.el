;;; init.el --- Emacs startup configuration

;;; Commentary:
;;  This package is loaded on Emacs startup, and configures
;;  Emacs to my liking.

;;; Code:

(provide 'init)

(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(add-to-list 'load-path "~/.emacs.d/elisp/")
(load-library "general")
(load-library "style")
(load-library "editing")

(custom-set-variables
 '(package-selected-packages
   (quote
    (json-mode company tide auto-complete nlinum-relative nlinum yasnippet-snippets dracula-theme yasnippet paredit atom-one-dark-theme web-mode flycheck nyan-mode rjsx-mode projectile markdown-mode expand-region typescript-mode xclip))))
(custom-set-faces)

;;; init.el ends here
