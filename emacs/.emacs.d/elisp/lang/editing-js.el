;;; editing-js.el --- Emacs configuration settings for JavaScript

;;; Commentary:
;;  This package contains configuration settings for all things JavaScript.

;;; Code:

(require 'flycheck)
(require 'js)
(require 'rjsx-mode)

(setq js-indent-level 2)

;; For now, let's try rjsx-mode for all JavaScript-y files.
(add-to-list 'auto-mode-alist '("\\.js$" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . rjsx-mode))

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

;; Flycheck is configured to use the local ESLint configuration
;; and is enabled when entering rjsx-mode.
(add-hook 'flycheck-mode-hook 'use-eslint-from-node-modules)
(flycheck-add-mode 'javascript-eslint 'rjsx-mode)

(provide 'editing-js)

;;; editing-js.el ends here
