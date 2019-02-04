;; Emacs configuration settings.

;; Disable welcome screen.

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq inhibit-startup-screen t)

;; Follow sym-links by default.
(setq vc-follow-symlinks t)

;; Spaces plz.
(setq-default indent-tabs-mode nil)
(setq tab-stop-list (number-sequence 2 120 2))
(setq sh-basic-offset 2)

;; Copy and pasting.
(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)
(xclip-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (xclip))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
