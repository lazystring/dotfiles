;;; init.el --- Emacs startup configuration

;;; Commentary:
;;  This package is loaded on Emacs startup, and configures
;;  Emacs to my liking.

;;; Code:

;; Minimal UI
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(setq visible-bell t)

;; Always follow symlinks
(setq vc-follow-symlinks t)

;; Line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;; Indentation
(setq sh-basic-offset 2)
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
								term-mode-hook
								shell-mode-hook
								eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq display-time-format "%l:%M %p %b %y"
      display-time-default-load-average nil)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Font
(set-face-attribute 'default nil :font "Fira Code Retina" :height 100)
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height 100)
(set-face-attribute 'variable-pitch nil :font "Linux Biolinum" :height 120 :weight 'regular)
(set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
												 ("org" . "https://orgmode.org/elpa/")
												 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package all-the-icons)

(use-package minions
  :hook (doom-modeline-mode . minions-mode))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  ((doom-modeline-height 40)
   (doom-modeline-lsp t)
   (doom-modeline-github nil)
   (doom-modeline-mu4e nil)
   (doom-modeline-irc t)
   (doom-modeline-minor-modes t)
   (doom-modeline-persp-name nil)
   (doom-modeline-buffer-file-name-style 'truncate-except-project)
   (doom-modeline-major-mode-icon nil)
	 (doom-modeline-icon (display-graphic-p))))

