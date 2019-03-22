;;; editing.el --- Emacs configuration settings for editing

;;; Commentary:
;;  This package contains configuration settings for all things editing.

;;; Code:

(require 'company)
(require 'flycheck)
(require 'yasnippet)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(show-paren-mode 1)
(electric-pair-mode 1)

(setq-default indent-tabs-mode nil)
(setq tab-stop-list (number-sequence 2 120 2))

(setq-default x-select-enable-clipboard t)
(setq-default x-select-enable-primary t)
(xclip-mode 1)

(delete-selection-mode 1)

(yas-global-mode 1)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-emacs-lisp-initialize-packages t)
(setq flycheck-emacs-lisp-load-path 'inherit)
(setq flycheck-check-syntax-automatically '(mode-enabled save))

(global-company-mode 1)
(setq company-idle-delay 0)
(setq company-tooltip-align-annotations t)

(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)

(require 'editing-html)
(require 'editing-js)
(require 'editing-sh)
(require 'editing-ts)

(provide 'editing)

;;; editing.el ends here
