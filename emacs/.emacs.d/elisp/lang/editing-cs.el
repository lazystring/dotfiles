;;; editing-cs.el --- Emacs configuration settings for C#

;;; Commentary:
;;  This package contains configuration settings for all things C#.

;;; Code:

(require 'company)
(require 'csharp-mode)
(require 'column-marker)

(eval-after-load
    'company
  '(add-to-list 'company-backends #'company-omnisharp))

(defun my-csharp-mode-setup ()
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode)

  (setq indent-tabs-mode nil)
  (setq c-syntactic-indentation t)
  (c-set-style "ellemtel")
  (setq c-basic-offset 4)
  (setq truncate-lines t)
  (setq tab-width 4)
                                        ;csharp-mode README.md recommends this too
                                        ;(electric-pair-mode 1)       ;; Emacs 24
                                        ;(electric-pair-local-mode 1) ;; Emacs 25

  (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
  (local-set-key (kbd "C-c C-c") 'recompile))

(add-hook 'csharp-mode-hook 'my-csharp-mode-setup t)
(add-hook 'csharp-mode-hook (lambda () (interactive) (column-marker-1 80)))


(provide 'editing-cs)

;;; editing-cs.el ends here
