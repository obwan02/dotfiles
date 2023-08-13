;; --- DISABLE TOOL BARS ---
(menu-bar-mode -1)
(if (boundp 'scroll-bar-mode) (scroll-bar-mode -1))
(tool-bar-mode -1)

;; --- CUSTOM STUFF ---
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(adwaita))
 '(custom-safe-themes
   '("ba4ab079778624e2eadbdc5d9345e6ada531dc3febeb24d257e6d31d5ed02577" default))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(tree-sitter-langs tree-sitter gruber-darker-theme helm evil use-package)))

;; --- PACKAGE MANAGER INIT ---
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages"))

(setq package-enable-at-startup nil)
(package-initialize)

;; Setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Use use-package to install all packages
(use-package evil
  :ensure t
  :config
  (progn (evil-mode t)
	 ;; Requires Emacs >= 28
	 (evil-set-undo-system 'undo-redo))) 

(use-package helm
  :ensure t
  :config (helm-mode t))

(use-package gruber-darker-theme
  :ensure t)

(use-package org
  :ensure t
  :config (progn
	    (setq org-todo-keywords
		  '((sequence "TODO" "PROG" "WAIT" "|" "DONE" "CANCELLED")))

(use-package tree-sitter
  :ensure t)

(use-package tree-sitter-langs
  :ensure t
  :after (tree-sitter)
  :config (progn
	    (global-tree-sitter-mode)
	    (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)))

;; CONFIG

(defun my-asm-mode-hook ()
  ;; you can use `comment-dwim' (M-;) for this kind of behaviour anyway
  (setq tab-width 4) ; or any other preferred value
  (local-unset-key (vector asm-comment-char))
  ;; asm-mode sets it locally to nil, to "stay closer to the old TAB behaviour".
  (setq tab-always-indent (default-value 'tab-always-indent)))

(add-hook 'asm-mode-hook #'my-asm-mode-hook)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
