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

(use-package htmlize
  :ensure t)

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
  :after (evil htmlize)
  :config
    (setq org-todo-keywords
	  '((sequence "TODO" "PROG" "WAIT" "|" "DONE" "CANCELLED")))
    (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.35))
    (evil-define-key 'normal org-mode-map (kbd "<tab>") #'org-cycle)
    (setq org-latex-compiler "xelatex")
    ;; Setup HTML Exporting
    (setq org-src-fontify-natively t)
    ;; Setup LaTeX Exporting
    (setq org-latex-default-packages-alist
	  '(("" "graphicx" t)
            ("" "grffile" t)
            ("" "longtable" nil)
            ("" "wrapfig" nil)
            ("" "rotating" nil)
            ("normalem" "ulem" t)
            ("" "amsmath" t)
            ("" "textcomp" t)
            ("" "amssymb" t)
            ("" "capt-of" nil)
            ("" "hyperref" nil)))
    (setq org-latex-listings 'minted)
    (setq org-latex-packages-alist '(("" "minted")))
    (setq org-latex-create-formula-image-program 'dvisvgm)
    (setq org-latex-pdf-process '("latexmk -f -shell-escape -pdf -%latex -interaction=nonstopmode -output-directory=%o %f"))
    (setq org-latex-classes
		 '(("fancy" "\\RequirePackage{fix-cm}
\\PassOptionsToPackage{svgnames}{xcolor}
\\documentclass[11pt]{article}
\\usepackage{fontspec}
\\setmainfont{Helvetica}
\\setsansfont[Scale=MatchLowercase]{Helvetica}
\\setmonofont[Scale=MatchLowercase]{Monaco}
\\usepackage{sectsty}
\\allsectionsfont{\\sffamily}
\\usepackage{enumitem}
\\setlist[description]{style=unboxed,font=\\sffamily\\bfseries}
\\usepackage{listings}
\\lstset{frame=single,aboveskip=1em,
	framesep=.5em,backgroundcolor=\\color{AliceBlue},
	rulecolor=\\color{LightSteelBlue},framerule=1pt}
\\usepackage{xcolor}
\\newcommand\\basicdefault[1]{\\scriptsize\\color{Black}\\ttfamily#1}
\\lstset{basicstyle=\\basicdefault{\\spaceskip1em}}
\\lstset{literate=
	    {§}{{\\S}}1
	    {©}{{\\raisebox{.125ex}{\\copyright}\\enspace}}1
	    {«}{{\\guillemotleft}}1
	    {»}{{\\guillemotright}}1
	    {Á}{{\\'A}}1
	    {Ä}{{\\\"A}}1
	    {É}{{\\'E}}1
	    {Í}{{\\'I}}1
	    {Ó}{{\\'O}}1
	    {Ö}{{\\\"O}}1
	    {Ú}{{\\'U}}1
	    {Ü}{{\\\"U}}1
	    {ß}{{\\ss}}2
	    {à}{{\\`a}}1
	    {á}{{\\'a}}1
	    {ä}{{\\\"a}}1
	    {é}{{\\'e}}1
	    {í}{{\\'i}}1
	    {ó}{{\\'o}}1
	    {ö}{{\\\"o}}1
	    {ú}{{\\'u}}1
	    {ü}{{\\\"u}}1
	    {¹}{{\\textsuperscript1}}1
            {²}{{\\textsuperscript2}}1
            {³}{{\\textsuperscript3}}1
	    {ı}{{\\i}}1
	    {—}{{---}}1
	    {’}{{'}}1
	    {…}{{\\dots}}1
            {⮠}{{$\\hookleftarrow$}}1
	    {␣}{{\\textvisiblespace}}1,
	    keywordstyle=\\color{DarkGreen}\\bfseries,
	    identifierstyle=\\color{DarkRed},
	    commentstyle=\\color{Gray}\\upshape,
	    stringstyle=\\color{DarkBlue}\\upshape,
	    emphstyle=\\color{Chocolate}\\upshape,
	    showstringspaces=false,
	    columns=fullflexible,
	    keepspaces=true}
\\usepackage[a4paper,margin=1in,left=1.5in]{geometry}
\\usepackage{parskip}
\\makeatletter
\\renewcommand{\\maketitle}{%
  \\begingroup\\parindent0pt
  \\sffamily
  \\Huge{\\bfseries\\@title}\\par\\bigskip
  \\LARGE{\\bfseries\\@author}\\par\\medskip
  \\normalsize\\@date\\par\\bigskip
  \\endgroup\\@afterindentfalse\\@afterheading}
\\makeatother
[DEFAULT-PACKAGES]
\\hypersetup{linkcolor=Blue,urlcolor=DarkBlue,
  citecolor=DarkRed,colorlinks=true}
\\AtBeginDocument{\\renewcommand{\\UrlFont}{\\ttfamily}}
[PACKAGES]
[EXTRA]"
                   ("\\chapter{%s}" . "\\chapter*{%s}")
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		   ("\\paragraph{%s}" . "\\paragraph*{%s}")
		   ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
		   ))
    ;; Setup Code Blocks Langs
    (setq org-confirm-babel-evaluate nil)
    (setq org-babel-python-command "python3")
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((python . t)
       (emacs-lisp . t))))

(use-package org-download
  :ensure t
  :after (org)
  :config (progn
	    (setq org-download-method 'attach)))

;; (use-package tree-sitter
  ;; :ensure t)
;; 
;; (use-package tree-sitter-langs
  ;; :ensure t
  ;; :after (tree-sitter)
  ;; :config (progn
	    ;; (global-tree-sitter-mode)
	    ;; (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)))

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
 '(package-selected-packages '(htmlize helm org-download evil-visual-mark-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
