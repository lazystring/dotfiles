;;; editing-ts.el --- Emacs configuration settings for TypeScript

;;; Commentary:
;;  This package contains configuration settings for all things Typescript.

;;; Code:

(require 'tide)

(add-hook 'typescript-mode-hook
          (lambda ()
            (tide-setup)
            (eldoc-mode 1)
            (tide-hl-identifier-mode 1)))

(provide 'editing-ts)

;;; editing-ts.el ends here
