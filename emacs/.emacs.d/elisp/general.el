;;; general.el --- General configuration settings for Emacs

;;; Commentary:
;;  This files contains "general" configuration settings for
;;  Emacs startup.

;;; Code:

(provide 'general)

(setq large-file-warning-threshold nil)

(setq inhibit-startup-screen t)
(setq vc-follow-symlinks t)

(require 'projectile)
(projectile-mode 1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Set help window as the active window.
(setq help-window-select 1)

;; Backup files are copied to a temporary directory.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
(setq backup-by-copying t)

;;; general.el ends here
