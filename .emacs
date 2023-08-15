;; --- DISABLE TOOL BARS ---
(menu-bar-mode -1)
(if (boundp 'scroll-bar-mode) (scroll-bar-mode -1))
(tool-bar-mode -1)
(setq inhibit-startup-message t) 

;; --- PACKAGE MANAGER INIT ---
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

;; Boot-strap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; --- PACKAGES ---
(use-package evil
  :demand t
  :ensure t
  :config
  (progn (evil-mode 1)
	 ;; Requires Emacs >= 28
	 (evil-set-undo-system 'undo-redo)))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
	 ("C-x b" . helm-buffers-list)
	 ("C-x r b" . helm-bookmarks)
	 ("C-x C-f" . helm-find-files)
	 ("C-x C-l" . helm-locate)
	 ("C-x M-s o" . helm-occur)))

(use-package org
  :ensure t
  :after evil
  :config
  (progn
    (setq org-todo-keywords
	  '((sequence "TODO" "PROG" "WAIT" "|" "DONE" "CANCELLED")))
    (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.35))
    (evil-define-key 'normal org-mode-map (kbd "<tab>") #'org-cycle)
    ;; Setup LaTeX Exporting
    (setq org-latex-pdf-process '("latexmk -f -pdf -%latex -shell-escape -interaction=nonstopmode -output-directory=%o %f"))
    ;; Setup Code Blocks Langs
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((python . t)
       (emacs-lisp . t)))))

(use-package org-download
  :ensure t
  :after (org)
  :config (progn
	    (setq org-download-method 'attach)))

(use-package tree-sitter
  :ensure t)

(use-package tree-sitter-langs
  :ensure t
  :after (tree-sitter)
  :config (progn
	    (global-tree-sitter-mode)
	    (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)))

;; --- CONFIG ---

;; WINDOW ONLY - PLZ CHANGE IF NOT WINDOWS
(setq org-agenda-files '("C:\\Users\\obwan\\OneDrive\\OrgMode"))

(defun my-asm-mode-hook ()
  ;; you can use `comment-dwim' (M-;) for this kind of behaviour anyway
  (setq tab-width 4) ; or any other preferred value
  (local-unset-key (vector asm-comment-char))
  ;; asm-mode sets it locally to nil, to "stay closer to the old TAB behaviour".
  (setq tab-always-indent (default-value 'tab-always-indent)))


(add-hook 'asm-mode-hook #'my-asm-mode-hook)

;; --- CUSTOM STUFF ---
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-download tree-sitter-langs tree-sitter evil-visual-mark-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
