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
(add-to-list 'load-path "~/.emacs.d/elisp/lang/")

(require 'general)
(require 'editing)
(require 'style)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yaml-mode haskell-mode omnisharp csharp-mode emojify json-mode company tide auto-complete nlinum-relative nlinum yasnippet-snippets dracula-theme yasnippet paredit atom-one-dark-theme web-mode flycheck nyan-mode rjsx-mode projectile markdown-mode expand-region typescript-mode xclip)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
