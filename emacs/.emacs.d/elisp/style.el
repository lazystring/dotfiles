;;; init.el --- Emacs configuration settings for style

;;; Commentary:
;;  This package configures the way Emacs looks.

;;; Code:

(provide 'style)

(set-face-attribute 'default nil :font "Monaco-10")

(require 'nlinum)
(defun my-nlinum-mode-hook ()
  "Hook for when linum mode is activated."
  (when nlinum-mode
    (setq-local nlinum-format
                (concat " %" (number-to-string
                             ;; Guesstimate number of buffer lines.
                             (ceiling (log (max 1 (/ (buffer-size) 80)) 10)))
                        "d  "))))

(global-nlinum-mode 1)
(add-hook 'nlinum-mode-hook #'my-nlinum-mode-hook)

(require 'nlinum-relative)
(add-hook 'prog-mode-hook 'nlinum-relative-mode)
(setq nlinum-relative-redisplay-delay 0)
(setq nlinum-relative-current-symbol "")
(setq nlinum-relative-offset 0)

(setq-default truncate-lines t)

;; In graphical mode, remove graphical elements.
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

(setq-default line-spacing 2)

(add-to-list 'load-path "~/.emacs.d/nyan-mode")
(require 'nyan-mode)
(setq-default nyan-wavy-trail t)
(nyan-mode 1)

(require 'dracula-theme)
(load-theme 'dracula t)

;;; style.el ends here