(use-package doom-themes
  :init (load-theme 'doom-one t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode 1)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package general
  :config
  (general-create-definer ls/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  
  (ls/leader-keys
		"t"  '(:ignore t :which-key "toggles")
		"tt" '(counsel-load-theme :which-key "choose theme")))

(use-package undo-tree
	:init (global-undo-tree-mode 1)
	:custom ((undo-tree-auto-save-history nil)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after (evil magit)
  :config
  (evil-collection-init))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(ls/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/git")
    (setq projectile-project-search-path '("~/git")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package company
  :init
  (setq company-idle-delay 0)
  :hook (prog-mode . company-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; (use-package forge)

(defun ls/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun ls/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . ls/org-mode-setup)
	:config
	;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

	(require 'org-habit)
	(add-to-list 'org-modules 'org-habit)
	(setq org-habit-graph-column 60)

  :custom
  (org-ellipsis " ▾")

	(org-agenda-start-with-log-mode t)
	(org-log-done 'time)
	(org-log-into-drawer t)

	(org-agenda-files
	 '("~/git/emacs-from-scratch/OrgFiles/Tasks.org"
		 "~/git/emacs-from-scratch/OrgFiles/Birthdays.org"
		 "~/git/emacs-from-scratch/OrgFiles/Habits.org"))

	(org-todo-keywords
	 '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
		 (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w!/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (org-refile-targets
   '(("Archive.org" :maxlevel . 1)
     ("Tasks.org" :maxlevel . 1)))

	;; Configure common tags	
  (org-tag-alist
	 '((:startgroup)
																				; Put mutually exclusive tags here
		 (:endgroup)
		 ("@errand" . ?E)
		 ("@home" . ?H)
		 ("@work" . ?W)
		 ("agenda" . ?a)
		 ("planning" . ?p)
		 ("publish" . ?P)
		 ("batch" . ?b)
		 ("note" . ?n)
		 ("idea" . ?i)))

	;; Configure custom agenda views
  (org-agenda-custom-commands
	 '(("d" "Dashboard"
			((agenda "" ((org-deadline-warning-days 7)))
			 (todo "NEXT"
						 ((org-agenda-overriding-header "Next Tasks")))
			 (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

		 ("n" "Next Tasks"
			((todo "NEXT"
						 ((org-agenda-overriding-header "Next Tasks")))))

		 ("W" "Work Tasks" tags-todo "+work")

		 ;; Low-effort next actions
		 ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
			((org-agenda-overriding-header "Low Effort Tasks")
			 (org-agenda-max-todos 20)
			 (org-agenda-files org-agenda-files)))

		 ("w" "Workflow Status"
			((todo "WAIT"
						 ((org-agenda-overriding-header "Waiting on External")
							(org-agenda-files org-agenda-files)))
			 (todo "REVIEW"
						 ((org-agenda-overriding-header "In Review")
							(org-agenda-files org-agenda-files)))
			 (todo "PLAN"
						 ((org-agenda-overriding-header "In Planning")
							(org-agenda-todo-list-sublevels nil)
							(org-agenda-files org-agenda-files)))
			 (todo "BACKLOG"
						 ((org-agenda-overriding-header "Project Backlog")
							(org-agenda-todo-list-sublevels nil)
							(org-agenda-files org-agenda-files)))
			 (todo "READY"
						 ((org-agenda-overriding-header "Ready for Work")
							(org-agenda-files org-agenda-files)))
			 (todo "ACTIVE"
						 ((org-agenda-overriding-header "Active Projects")
							(org-agenda-files org-agenda-files)))
			 (todo "COMPLETED"
						 ((org-agenda-overriding-header "Completed Projects")
							(org-agenda-files org-agenda-files)))
			 (todo "CANC"
						 ((org-agenda-overriding-header "Cancelled Projects")
							(org-agenda-files org-agenda-files)))))))

  (org-capture-templates
   `(("t" "Tasks / Projects")
     ("tt" "Task" entry (file+olp "~/git/emacs-from-scratch/OrgFiles/Tasks.org" "Inbox")
      "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

     ("j" "Journal Entries")
     ("jj" "Journal" entry
      (file+olp+datetree "~/git/emacs-from-scratch/OrgFiles/Journal.org")
      "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
      ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
      :clock-in :clock-resume
      :empty-lines 1)
     ("jm" "Meeting" entry
      (file+olp+datetree "~/git/emacs-from-scratch/OrgFiles/Journal.org")
      "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
      :clock-in :clock-resume
      :empty-lines 1)

     ("w" "Workflows")
     ("we" "Checking Email" entry (file+olp+datetree "~/git/emacs-from-scratch/OrgFiles/Journal.org")
      "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

     ("m" "Metrics Capture")
     ("mw" "Weight" table-line (file+headline "~/git/emacs-from-scratch/OrgFiles/Metrics.org" "Weight")
      "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (ls/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun ls/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . ls/org-mode-visual-fill))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

(use-package rust-mode)

(use-package racer)

(use-package rjsx-mode
  :config
  (setq js2-basic-offset 2)
  (setq js-indent-level 2)
  (setq sgml-basic-offset 2)
  (setq indent-tabs-mode t))

(use-package mu4e
  :ensure nil
  :load-path "/usr/share/emacs/site-lisp/mu4e/"
  :defer 20 ; Wait until 20 seconds after startup
  :config

  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Mail")

  (setq mu4e-drafts-folder "/[Gmail]/Drafts")
  (setq mu4e-sent-folder   "/[Gmail]/Sent Mail")
  (setq mu4e-refile-folder "/[Gmail]/All Mail")
  (setq mu4e-trash-folder  "/[Gmail]/Trash")

	(setq smtpmail-smtp-server "smtp.gmail.com"
				smtpmail-smtp-service 465
				smtpmail-stream-type 'ssl)

	(setq user-mail-address "johnbojorquez36@gmail.com")
  (setq user-full-name "John Bojorquez")
	(setq message-send-mail-function 'smtpmail-send-it)

  (setq mu4e-maildir-shortcuts
				'((:maildir "/Inbox"    :key ?i)
					(:maildir "/[Gmail]/Sent Mail" :key ?s)
					(:maildir "/[Gmail]/Trash"     :key ?t)
					(:maildir "/[Gmail]/Drafts"    :key ?d)
					(:maildir "/[Gmail]/All Mail"  :key ?a)))

  (setq mu4e-bookmarks
				'((:name "Unread messages" :query "flag:unread AND NOT flag:trashed" :key ?i)
					(:name "Today's messages" :query "date:today..now" :key ?t)
					(:name "Bank deposits" :query "from:email@alerts.ally.com subject:\"A deposit was made\"" :key ?d)
					(:name "Last 7 days" :query "date:7d..now" :hide-unread t :key ?w)
					(:name "Messages with images" :query "mime:image/*" :key ?p)))

  ;; Run in background to sync periodically.
  (mu4e t))

(use-package emojify
  :hook (after-init . global-emojify-mode))
