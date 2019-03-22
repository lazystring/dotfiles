;;; editing-html.el --- Emacs configuration settings for HTML

;;; Commentary:
;;  This package contains configuration settings for all things HTML.

;;; Code:

(require 'sgml-mode)

(defun set-sgml-indent ()
  "Guess and set the indent level for HTML editing (default 2)."
  (set (make-local-variable 'sgml-basic-offset) 2)
  (sgml-guess-indent))

(add-hook 'sgml-mode-hook #'set-sgml-indent)
(add-hook 'rjsx-mode-hook #'set-sgml-indent)

(provide 'editing-html)

;;; editing-html.el ends here
