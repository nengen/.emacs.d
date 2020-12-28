(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;;(require 'doom-themes)

;; Global settings (defaults)
;;(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;;      doom-themes-enable-italic t) ; if nil, italics is universally disabled

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
;(load-theme 'doom-one t)
;; Enable flashing mode-line on errors
;;(doom-themes-visual-bell-config)

;; Enable custom neotree theme (all-the-icons must be installed!)
;(doom-themes-neotree-config)
;; or for treemacs users
;;(doom-themes-treemacs-config)

;; Corrects (and improves) org-mode's native fontification.
;(doom-themes-org-config)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)
(menu-bar-mode -1)          ; Disable the menu bar


;; no start up message
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; removes *messages* from the buffer
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Removes *Completions* from buffer
(add-hook 'minibuffer-exit-hook
	  '(lambda ()
	     (let ((buffer "*Completions*"))
	       (and (get-buffer buffer)
		    (kill-buffer buffer)))))

;; no audible or visual bell when emacs is mad
(setq ring-bell-function 'ignore)

;; font size
(set-face-attribute 'default nil :height 100)

;; turn on line and column numbers
(setq line-number-mode t)
(setq column-number-mode t)

;; default frame size
(add-to-list 'default-frame-alist '(width . 90)
	     '(height . 100))

;; quick toggle fullscreen to match MacOS (Command + Control + f)
(global-set-key (kbd "M-C-f") 'toggle-frame-fullscreen)

(set-frame-parameter (selected-frame) 'alpha '(97 . 97))
  (add-to-list 'default-frame-alist '(alpha . (97 . 97)))
  (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
  (add-to-list 'default-frame-alist '(fullscreen . maximized))

(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

(load-theme 'spacemacs-dark t)

;; Set the font face based on platform
  (set-face-attribute 'default nil :font "Hack")

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Hack")

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Hack" :weight 'regular)

;; use the tab key to make 4 spaces
(setq tab-width 4)
(setq indent-tabs-mode nil)

;; no backup~ files
(setq make-backup-files nil)

;; no #autosave# files
(setq auto-save-default nil)

;; allow upcase (C-x C-u) and downcase (C-x C-l) region
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
; Cycle candidates with C-n and C-p
(setq ac-use-menu-map t)

(setq dw/is-termux
      (string-suffix-p "Android" (string-trim (shell-command-to-string "uname -a"))))

;; jump to other frame (split screen)
(global-set-key [C-tab] 'ace-window)
;; Disable right alt so we can type brackets
(setq mac-right-option-modifier nil)

;; Mac option and command keys to meta (helps with non-Mac external keyboard)
(setq mac-option-key-is-meta t
      mac-command-key-is-meta t
      mac-command-modifier 'meta)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (magit company-lsp pos-tip company eglot treemacs lsp-dart lsp-mode dart-mode neotree doom-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'load-path "c:/Users/Nils-/OneDrive/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-vc-integration nil)

;; All the icons for neotree icons
(require 'all-the-icons)

;; Enable Company Mode in all buffers
(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 1)

(setq dart-format-on-save t)
(setq dart-sdk-path  "C:/Users/Nils-/OneDrive/Skrivebord/flutter/flutter/bin/cache/dart-sdk/")
(setq exec-path (append exec-path '("C:/Program Files (x86)/GnuWin32/bin")))


;; Assist project.el in finding the project root for your dart fike
(defun project-try-dart (dir)
  (let ((project (or (locate-dominating-file dir "pubspec.yaml")
                     (locate-dominating-file dir "BUILD"))))
    (if project
        (cons 'dart project)
      (cons 'transient dir))))
(add-hook 'project-find-functions #'project-try-dart)
(cl-defmethod project-roots ((project (head dart)))
  (list (cdr project)))



;;dart eglot
(require 'eglot)
(add-to-list 'eglot-server-programs '(dart-mode . ("dart_language_server")))
(add-hook 'dart-mode-hook 'eglot-ensure)




(add-hook 'dart-mode-hook (lambda ()
 (set (make-local-variable 'company-backends)
      '(company-dart (company-dabbrev company-yankpad)))))
;(require 'company-lsp)
;(push 'company-lsp company-backends)

(elpy-enable)
 (setq python-shell-interpreter "ipython"
   python-shell-interpreter-args "-i --simple-prompt")

  ;; use flycheck not flymake with elpy
 (when (require 'flycheck nil t)
 (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
 (add-hook 'elpy-mode-hook 'flycheck-mode))





(global-set-key (kbd "C-x g") 'magit-status)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)
   (jupyter . t)))

  (add-to-list 'org-structure-template-alist
   '("el" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC" ""))


  (add-to-list 'org-structure-template-alist
   '("ji" "#+BEGIN_SRC jupyter-python :session py\n?\n#+END_SRC" ""))

(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(use-package org-bullets
    :custom
    (org-hide-leading-stars t)
    :hook org)
(use-package org-superstar
  
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Replace list hyphen with dot
;; (font-lock-add-keywords 'org-mode
;;                         '(("^ *\\([-]\\) "
;;                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

;; TODO: Others to consider
;; '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
;; '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;; '(org-property-value ((t (:inherit fixed-pitch))) t)
;; '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;; '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
;; '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
;; '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(defalias 'lsp--cur-line-diagnotics 'lsp--cur-line-diagnostics)

(use-package helm
    :init
    (setq helm-split-window-default-side 'other)
    (helm-mode 1))

(setenv "PKG_CONFIG_PATH" "/usr/local/Cellar/zlib/1.2.8/lib/pkgconfig:/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig") ;; Zotero
(use-package helm-bibtex
  :custom
  (helm-bibtex-bibliography '("~/zotero.bib"))
  (reftex-default-bibliography '("~/zotero.bib"))
  (bibtex-completion-pdf-field "file")
  :hook (Tex . (lambda () (define-key Tex-mode-map "\C-ch" 'helm-bibtex))))

(use-package org-ref
  :custom
  (org-ref-default-bibliography "~/zotero.bib"))

(defun org-export-latex-no-toc (depth)
  (when depth
    (format "%% Org-mode is exporting headings to %s levels.\n"
	    depth)))
(setq org-export-latex-format-toc-function 'org-export-latex-no-toc)
(add-to-list 'org-latex-classes
             '("apa6"
               "\\documentclass{apa6}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
(setq org-latex-pdf-process
  '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))

(use-package pdf-tools
 :config
 ;; initialise
 (pdf-tools-install)
 ;; open pdfs scaled to fit width
 (setq-default pdf-view-display-size 'fit-width)
 ;; use normal isearch
 (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
 :custom
 (pdf-annot-activate-created-annotations t "automatically annotate highlights"))
