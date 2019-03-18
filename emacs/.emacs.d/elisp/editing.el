;;; editing.el --- Emacs configuration settings for editing

;;; Commentary:
;;  This package contains configuration settings for all things editing.

;;; Code:

(provide 'editing)

;; General editing
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(show-paren-mode 1)
(electric-pair-mode 1)

(setq-default indent-tabs-mode nil)
(setq tab-stop-list (number-sequence 2 120 2))

(setq-default x-select-enable-clipboard t)
(setq-default x-select-enable-primary t)
(xclip-mode 1)

(delete-selection-mode 1)

;; Code snippets
(require 'yasnippet)
(yas-global-mode 1)
(add-hook 'prog-mode-hook #'yas-minor-mode)

;; Shell script editing
(setq-default sh-basic-offset 2)

;; Flycheck configuration
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-emacs-lisp-initialize-packages t)
(setq flycheck-emacs-lisp-load-path 'inherit)
(setq flycheck-check-syntax-automatically '(mode-enabled save))

;; JavaScript editing
(add-to-list 'auto-mode-alist '("\\.js$" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . rjsx-mode))

(require 'rjsx-mode)
(require 'tide)

(require 'company)
(global-company-mode 1)
(setq company-idle-delay 0)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)

(setq js-indent-level 2)

(defun setup-tide-mode ()
  "Set up tide mode."
  (interactive)
  (tide-setup)
  (flycheck-mode 1)
  (eldoc-mode 1)
  (tide-hl-identifier-mode 1))

(setq company-tooltip-align-annotations t)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

(defun use-eslint-from-node-modules ()
  "Search parent node_modules for a version of ESLint to use."
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root (expand-file-name
                            "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(add-hook 'rjsx-mode-hook (lambda () (setup-tide-mode)))

(add-hook 'flycheck-mode-hook 'use-eslint-from-node-modules)
(flycheck-add-mode 'javascript-eslint 'rjsx-mode)
(flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)

;; HTML editing
(defun set-sgml-indent ()
  "Guess and set the indent level for HTML editing (default 2)."
  (set (make-local-variable 'sgml-basic-offset) 2)
  (sgml-guess-indent))

(add-hook 'rjsx-mode-hook 'set-sgml-indent)


;;; editing.el ends here
