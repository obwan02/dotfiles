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

(setq package-archive-priorities'
      '(("melpa" . 10)
	("melpa-stable" . 5)
	("org" . 0))
      )

(setq package-enable-at-startup nil)
(package-initialize)

;; Boot-strap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; --- PACKAGES ---


;; Used for producing 'nice'
;; html output from org-mode
(use-package htmlize
  :ensure t)

;; Evil-Mode for Vim style editing
(use-package evil
  :demand t
  :ensure t
  :config
  (progn (evil-mode 1)
	 ;; Requires Emacs >= 28
	 (evil-set-undo-system 'undo-redo)))

;; Mini-buffer completion
(use-package vertico
  :ensure t
  :init (vertico-mode)
  )

;; Used for annotations in the Emacs
;; mini-buffer
(use-package marginalia
  :ensure t
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  :init
  (marginalia-mode))

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
    (setq org-latex-minted-options
	  '(("frame" "lines")
	    ("fontsize" "\\scriptsize")
	    ("linenos" "")
	    ))
    (setq org-preview-latex-process-alist
	  '((dvisvgm :programs
		     ("latex" "dvisvgm")
		     :image-input-type "dvi"
		     :image-output-type "svg"
		     :image-size-adjust (1.7 . 1.5)
		     :latex-compiler
		     ("latex -shell-escape -interaction nonstopmode -output-directory %o %f")
		     :image-converter
		     ("dvisvgm %f -n -b min -c %S -o %O"))
	    )
	  )
    ;; Insert page break after table of contents
    (setq org-latex-toc-command "\\tableofcontents \\clearpage")
    (setq org-latex-create-formula-image-program 'dvisvgm)
    (setq org-latex-pdf-process '("latexmk -f -shell-escape -pdf -%latex -interaction=nonstopmode -output-directory=%o %f"))
    (setq org-latex-classes
		 '(("notes" "\\RequirePackage{fix-cm}
\\PassOptionsToPackage{svgnames}{xcolor}
\\documentclass[11pt]{article}
\\usepackage{fontspec}
\\setmainfont{Arial}
\\setsansfont[Scale=MatchLowercase]{Arial}
\\setmonofont[Scale=MatchLowercase]{Courier New}
\\usepackage{xcolor}
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
[PACKAGES]
[EXTRA]"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\subsubsubsection{%s}" . "\\subsubsubsection*{%s}")
		   ("\\paragraph{%s}" . "\\paragraph*{%s}")
		   ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
		 ("article" "\\documentclass[11pt]{article}"
		  ("\\section{%s}" . "\\section*{%s}")
		  ("\\subsection{%s}" . "\\subsection*{%s}")
		  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		  ("\\paragraph{%s}" . "\\paragraph*{%s}")
		  ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
		 ("report" "\\documentclass[11pt]{report}"
		  ("\\part{%s}" . "\\part*{%s}")
		  ("\\chapter{%s}" . "\\chapter*{%s}")
		  ("\\section{%s}" . "\\section*{%s}")
		  ("\\subsection{%s}" . "\\subsection*{%s}")
		  ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
		 ("book" "\\documentclass[11pt]{book}"
		  ("\\part{%s}" . "\\part*{%s}")
		  ("\\chapter{%s}" . "\\chapter*{%s}")
		  ("\\section{%s}" . "\\section*{%s}")
		  ("\\subsection{%s}" . "\\subsection*{%s}")
		  ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
		 ))
    ;; Setup Code Blocks Langs
    (setq org-confirm-babel-evaluate nil)
    (setq org-babel-python-command "python3")
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((python . t)
       (emacs-lisp . t)
       (shell . t)))
    )

(use-package org-download
  :ensure t
  :after (org)
  :config (progn
	    (setq org-download-method 'attach))
  )

;; --- CONFIG ---

;; OS Dependent
(pcase system-type
  ;; Windows
  ('windows-nt (setq org-agenda-files '("C:\\Users\\obwan\\OneDrive\\OrgMode")))

  ;; Linux
  ('gnu/linux (setq org-agenda-files '("~/OneDrive/OrgMode")))

  ;; MacOS
  ('darwin (message "Setup OneDrive for macOS dummy")))      

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
 '(package-selected-packages '(marginalia org-download helm evil htmlize)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
